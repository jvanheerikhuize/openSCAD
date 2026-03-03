/*#################################################################################*\
	   _____ _______ _______      ______ _______ __  __ _______ _______
	 _|     |    ___|_     _|    |   __ \   _   |  |/  |    ___|_     _|
	|       |    ___| |   |      |      <       |     <|    ___| |   |
	|_______|_______| |___|      |___|__|___|___|__|\__|_______| |___|

	-----------------------------------------------------------------------------

	Developed by:           Jerry van Heerikhuize
	Modified by:            Jerry van Heerikhuize

	-----------------------------------------------------------------------------

	Version:                2.0.0
	Creation Date:          28/11/20
	Modification Date:      03/03/26
	Email:                  jvanheerikhuize@gmail.com
	Description:            Customizable two-part mold generator for OpenSCAD
	Dependencies:           none

\*#################################################################################*/


/*#################################################################################*\

    QUALITY

\*#################################################################################*/

/* [Quality:] */
// Use lower resolution for faster preview; disable for final high-quality render
preview_mode = true; //[true:false]
// Slice both mold halves to expose the cavity geometry for inspection
show_cross_section = false; //[true:false]


/*#################################################################################*\

    CONFIGURATION

\*#################################################################################*/

/* [Object:] */
// Filename of the STL to make a mold of — must be in the same folder as this file
object_file = "_skull.stl";
// Uniform scale factor applied to the imported object (1 = 100%)
object_scale = 1; //[0.01:0.01:2]
// Show a transparent overlay of the object for positioning; disable for final render
object_preview = true; //[true:false]

/* [Object Rotation:] */
// Rotation of the object around the X-axis (degrees)
object_rotation_x = 0; //[-180:180]
// Rotation of the object around the Y-axis (degrees)
object_rotation_y = -90; //[-180:180]
// Rotation of the object around the Z-axis (degrees)
object_rotation_z = 0; //[-180:180]

/* [Object Translation:] */
// Moves the object along the X-axis (mm)
object_translate_x = 25; //[-100:100]
// Moves the object along the Y-axis (mm)
object_translate_y = 0; //[-100:100]
// Moves the object along the Z-axis (mm)
object_translate_z = 0; //[-100:100]

/* [Mold:] */
// Width of one mold half (X-axis, mm)
mold_width = 75; //[10:500]
// Length of one mold half (Y-axis, mm)
mold_length = 70; //[10:500]
// Depth/height of one mold half (Z-axis, mm)
mold_depth = 23; //[10:500]
// Visual gap between the two halves in the preview layout
mold_gap = 10; //[0:100]

/* [Pouring Hole:] */
// Radius of the pouring channel at the entry point
pouring_hole_r1 = 4; //[1:100]
// Radius of the pouring channel at the cavity end (creates a taper)
pouring_hole_r2 = 3; //[1:100]
// Fine-tune the channel position (applied in the rotated axis frame —
// translate_x shifts depth into the mold, translate_z shifts vertically)
pouring_hole_translate_x = 0; //[-100:100]
pouring_hole_translate_y = 0; //[-100:100]
pouring_hole_translate_z = 0; //[-100:100]

/* [Registration Marks:] */
// Diameter of the spherical alignment pegs and sockets
registration_mark_size = 7; //[3:20]
// Distance from the mold edge to the centre of each registration mark
registration_mark_margin = 3; //[0:10]
// Size reduction applied to the socket sphere to provide fit clearance
registration_mark_clearance = 0.2; //[0:0.1:1]


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
// Distance from each mold edge to the centre of its registration mark
mark_inset  = registration_mark_size / 2 + registration_mark_margin;
// Z coordinate of the parting face (top surface of each mold half)
parting_z   = mold_depth / 2;
// X distance from the world origin to the centre of each mold half in the preview
half_offset = mold_width / 2 + mold_gap / 2;

// ── Assertions ────────────────────────────────────────────────────────────────
assert(mold_width                  > 0,  "mold_width must be positive");
assert(mold_length                 > 0,  "mold_length must be positive");
assert(mold_depth                  > 0,  "mold_depth must be positive");
assert(mold_gap                    >= 0, "mold_gap must be zero or positive");
assert(object_scale                > 0,  "object_scale must be positive");
assert(pouring_hole_r1             > 0,  "pouring_hole_r1 must be positive");
assert(pouring_hole_r2             > 0,  "pouring_hole_r2 must be positive");
assert(registration_mark_size      > 0,  "registration_mark_size must be positive");
assert(registration_mark_margin    >= 0, "registration_mark_margin must be zero or positive");
assert(registration_mark_clearance >= 0, "registration_mark_clearance must be zero or positive");
assert(
    mark_inset < mold_width / 2 && mark_inset < mold_length / 2,
    "Registration marks extend outside the mold — reduce registration_mark_size or registration_mark_margin"
);


/*#################################################################################*\

    MAIN

\*#################################################################################*/

assemble();

// Entry point: optionally clips a cross-section, then delegates to build()
module assemble() {
    if (show_cross_section) {
        // Bisect both halves along Y = 0, keeping the negative-Y front half.
        // Both mold halves are centred at Y = 0, so this cut goes through the
        // middle of each, exposing the cavity profile of both simultaneously.
        intersection() {
            build();
            translate([-500, -500, -500]) cube([1000, 500, 1000]);
        }
    } else {
        build();
    }
}

