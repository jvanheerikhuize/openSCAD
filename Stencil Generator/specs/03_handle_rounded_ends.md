# Spec 03 — Handle Rounded Ends

## Problem

Handle tabs are plain rectangles with sharp outer corners. This feels
rough in hand and looks unfinished. Rounding the outer end of each
handle matches the rounded plate corners (spec 01) and improves grip.

## Solution

Round the outer short edge of each handle tab using hull + cylinders.
Reuse the `plate_corner_radius` parameter (from spec 01) so handles
visually match the plate.

### Dependencies

- Spec 01 (Rounded Plate Corners) — shares `plate_corner_radius`.
  If spec 01 is not implemented, add a dedicated `handle_corner_radius`
  parameter instead.

### Implementation

1. Replace the `cube()` in `handle_1()` and `handle_2()` (or the unified
   `handle(side)` if spec 09 is done first) with a hull of four cylinders,
   where only the two outer corners use `plate_corner_radius` and the two
   inner corners (against the plate edge) stay sharp (radius ≈ 0) to
   maintain a flush union.
2. When `plate_corner_radius == 0`, keep the current `cube()` behaviour
   — no rounding needed.
3. Add assertion: `plate_corner_radius <= min(handle_width, handle_length) / 2`.
4. Update presets — no new parameter values needed if reusing
   `plate_corner_radius`.
5. Bump version.

### Module sketch

```openscad
module handle_tab(width, length, depth, r) {
    if (r > 0) {
        hull() {
            // Inner edge (flush with plate) — sharp
            translate([0, 0, 0])       cylinder(h = depth, r = 0.01);
            translate([width, 0, 0])   cylinder(h = depth, r = 0.01);
            // Outer edge — rounded
            translate([r, length - r, 0])       cylinder(h = depth, r = r);
            translate([width - r, length - r, 0]) cylinder(h = depth, r = r);
        }
    } else {
        cube([width, length, depth]);
    }
}
```

### Risks

- If `plate_corner_radius` is very large relative to handle dimensions,
  the hull collapses to a weird shape. The assertion guards against this.
