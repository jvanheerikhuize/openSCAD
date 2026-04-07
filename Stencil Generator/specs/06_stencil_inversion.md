# Spec 06 — Stencil Inversion Mode

## Problem

The generator only produces positive stencils (SVG shape is cut out).
Some use cases need the inverse: everything *except* the SVG shape is
removed, leaving the SVG as a raised island. This is used for stamps,
masks, and reverse-stencil techniques.

## Solution

Add an `invert_design` toggle that flips the boolean operation in
`svg_cutout()`.

### New parameter

| Section      | Name            | Default | Range          | Notes                          |
|--------------|-----------------|---------|----------------|--------------------------------|
| `[Design:]`  | `invert_design` | false   | [true:false]   | true = cut everything except SVG |

### Implementation

1. Add `invert_design` in the `[Design:]` section.
2. Modify `build()` to handle the two modes:
   - **Normal (false):** current behaviour — `difference()` subtracts
     `svg_cutout()` from the plate.
   - **Inverted (true):** `intersection()` of the plate with the
     SVG extrusion, so only the SVG shape remains as solid material.
     Registration marks and handles are still applied normally via
     `difference()` / `union()`.

### Module sketch

```openscad
module build() {
    difference() {
        union() {
            if (invert_design) {
                // Keep only where plate and SVG overlap
                intersection() {
                    stencil_plate();
                    svg_extrusion();
                }
            } else {
                // Normal: full plate minus SVG
                difference() {
                    stencil_plate();
                    svg_cutout();
                }
            }
            if (show_handle_1) handle_1();
            if (show_handle_2) handle_2();
        }
        if (show_registration_marks) registration_marks();
    }
}
```

3. Extract the SVG extrusion into a shared helper so both modes use the
   same scaled/clipped SVG geometry.
4. Update presets with `invert_design: false`.
5. Bump version.

### Risks

- In inverted mode, thin SVG features become thin solid material —
  structurally fragile. This is inherent to the technique; no assertion
  can guard against it generically. Document in the parameter comment.
- Inverted mode with registration marks still subtracts the marks from
  the remaining material, which may cut into the SVG island.
  Consider disabling registration marks automatically or warning via
  assertion when both `invert_design` and `show_registration_marks`
  are true.
