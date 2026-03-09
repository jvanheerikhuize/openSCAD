/*#################################################################################*\
	   _____ _______ _______      ______ _______ __  __ _______ _______
	 _|     |    ___|_     _|    |   __ \   _   |  |/  |    ___|_     _|
	|       |    ___| |   |      |      <       |     <|    ___| |   |
	|_______|_______| |___|      |___|__|___|___|__|\__|_______| |___|

	-----------------------------------------------------------------------------

	Developed by:           Jerry van Heerikhuize
	Modified by:            Jerry van Heerikhuize

	-----------------------------------------------------------------------------

	Version:                1.3.0
	Creation Date:          25/01/25
	Modification Date:      07/03/26
	Email:                  jvanheerikhuize@gmail.com
	Description:            Customizable stencil generator for OpenSCAD
	Dependencies:           none

\*#################################################################################*/


/*#################################################################################*\

    QUALITY

\*#################################################################################*/

/* [Quality:] */
// Use lower resolution for faster preview; disable for final high-quality render
preview_mode = true; //[true:false]
// Slice the model in half to inspect the plate profile and cutout depth
show_cross_section = false; //[true:false]


/*#################################################################################*\

    CONFIGURATION

\*#################################################################################*/

/* [SVG:] */
// Filename of the SVG to import — must be in the same folder as this .scad file
svg_file = "_skull.svg";
// Natural width of the SVG artwork as imported by OpenSCAD, in mm.
// To find this value: import your SVG with svg_scale=1 and measure it in the OpenSCAD viewport,
// or check Document Properties in Inkscape (divide pixel value by 3.7795 to convert to mm).
svg_width = 100; //[1:999]
// Natural height of the SVG artwork as imported by OpenSCAD, in mm
svg_height = 100; //[1:999]
// Uniform scale factor applied to the imported SVG artwork
svg_scale = 1; //[0.1:0.1:10]
// Minimum distance between the SVG cutout and the plate edge, in mm.
// The plate automatically grows by 2 × min_border around the scaled SVG.
min_border = 10; //[0:50]

/* [Stencil Plate:] */
// Thickness of the stencil plate along the Z-axis, in mm
stencil_depth = 3; //[1:20]

/* [Handles:] */
// Enable handle 1 (positive-Y side of the stencil)
show_handle_1 = true; //[true:false]
// Enable handle 2 (negative-Y side of the stencil, opposite handle 1)
show_handle_2 = true; //[true:false]
// Width of the handle tab along the X-axis, in mm
handle_width = 30; //[5:100]
// Length the handle tab protrudes beyond the plate edge, in mm
handle_length = 40; //[5:200]
// How far the handle overlaps into the plate edge to ensure a watertight union
handle_overlap = 1; //[0:10]

/* [Registration Marks:] */
// Cut crosshair alignment marks into all four corners of the plate
show_registration_marks = true; //[true:false]
// Total length of each crosshair arm, in mm
reg_mark_size = 10; //[3:30]
// Width of each crosshair arm, in mm
reg_mark_width = 1; //[0.5:0.1:5]
// Distance from the plate corner to the centre of the crosshair, in mm
reg_mark_inset = 8; //[3:30]


/*#################################################################################*\

    HIDDEN

\*#################################################################################*/

/* [Hidden] */
// $fa — Minimum angle (degrees) between polygon vertices on curved surfaces.
// Lower values produce smoother curves at the cost of more triangles.
// 5° gives a usable preview; 1° is suitable for final render.
$fa = preview_mode ? 5   : 1;

// $fs — Minimum segment length (mm) on curved surfaces.
// Acts as a second constraint alongside $fa — whichever produces fewer segments wins.
// 0.5mm is adequate for preview; 0.1mm ensures smooth edges on small features.
$fs = preview_mode ? 0.5 : 0.1;

// ── Derived values ────────────────────────────────────────────────────────────
// Plate dimensions are computed from the scaled SVG plus the border on each side
stencil_width  = svg_width  * svg_scale + 2 * min_border;
stencil_length = svg_height * svg_scale + 2 * min_border;

