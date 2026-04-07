# Spec 02 — Handle Grip Holes

## Problem

For larger stencils the flat handle tabs are hard to pick up and hold.
Real-world stencils often have finger holes punched through the handles.

## Solution

Add an optional circular cutout centered in each handle tab.

### New parameters

| Section       | Name                  | Default | Range      | Notes                              |
|---------------|-----------------------|---------|------------|------------------------------------|
| `[Handles:]`  | `show_handle_grip`    | false   | [true:false] | Enable grip holes in both handles |
| `[Handles:]`  | `handle_grip_diameter`| 15      | [5:50]     | Diameter of the circular cutout    |

### Implementation

1. Add both parameters in the `[Handles:]` section, after `handle_overlap`.
2. Add assertions:
   - `handle_grip_diameter > 0`
   - `handle_grip_diameter < handle_width` (hole must fit within handle width)
   - `handle_grip_diameter < handle_length` (hole must fit within handle length)
3. Create a new `handle_grip(center_x, center_y)` module that produces a
   cylinder of diameter `handle_grip_diameter` and height `plate_depth + 2`
   (full punch-through with boolean margin).
4. In `build()`, add the grip holes to the `difference()` block alongside
   `svg_cutout()` and `registration_marks()`:
   ```openscad
   if (show_handle_grip && show_handle_1) handle_1_grip();
   if (show_handle_grip && show_handle_2) handle_2_grip();
   ```
5. Each grip module places the cylinder at the centre of the corresponding
   handle tab.
6. Update presets: `show_handle_grip: false` for Standard/Tight Border/Mini,
   `show_handle_grip: true` for Large (2x) and Poster (3x) where handles
   are big enough.
7. Bump version.

### Module sketch

```openscad
module handle_grip(cx, cy) {
    translate([cx, cy, 0])
        cylinder(h = plate_depth + 2, d = handle_grip_diameter, center = true);
}
```

### Risks

- Small handles + large grip diameter could leave too little material.
  The assertions above prevent this, but presets should be checked for
  sensible defaults.
