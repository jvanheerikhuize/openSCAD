/*#################################################################################*\
	   _____ _______ _______      ______ _______ __  __ _______ _______
	 _|     |    ___|_     _|    |   __ \   _   |  |/  |    ___|_     _|
	|       |    ___| |   |      |      <       |     <|    ___| |   |
	|_______|_______| |___|      |___|__|___|___|__|\__|_______| |___|

	-----------------------------------------------------------------------------

	Developed by:           Jerry van Heerikhuize
	Modified by:            Jerry van Heerikhuize

	-----------------------------------------------------------------------------

	Version:                1.0.0
	Creation Date:          03/03/26
	Modification Date:      03/03/26
	Email:                  jvanheerikhuize@gmail.com
	Description:            Customizable comb for OpenSCAD
	Dependencies:           none

\*#################################################################################*/


/*#################################################################################*\

	QUALITY

\*#################################################################################*/

/* [Quality:] */
// Use lower resolution for faster preview; disable for final high-quality render
preview_mode = true; //[true:false]
// Slice the model in half to inspect tooth geometry and spine thickness
show_cross_section = false; //[true:false]


/*#################################################################################*\

	CONFIGURATION

\*#################################################################################*/

/* [Comb:] */
// Thickness of the comb (Z height)
comb_thickness = 3; //[1.5:0.1:8]
// Width of the solid spine the teeth are attached to
spine_width = 15; //[5:1:40]

/* [Teeth:] */
// Length of each tooth from the spine edge to the tip
tooth_length = 25; //[10:1:60]
// Width of each individual tooth at its base
tooth_width = 1.5; //[0.5:0.1:4]
// Gap between adjacent teeth
tooth_gap = 1.5; //[0.5:0.1:4]
// Number of teeth
num_teeth = 45; //[5:1:150]

/* [Personalization:] */
// Text to deboss into the spine (used when use_svg is false)
custom_text = "YOUR TEXT";
// Font size of the debossed text
text_size = 6; //[2:0.5:20]
// Depth of the debossed stamp into the spine surface
stamp_depth = 1.0; //[0.2:0.1:2.5]

/* [SVG Stamp:] */
// Use an SVG file as the stamp instead of text
use_svg = false; //[true:false]
// Path to the SVG file used when use_svg is true
svg_filename = "logo.svg";
// Uniform scale factor applied to the imported SVG
svg_scale = 1.0; //[0.1:0.1:5]


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

// eps — Near-zero value used to give hull() anchor shapes a non-zero area.
// hull() requires closed 2D shapes; a square of height `eps` approximates a line
// without introducing visible geometry or affecting the final model dimensions.
eps = 0.00001;

// ── Derived values ────────────────────────────────────────────────────────────
// Solid margin at each end of the spine beyond the tooth array
end_margin = 2;
// Total physical length of the comb
comb_length = (num_teeth * tooth_width) + ((num_teeth - 1) * tooth_gap) + (end_margin * 2);

// ── Assertions ────────────────────────────────────────────────────────────────
assert(comb_thickness > 0,  "comb_thickness must be positive");
assert(spine_width    > 0,  "spine_width must be positive");
assert(tooth_length   > 0,  "tooth_length must be positive");
assert(tooth_width    > 0,  "tooth_width must be positive");
assert(tooth_gap      > 0,  "tooth_gap must be positive");
assert(num_teeth      >= 1, "num_teeth must be at least 1");
assert(stamp_depth    > 0,  "stamp_depth must be positive");
assert(
	stamp_depth < comb_thickness,
	"stamp_depth must be less than comb_thickness"
);
assert(svg_scale      > 0,  "svg_scale must be positive");
assert(text_size      > 0,  "text_size must be positive");


/*#################################################################################*\

	MAIN

\*#################################################################################*/

assemble();

// Entry point: optionally clips a cross-section, then delegates to build()
module assemble() {
	if (show_cross_section) {
		// Intersect with a half-space on the negative-Y side to expose the
		// tooth and spine profile when viewed from the front
		intersection() {
			build();
			translate([-comb_length / 2, -spine_width / 2, -1])
				cube([comb_length, spine_width / 2, comb_thickness + tooth_length + 2]);
		}
	} else {
		build();
	}
}

// Renders the comb body with the personalization stamp subtracted
module build() {
	translate([-comb_length / 2, -spine_width / 2, 0]) {
		difference() {
			comb_body();
			// Keep the stamp perfectly centred relative to the dynamic length
			translate([comb_length / 2, spine_width / 2, comb_thickness - stamp_depth + 0.01])
				personalization_stamp();
		}
	}
}


/*#################################################################################*\

	COMB BODY

\*#################################################################################*/

// Generates the comb spine with rounded ends and all teeth attached
module comb_body() {
	// Spine: rounded rectangle spanning the full comb length
	rounded_rect(comb_length, spine_width, comb_thickness, 2);

	// Teeth: array of slightly tapered rectangular extrusions
	for (i = [0 : num_teeth - 1]) {
		translate([end_margin + i * (tooth_width + tooth_gap), spine_width - 0.5, 0])
		hull() {
			cube([tooth_width, 1, comb_thickness]);
			// Taper the tooth to a narrower tip
			translate([tooth_width * 0.25, tooth_length, 0])
				cube([tooth_width * 0.5, 1, comb_thickness]);
		}
	}
}

// A rounded rectangle built from four corner cylinders, used for the spine outline.
// Radius `r` is clamped by the caller to a sensible value relative to w and l.
module rounded_rect(l, w, h, r) {
	hull() {
		translate([r,     r,     0]) cylinder(h = h, r = r);
		translate([l - r, r,     0]) cylinder(h = h, r = r);
		translate([r,     w - r, 0]) cylinder(h = h, r = r);
		translate([l - r, w - r, 0]) cylinder(h = h, r = r);
	}
}


/*#################################################################################*\

	PERSONALIZATION

\*#################################################################################*/

// Produces the stamp geometry used to deboss the spine.
// When use_svg is true an SVG is imported and extruded; otherwise text is used.
module personalization_stamp() {
	if (use_svg) {
		linear_extrude(height = stamp_depth + 0.1)
			scale([svg_scale, svg_scale, 1])
				import(svg_filename, center = true);
	} else {
		linear_extrude(height = stamp_depth + 0.1)
			text(custom_text, size = text_size, font = "Arial:style=Bold",
				halign = "center", valign = "center");
	}
}
