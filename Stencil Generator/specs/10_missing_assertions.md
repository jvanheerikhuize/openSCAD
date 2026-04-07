# Spec 10 — Missing Assertions

## Problem

Two edge cases lack explicit validation:

1. **Handle wider than plate** — `handle_width` can exceed `plate_width`,
   producing a handle that sticks out on both sides of the plate.
2. **Derived SVG dimensions** — `scaled_svg_width` and `scaled_svg_height`
   are guaranteed positive by the input assertions, but there is no
   explicit check. A direct assertion on the derived values gives a
   clearer error if someone modifies the derivation logic in the future.

## Solution

Add targeted assertions in the existing assertions block.

### New assertions

```openscad
assert(
    handle_width <= plate_width,
    "handle_width must not exceed plate_width"
);
assert(
    handle_length > 0,
    "handle_length must be positive"
);
assert(
    scaled_svg_width > 0,
    "scaled SVG width must be positive (check svg_native_width and design_scale)"
);
assert(
    scaled_svg_height > 0,
    "scaled SVG height must be positive (check svg_native_height and design_scale)"
);
```

### Implementation

1. Add the assertions after the existing block.
2. No parameter, preset, or module changes.
3. Bump version.

### Risks

- The `handle_width <= plate_width` assertion could break existing
  presets or user configurations where the handle intentionally extends
  beyond the plate. Review all presets — current presets are all fine
  (largest handle_width is 50, smallest plate_width is 55).
