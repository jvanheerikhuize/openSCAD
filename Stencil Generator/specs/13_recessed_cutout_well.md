# Spec 13 — Recessed Cutout Well (Plate Thinning)

## Problem

A thick stencil plate provides rigidity but creates tall walls around
the SVG cutout. Paint builds up against these walls and seeps under
the stencil edges. Thin plates eliminate this but sacrifice structural
integrity — the stencil warps and flexes.

## Solution

Keep the border area at full thickness for rigidity, but thin the
plate around the SVG cutout area on the top (spray) side. This creates
a shallow recessed well: paint enters a low-walled area and has less
surface to build up against, while the outer frame stays stiff.

### New parameters

| Section      | Name            | Default | Range        | Notes                                           |
|--------------|-----------------|---------|--------------|-------------------------------------------------|
| `[Plate:]`   | `show_well`     | false   | [true:false] | Enable the recessed well around the cutout      |
| `[Plate:]`   | `well_depth`    | 1.0     | [0.2:0.1:5]  | How deep the recess is from the top face (mm)   |
| `[Plate:]`   | `well_margin`   | 2.0     | [0:0.5:20]   | Extra space around the SVG cutout included in the well (mm) |

### How it works

```
  cross-section (front view)

  spray side (top)
  ┌──────┐                    ┌──────┐
  │border│   well_depth       │border│  ← full plate_depth
  │      ├────────────────────┤      │
  │      │   thinned area     │      │  ← plate_depth - well_depth
  │      │   ┌── cutout ──┐   │      │
  └──────┴───┘            └───┴──────┘
  surface side (bottom)

  ←─────→                     ←─────→
  border stays full thickness

         ←──→             ←──→
         well_margin around cutout
```

The well footprint = scaled SVG bounding box expanded by `well_margin`
on each side. The border beyond that stays at full `plate_depth`.

### Implementation

1. Add parameters in the `[Plate:]` section.
2. Add assertions:
   - `well_depth > 0`
   - `well_depth < plate_depth` (must leave material at the bottom)
   - `well_margin >= 0`
   - `scaled_svg_width + 2 * well_margin < plate_width`
     (well must not consume the entire plate — leave some border)
   - `scaled_svg_height + 2 * well_margin < plate_length`
3. Create `cutout_well()` module — a box subtracted from the top face:

```openscad
module cutout_well() {
    well_width  = scaled_svg_width  + 2 * well_margin;
    well_length = scaled_svg_height + 2 * well_margin;
    // Position: centred on XY, flush with the top face, cutting downward
    translate([0, 0, plate_depth / 2 - well_depth])
        cube([well_width, well_length, well_depth + cut_clearance / 2], center = false);
    // Corrected: center the well in XY
    translate([-well_width / 2, -well_length / 2, plate_depth / 2 - well_depth])
        cube([well_width, well_length, well_depth + cut_clearance / 2]);
}
```

4. In `build()`, add `cutout_well()` to the `difference()` block:
   ```openscad
   if (show_well) cutout_well();
   ```
   Place it *before* `svg_cutout()` in the difference — order doesn't
   matter for the boolean result but reads better (well first, then cut
   through the thinned area).
5. If spec 05 (SVG offset) is implemented, the well should follow the
   offset: centre the well at `[design_offset_x, design_offset_y]`.
6. Update all presets with `show_well: false` (opt-in feature).
7. Bump version.

### Interaction with other features

- **Beveled edges (spec 11):** the bevel operates on the cutout walls,
  which are now shorter (`plate_depth - well_depth`). Assertion needed:
  `bevel_depth <= plate_depth - well_depth` when both are enabled.
- **Contact lip (spec 12):** the lip is on the bottom face, unaffected
  by the top-side well. No interaction.
- **Registration marks:** if marks are inside the well area they will be
  cut into the thinned material. This is fine — they're already
  full-depth cuts.
- **Rounded plate corners (spec 01):** the well is rectangular even if
  the plate has rounded corners. Consider adding matching rounded
  corners to the well, or accept the visual mismatch since the well is
  recessed and not prominent.

### Risks

- Very large `well_depth` relative to `plate_depth` leaves a very thin
  floor in the cutout area (e.g. 3mm plate - 2mm well = 1mm floor).
  This is the intended use — thin where it matters — but document that
  the remaining floor thickness is `plate_depth - well_depth`.
- The well creates a step edge where the recess meets the full-thickness
  border. Paint may pool at this step. In practice this is well outside
  the cutout area and not a problem.