// Renders both mold halves side by side.
//
// ── To export each half individually ──────────────────────────────────────────
// Comment out one line below, then press F6 (Render) and F7 (Export STL).
// Restore both lines to return to the full preview.
module build() {
    mold_a();
    mold_b();
}


/*#################################################################################*\

    MOLD HALVES

\*#################################################################################*/

// Part A: positioned to the left in the preview with its cavity face up.
module mold_a() {
    translate([-half_offset, 0, 0]) {
        mold_half(mirrored = false);
    }
}

// Part B: positioned to the right in the preview. The mirror([1, 0, 0]) creates
// a mirror image so that when Part B is physically flipped over it mates with
// Part A along their shared parting face.
module mold_b() {
    translate([half_offset, 0, 0]) {
        mirror([1, 0, 0]) {
            mold_half(mirrored = true);
        }
    }
}

// Shared geometry for one mold half. Both parts use this module; the outer
// mirror() in mold_b() handles the physical flip for the second part.
//
// Registration marks occupy opposite diagonal corners of the parting face.
// When mirrored = true the corner signs are swapped so that after the outer
// mirror() each peg aligns with the matching socket on the other half.
module mold_half(mirrored = false) {
    sign   = mirrored ?  1 : -1;
    peg_x  =  sign * (mold_width  / 2 - mark_inset);
    peg_y  = -sign * (mold_length / 2 - mark_inset);
    hole_x = -peg_x;
    hole_y = -peg_y;

    difference() {
        union() {
            mold_block();
            // Raised hemisphere peg protruding from the parting face
            translate([peg_x, peg_y, parting_z]) {
                registration_mark_peg();
            }
        }
        // Recessed hemisphere socket cut into the parting face
        translate([hole_x, hole_y, parting_z]) {
            registration_mark_hole();
        }
        // Horizontal pouring channel from the outer edge to the parting plane
        pouring_hole();
        // Object cavity: the negative impression of the object
        translate([0, 0, parting_z]) {
            object_import(mirrored);
        }
    }

    // Optional transparent overlay showing the object for positioning
    if (object_preview) {
        translate([0, 0, parting_z]) {
            object_import(mirrored, preview = true);
        }
    }
}


/*#################################################################################*\

    MOLD BLOCK

\*#################################################################################*/

// The solid rectangular block that forms the body of one mold half.
// All features (cavity, pouring channel, registration marks) are cut from this.
module mold_block() {
    cube(size = [mold_width, mold_length, mold_depth], center = true);
}


/*#################################################################################*\

    POURING HOLE

\*#################################################################################*/

// Horizontal tapered channel running from the outer face of the mold to the
// parting plane. When both assembled halves are held together, their two channels
// meet to form a complete through-hole for injecting or pouring casting material.
// The channel centre sits at one quarter of the mold width from the parting plane.
module pouring_hole() {
    translate([-(mold_width / 4), 0, parting_z]) {
        rotate([0, 90, 0]) {
            // User offsets applied in the rotated frame: translate_x shifts depth
            // into the mold along the channel axis, translate_z shifts vertically.
            translate([pouring_hole_translate_x, pouring_hole_translate_y, pouring_hole_translate_z]) {
                cylinder(
                    h      = mold_width / 2,
                    r1     = pouring_hole_r1,
                    r2     = pouring_hole_r2,
                    center = true
                );
            }
        }
    }
}


/*#################################################################################*\

    REGISTRATION MARKS

\*#################################################################################*/

// Raised hemisphere peg on the parting face.
// Seats into the matching socket on the opposing half to align the two parts.
module registration_mark_peg() {
    sphere(d = registration_mark_size);
}

// Recessed hemisphere socket on the parting face.
// Diameter is reduced by `registration_mark_clearance` relative to the peg
// so the halves close snugly without needing to be forced.
module registration_mark_hole() {
    sphere(d = registration_mark_size - registration_mark_clearance);
}


/*#################################################################################*\

    OBJECT IMPORT

\*#################################################################################*/

// Imports the STL and applies all user-defined scale, rotation, and translation.
// The object is positioned relative to the parting face so its lower half embeds
// in the mold cavity.
//
// When mirrored = true (Part B) the Y/Z rotations and X translation are negated
// to create the complementary cavity for the opposite side of the object.
//
// When preview = true the geometry renders as a transparent highlight using
// OpenSCAD's % (ghost) and # (highlight) modifiers rather than as solid material.
module object_import(mirrored = false, preview = false) {
    x_sign = mirrored ? -1 :  1;
    rot_y  = mirrored ? -object_rotation_y : object_rotation_y;
    rot_z  = mirrored ? -object_rotation_z : object_rotation_z;

    scale(object_scale) {
        translate([x_sign * object_translate_x, object_translate_y, object_translate_z]) {
            rotate([object_rotation_x, rot_y, rot_z]) {
                if (preview) {
                    %#import(object_file);
                } else {
                    import(object_file);
                }
            }
        }
    }
}
