# Spec 12 — Bottom Contact Lip

## Problem

Even on a flat surface, a 3D-printed stencil has micro-gaps along the
bottom face due to layer lines, slight warping, and surface roughness.
Paint migrates through these gaps, causing bleed around the cutout
edges.

## Solution

Add a thin raised ridge on the bottom face running around the SVG
cutout perimeter. This lip acts like a gasket: it presses into the
surface under the stencil's own weight (or light finger pressure) and
blocks paint from creeping under.

### New parameters

| Section      | Name          | Default | Range         | Notes                                                 |
|--------------|---------------|---------|---------------|-------------------------------------------------------|
| `[Design:]`  | `show_lip`    | false   | [true:false]  | Enable the contact lip around the SVG cutout          |
| `[Design:]`  | `lip_height`  | 0.4     | [0.1:0.1:1.5] | Height the lip protrudes below the bottom face (mm)   |
| `[Design:]`  | `lip_width`   | 1.0     | [0.3:0.1:3]   | Wall thickness of the lip ridge (mm)                  |
| `[Design:]`  | `lip_offset`  | 0.5     | [0:0.1:3]     | Gap between the SVG cutout edge and the lip (mm)      |

### How it works

```
  cross-section (front view, bottom face down)

       plate body
  ┌─────────┬──────────┬─────────┐
  │         │ cutout   │         │  ← plate_depth
  └────┬──┬─┘          └─┬──┬───┘
       │  │              │  │       ← lip_height
       └──┘              └──┘
       lip               lip
       ↕                 ↕
    lip_width         lip_width
       ←─→              ←─→
    lip_offset from cutout edge
```

The lip forms a closed loop around the SVG cutout perimeter, offset
outward by `lip_offset`. When the stencil is placed on a surface, the
lip compresses slightly and creates a seal.

### Implementation

1. Add parameters in the `[Design:]` section.
2. Add assertions:
   - `lip_height > 0`
   - `lip_width > 0`
   - `lip_offset >= 0`
   - `lip_height < plate_depth` (lip should be much shorter than plate)
3. Create `contact_lip()` module:

```openscad
module contact_lip() {
    translate([0, 0, -(plate_depth / 2 + lip_height)])
        linear_extrude(height = lip_height, convexity = 100)
            difference() {
                // Outer boundary: SVG expanded by offset + width
                offset(delta = lip_offset + lip_width)
                    scale([design_scale, design_scale])
                        import(svg_file, center = true);
                // Inner boundary: SVG expanded by offset only
                offset(delta = lip_offset)
                    scale([design_scale, design_scale])
                        import(svg_file, center = true);
            }
}
```

4. In `build()`, add to the `union()` block:
   ```openscad
   if (show_lip) contact_lip();
   ```
5. Clip the lip to the plate bounds (intersection with plate footprint)
   so it doesn't extend beyond the plate edge.
6. Update `assemble()` cross-section clip volume to extend downward by
   `lip_height` so the lip is visible in cross-section mode.
7. The `model_scale` wrapping already covers this module — no extra
   scaling needed.
8. Update all presets with `show_lip: false` (opt-in feature).
9. Bump version.

### Print considerations

- `lip_height` of 0.4mm = roughly 2 layers at 0.2mm layer height, or
  1 layer at 0.4mm. One layer is enough for the gasket effect.
- The lip should be printed with the bottom face *up* (lip pointing
  upward during print) for best surface finish on the contact side.
  Alternatively, print bottom-down on a glass bed for a smooth lip.
  Document this in the parameter comments.
- PLA lips are rigid and work by mechanical contact. TPU/flexible
  filament would make better gaskets but that's a material choice, not
  a design parameter.

### Risks

- Complex SVGs with very fine features will produce a lip with matching
  fine geometry that may not print cleanly. The `lip_offset` parameter
  helps — larger offsets smooth out the lip path.
- The lip adds to the total model height, which changes the Z footprint.
  The `model_scale` wrapper handles this correctly.
- `offset()` on the SVG is called twice (inner + outer boundary),
  adding rendering time. Acceptable for the functional benefit.
