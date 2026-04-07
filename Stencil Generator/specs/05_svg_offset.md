# Spec 05 — SVG X/Y Offset

## Problem

The SVG cutout is always centered on the plate. Some designs need
intentional off-center placement — e.g. a logo positioned in the upper
third of the stencil, or shifted to leave room for text on one side.

## Solution

Add X and Y offset parameters that shift the SVG cutout relative to the
plate centre.

### New parameters

| Section      | Name              | Default | Range         | Notes                              |
|--------------|-------------------|---------|---------------|------------------------------------|
| `[Design:]`  | `design_offset_x` | 0       | [-500:500]    | Horizontal shift in mm (post-scale)|
| `[Design:]`  | `design_offset_y` | 0       | [-500:500]    | Vertical shift in mm (post-scale)  |

### Implementation

1. Add both parameters in the `[Design:]` section, after `design_scale`.
2. Wrap the `svg_cutout()` content in a `translate()`:
   ```openscad
   module svg_cutout() {
       translate([design_offset_x, design_offset_y, 0])
       intersection() {
           cube([scaled_svg_width, scaled_svg_height, plate_depth + 2], center = true);
           linear_extrude(height = plate_depth + 2, center = true, convexity = 100) {
               scale([design_scale, design_scale]) {
                   import(svg_file, center = true);
               }
           }
       }
   }
   ```
3. The intersection bounding box moves with the offset, so the cutout is
   still clipped to the SVG's own bounds — it won't cut into the border
   on the offset side. However, on the opposite side there will be extra
   border space. This is the intended behaviour.
4. Add assertions:
   - `abs(design_offset_x) + scaled_svg_width/2 <= plate_width/2`
     (SVG must stay within the plate bounds)
   - `abs(design_offset_y) + scaled_svg_height/2 <= plate_length/2`
5. Update all presets with `design_offset_x: 0, design_offset_y: 0`.
6. Bump version.

### Risks

- Large offsets push the SVG bounding box past the plate edge. The
  assertions prevent this, but the error message should be descriptive
  (e.g. "design_offset_x too large — SVG extends beyond plate edge").