// ── Assertions ────────────────────────────────────────────────────────────────
assert(len(svg_file)  > 0,  "svg_file must not be empty");
assert(svg_width      > 0,  "svg_width must be positive");
assert(svg_height     > 0,  "svg_height must be positive");
assert(svg_scale      > 0,  "svg_scale must be positive");
assert(min_border     >= 0, "min_border must be zero or positive");
assert(stencil_depth  > 0,  "stencil_depth must be positive");
assert(handle_width   > 0,  "handle_width must be positive");
assert(handle_length  > 0,  "handle_length must be positive");
assert(handle_overlap >= 0, "handle_overlap must be zero or positive");
assert(reg_mark_size  > 0,  "reg_mark_size must be positive");
assert(reg_mark_width > 0,  "reg_mark_width must be positive");
assert(reg_mark_inset > 0,  "reg_mark_inset must be positive");
assert(
    !show_registration_marks || reg_mark_inset + reg_mark_size / 2 < stencil_width  / 2,
    "registration mark extends beyond plate width — reduce reg_mark_size or reg_mark_inset"
);
assert(
    !show_registration_marks || reg_mark_inset + reg_mark_size / 2 < stencil_length / 2,
    "registration mark extends beyond plate length — reduce reg_mark_size or reg_mark_inset"
);


/*#################################################################################*\

    MAIN

\*#################################################################################*/

assemble();

// Entry point: optionally clips a cross-section, then delegates to build()
module assemble() {
    if (show_cross_section) {
        // Intersect with a half-space on the negative-X side to expose the
        // plate profile and cutout depth when viewed from the front.
        // The clip volume is tall enough to include both handle tabs.
        intersection() {
            build();
            translate([
                -(stencil_width / 2 + 1),
                -(stencil_length / 2 + handle_length + 1),
                -(stencil_depth / 2 + 1)
            ])
                cube([stencil_width / 2 + 1, stencil_length + 2 * handle_length + 2, stencil_depth + 2]);
        }
    } else {
        build();
    }
}

// Assembles the full stencil: plate and handles as a union, with the SVG cutout
// and registration marks subtracted in a single difference operation
module build() {
    difference() {
        union() {
            stencil_plate();
            if (show_handle_1) handle_1();
            if (show_handle_2) handle_2();
        }
        svg_cutout();
        if (show_registration_marks) registration_marks();
    }
}


/*#################################################################################*\

    STENCIL PLATE

\*#################################################################################*/

// Flat rectangular plate that forms the stencil body
module stencil_plate() {
    cube([stencil_width, stencil_length, stencil_depth], center = true);
}


/*#################################################################################*\

    HANDLES

\*#################################################################################*/

// Handle 1: a flat tab extending outward from the positive-Y plate edge.
// Overlaps the plate by `handle_overlap` mm to ensure a watertight union.
module handle_1() {
    translate([
        -handle_width / 2,
        stencil_length / 2 - handle_overlap,
        -stencil_depth / 2
    ])
        cube([handle_width, handle_length + handle_overlap, stencil_depth]);
}

// Handle 2: a flat tab on the negative-Y side, placed symmetrically opposite handle 1.
module handle_2() {
    translate([
        -handle_width / 2,
        -(stencil_length / 2 + handle_length),
        -stencil_depth / 2
    ])
        cube([handle_width, handle_length + handle_overlap, stencil_depth]);
}


/*#################################################################################*\

    REGISTRATION MARKS

\*#################################################################################*/

// Cuts crosshair alignment marks into all four corners of the plate.
// Each crosshair centre is inset `reg_mark_inset` mm from both edges at that corner.
module registration_marks() {
    corners = [
        [ stencil_width / 2 - reg_mark_inset,  stencil_length / 2 - reg_mark_inset],
        [-stencil_width / 2 + reg_mark_inset,  stencil_length / 2 - reg_mark_inset],
        [ stencil_width / 2 - reg_mark_inset, -stencil_length / 2 + reg_mark_inset],
        [-stencil_width / 2 + reg_mark_inset, -stencil_length / 2 + reg_mark_inset],
    ];
    for (c = corners) {
        translate([c[0], c[1], 0]) {
            // Horizontal arm
            cube([reg_mark_size, reg_mark_width, stencil_depth + 2], center = true);
            // Vertical arm
            cube([reg_mark_width, reg_mark_size, stencil_depth + 2], center = true);
        }
    }
}


/*#################################################################################*\

    SVG CUTOUT

\*#################################################################################*/

// Extrudes the SVG artwork through the full plate thickness to create the cutout.
// Scale is applied to the 2D profile only, keeping the extrusion height exact.
// The cutout is clipped to the scaled SVG bounding box, so any SVG geometry that
// overflows its natural canvas boundary cannot cut through the plate border.
// The extrusion is 2 mm taller than the plate to guarantee a clean boolean cut.
module svg_cutout() {
    intersection() {
        cube([svg_width * svg_scale, svg_height * svg_scale, stencil_depth + 2], center = true);
        linear_extrude(height = stencil_depth + 2, center = true, convexity = 100) {
            scale([svg_scale, svg_scale]) {
                import(svg_file, center = true);
            }
        }
    }
}
