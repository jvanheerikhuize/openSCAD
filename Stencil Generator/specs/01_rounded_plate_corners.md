# Spec 01 — Rounded Plate Corners

## Problem

The stencil plate is a sharp-cornered rectangle. Sharp corners catch on
surfaces, are uncomfortable to handle, and look less finished compared to
commercial stencils. The comb generator already solves this with a
`rounded_rect()` helper.

## Solution

Add a `plate_corner_radius` parameter and replace the `cube()` in
`stencil_plate()` with a rounded rectangle extrusion.

### New parameter

| Section    | Name                  | Default | Range     | Notes                          |
|------------|-----------------------|---------|-----------|--------------------------------|
| `[Plate:]` | `plate_corner_radius` | 2       | [0:0.5:20] | 0 = sharp corners (current behavior) |

### Implementation

1. Add `plate_corner_radius` parameter in the `[Plate:]` section.
2. Add assertion: `plate_corner_radius >= 0`.
3. Add assertion: `plate_corner_radius <= min(plate_width, plate_length) / 2`
   (radius cannot exceed half the smallest plate dimension).
4. Replace `stencil_plate()` module body:
   - When `plate_corner_radius == 0`: keep current `cube()` for backwards
     compatibility and performance.
   - When `plate_corner_radius > 0`: use `hull()` of four cylinders at the
     corners (same pattern as comb generator's `rounded_rect()`), extruded to
     `plate_depth`.
5. Update `svg_cutout()` clipping box: the intersection cube already clips
   to the SVG bounding box, so no change needed — the SVG cutout is inset
   from the plate edge by `plate_border`.
6. Update all presets in `stencil_generator.json` with
   `plate_corner_radius: 2` (or 0 for Tight Border).
7. Bump version to 1.5.0.

### Module sketch

```openscad
module stencil_plate() {
    if (plate_corner_radius > 0) {
        r = plate_corner_radius;
        hull() {
            for (x = [-plate_width/2 + r, plate_width/2 - r])
                for (y = [-plate_length/2 + r, plate_length/2 - r])
                    translate([x, y, -plate_depth/2])
                        cylinder(h = plate_depth, r = r);
        }
    } else {
        cube([plate_width, plate_length, plate_depth], center = true);
    }
}
```

### Risks

- Registration marks near corners may partially land outside the rounded
  edge. Add assertion: `reg_mark_inset > plate_corner_radius` when both
  features are enabled.
