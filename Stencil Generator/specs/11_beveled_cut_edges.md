# Spec 11 — Beveled Cut Edges

## Problem

The SVG cutout has vertical 90° walls. When the stencil sits on a
surface, paint creeps under the full wall height, causing bleed and
fuzzy edges. Professional stencils use angled cuts so the bottom
(surface-contact) side is the exact design size and the top (spray
side) is slightly wider, creating a knife-edge seal against the surface.

## Solution

Add a stepped bevel to the SVG cutout: the bottom portion retains the
exact SVG profile; the top portion uses `offset()` to widen the cut.
A stepped approach (two extrusions) is chosen over `hull()` (destroys
concave SVG features) or `minkowski()` (too slow for complex SVGs).

### New parameters

| Section      | Name           | Default | Range        | Notes                                         |
|--------------|----------------|---------|--------------|-----------------------------------------------|
| `[Design:]`  | `bevel_width`  | 0       | [0:0.1:5]    | How much wider the top opening is than the bottom (mm per side). 0 = vertical walls (current behaviour) |
| `[Design:]`  | `bevel_depth`  | 1       | [0.2:0.1:10] | Height of the beveled portion measured down from the top face (mm) |

### How it works

```
        spray side (top)
  ┌──────────────────────────┐
  │    offset(bevel_width)   │  ← bevel_depth
  │  ┌──────────────────┐   │
  │  │   exact SVG       │   │  ← plate_depth - bevel_depth
  │  │   profile          │   │
  └──┴──────────────────┴───┘
        surface side (bottom)
```

The bottom opening matches the SVG exactly (sharp contact with surface).
The top opening is `bevel_width` mm wider on each side (paint enters
easily, no build-up against walls).

### Implementation

1. Add `bevel_width` and `bevel_depth` in the `[Design:]` section.
2. Add assertions:
   - `bevel_width >= 0`
   - `bevel_depth > 0`
   - `bevel_depth < plate_depth` (bevel cannot consume the full plate)
3. Modify `svg_cutout()`:

```openscad
module svg_cutout() {
    intersection() {
        cube([
            scaled_svg_width + 2 * bevel_width,
            scaled_svg_height + 2 * bevel_width,
            plate_depth + cut_clearance
        ], center = true);

        union() {
            // Full-depth cut at exact SVG size (knife-edge at bottom)
            linear_extrude(height = plate_depth + cut_clearance, center = true, convexity = 100)
                scale([design_scale, design_scale])
                    import(svg_file, center = true);

            // Top-side bevel: wider cut, partial depth
            if (bevel_width > 0) {
                translate([0, 0, (plate_depth / 2) - bevel_depth])
                    linear_extrude(height = bevel_depth + cut_clearance / 2, convexity = 100)
                        offset(delta = bevel_width)
                            scale([design_scale, design_scale])
                                import(svg_file, center = true);
            }
        }
    }
}
```

4. Update the intersection bounding box to account for the wider
   bevel profile (`+ 2 * bevel_width`).
5. Update all presets:
   - `bevel_width: 0` for all (opt-in feature, preserves current output)
   - `bevel_depth: 1`
6. Bump version.

### Design decisions

- **Stepped vs smooth bevel:** A smooth chamfer would require `hull()`
  (destroys concavities) or `minkowski()` (extremely slow on complex
  SVGs). The stepped approach is fast, printable, and achieves the same
  functional goal — knife-edge contact at the bottom.
- **`offset(delta=...)` vs `offset(r=...)`:** `delta` preserves sharp
  corners (constant expansion). `r` rounds corners, which would alter
  the design. Use `delta`.
- **Bevel on bottom vs top:** Bevel is on the *top* (spray side). The
  bottom must remain the exact SVG to produce crisp paint lines.

### Risks

- `offset()` on complex SVGs with very small features may produce
  self-intersecting geometry. OpenSCAD handles this gracefully (merges
  overlapping regions), but the visual result may differ from
  expectation for intricate designs with gaps smaller than
  `2 * bevel_width`.
- Rendering time increases slightly due to the second `import()` +
  `offset()` pass.
