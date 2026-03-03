/*#################################################################################*\
	   _____ _______ _______      ______ _______ __  __ _______ _______
	 _|     |    ___|_     _|    |   __ \   _   |  |/  |    ___|_     _|
	|       |    ___| |   |      |      <       |     <|    ___| |   |
	|_______|_______| |___|      |___|__|___|___|__|\__|_______| |___|

	-----------------------------------------------------------------------------

	Developed by:           Jerry van Heerikhuize
	Modified by:            Jerry van Heerikhuize

	-----------------------------------------------------------------------------

	Version:                1.2.0
	Creation Date:          24/10/20
	Modification Date:      03/03/26
	Email:                  jvanheerikhuize@gmail.com
	Description:            Customizable funnel for OpenSCAD
	Dependencies:           none

\*#################################################################################*/


/*#################################################################################*\

    QUALITY

\*#################################################################################*/

/* [Quality:] */
// Use lower resolution for faster preview; disable for final high-quality render
preview_mode = true; //[true:false]
// Slice the model in half to inspect wall thickness and internal geometry
show_cross_section = false; //[true:false]


/*#################################################################################*\

    CONFIGURATION

\*#################################################################################*/

/* [Bowl:] */
// Inner radius of the bowl at its widest (top) opening
bowl_inner_radius = 50; //[1:999]
// Height of the bowl section
bowl_height = 70; //[1:999]
// Number of flat sides for the bowl and stem (0 = circular, 3+ = polygonal)
bowl_sides = 0; //[0:32]

/* [Stem:] */
// Inner radius of the stem at the bottom opening
stem_radius_bottom = 7; //[1:999]
// Inner radius of the stem at the top, where it meets the bowl transition
stem_radius_top = 7; //[1:999]
// Height of the stem section
stem_height = 50; //[1:999]

/* [Handle 1:] */
// Enable handle 1 (positive-Y side of the funnel)
show_handle_1 = true; //[true:false]
handle_1_width  = 20;
handle_1_length = 80;

/* [Handle 2:] */
// Enable handle 2 (negative-Y side of the funnel, opposite handle 1)
show_handle_2 = true; //[true:false]
handle_2_width  = 20;
handle_2_length = 80;

/* [Drip Guard:] */
// Horizontal lip at the top rim to stop overflow running down the outside
show_drip_guard = true; //[true:false]
// How far the guard protrudes beyond the outer funnel wall
drip_guard_width  = 5;
// Vertical height of the drip guard ring
drip_guard_height = 2;

/* [Extra:] */
// Wall thickness — exact on vertical (stem) surfaces; angled bowl walls will be
// slightly thinner proportional to their slope angle
wall_thickness = 2;
// Radius of the rounded fillet connecting the stem to the bowl
transition_curve_radius = 20;
// How far handles extend into the funnel wall to ensure a watertight union
handle_overlap = 1;


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
funnel_height     = stem_height + bowl_height;
bowl_outer_radius = bowl_inner_radius + wall_thickness;
rim_z             = funnel_height;

// ── Assertions ────────────────────────────────────────────────────────────────
assert(bowl_inner_radius       > 0,  "bowl_inner_radius must be positive");
assert(bowl_height             > 0,  "bowl_height must be positive");
assert(stem_radius_bottom      > 0,  "stem_radius_bottom must be positive");
assert(stem_radius_top         > 0,  "stem_radius_top must be positive");
assert(stem_height             > 0,  "stem_height must be positive");
assert(wall_thickness          > 0,  "wall_thickness must be positive");
assert(transition_curve_radius > 0,  "transition_curve_radius must be positive");
assert(handle_overlap          >= 0, "handle_overlap must be zero or positive");
assert(drip_guard_width        > 0,  "drip_guard_width must be positive");
assert(drip_guard_height       > 0,  "drip_guard_height must be positive");
assert(
    stem_radius_top + transition_curve_radius <= bowl_inner_radius,
    "stem_radius_top + transition_curve_radius must not exceed bowl_inner_radius"
);
assert(
    bowl_sides == 0 || bowl_sides >= 3,
    "bowl_sides must be 0 (circular) or 3 or more"
);


/*#################################################################################*\

    MAIN

\*#################################################################################*/

assemble();

// Entry point: optionally clips a cross-section, then delegates to build()
module assemble() {
    if (show_cross_section) {
        // Intersect with a half-space on the negative-X side to expose the
        // internal wall profile when viewed from the front
        intersection() {
            build();
            translate([-500, -500, -1]) cube([500, 1000, funnel_height + 2]);
        }
    } else {
        build();
    }
}

// Renders the funnel body and all enabled accessories
module build() {
    funnel();
    if (show_handle_1)   handle_1();
    if (show_handle_2)   handle_2();
    if (show_drip_guard) drip_guard();
}


/*#################################################################################*\

    HANDLES

\*#################################################################################*/

// Handle 1: a flat tab extending outward from the positive-Y side of the rim.
// Starts `handle_overlap` mm inside the bowl wall for a watertight union.
module handle_1() {
    translate([
        -(handle_1_width / 2),
        bowl_inner_radius - handle_overlap,
        rim_z - wall_thickness
    ]) {
        cube([handle_1_width, handle_1_length, wall_thickness]);
    }
}

// Handle 2: a flat tab on the negative-Y side, placed symmetrically opposite
// to handle 1. Also overlaps the bowl wall by `handle_overlap`.
module handle_2() {
    translate([
        -(handle_2_width / 2),
        -(bowl_inner_radius - handle_overlap) - handle_2_length,
        rim_z - wall_thickness
    ]) {
        cube([handle_2_width, handle_2_length, wall_thickness]);
    }
}


/*#################################################################################*\

    DRIP GUARD

\*#################################################################################*/

// A flat ring flush with the top rim that prevents overflow from running
// down the outside of the funnel.
module drip_guard() {
    translate([0, 0, rim_z - drip_guard_height]) {
        rotate_extrude($fn = bowl_sides) {
            // Cross-section spans the full wall thickness plus the guard extension,
            // aligned with the inner bowl surface so no gap is left at the rim
            translate([bowl_inner_radius, 0]) {
                square([wall_thickness + drip_guard_width, drip_guard_height]);
            }
        }
    }
}


/*#################################################################################*\

    FUNNEL BODY

\*#################################################################################*/

// Generates the funnel shell by revolving a 2D wall cross-section 360° around
// the Z axis. The hollow cavity is formed by subtracting a copy of the outer
// profile shifted radially inward by `wall_thickness`.
module funnel() {
    rotate_extrude($fn = bowl_sides) {
        difference() {
            profile();
            // Shift the profile inward (toward larger X = larger radius) to
            // hollow out the interior. Wall thickness is exact on vertical surfaces;
            // on angled bowl walls the perpendicular thickness is proportionally less.
            translate([wall_thickness, 0]) profile();
        }
    }
}

// 2D outer profile of the funnel wall, used as input to rotate_extrude.
// hull() across three anchor shapes defines the wall boundary:
//   1. A thin square at the base of the stem (bottom opening)
//   2. A tangent circle forming the smooth stem-to-bowl fillet
//   3. A thin square at the top rim of the bowl (top opening)
module profile() {
    hull() {
        // Stem bottom: anchors the base of the wall profile at the bottom opening
        translate([stem_radius_bottom, 0]) {
            square([wall_thickness, eps]);
        }

        // Stem-to-bowl fillet: smooth transition tangent to both the vertical
        // stem wall and the angled bowl wall
        translate([stem_radius_top + transition_curve_radius, stem_height]) {
            circle(r = transition_curve_radius);
        }

        // Bowl top rim: anchors the top of the wall profile at the rim
        translate([bowl_inner_radius, rim_z - eps]) {
            square([wall_thickness, eps]);
        }
    }
}
