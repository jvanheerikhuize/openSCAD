# Spec 04 — Personalization / Labeling

## Problem

There is no way to add an artist name, stencil ID, or layer number to
the stencil. Multi-stencil projects need visible labels to keep layers
in order. The comb generator already has this feature pattern (debossed
text or SVG on the spine).

## Solution

Deboss text into the plate border area, positioned along one edge.
Follow the comb generator's personalization pattern.

### New parameters

| Section               | Name              | Default       | Range          | Notes                                  |
|-----------------------|-------------------|---------------|----------------|----------------------------------------|
| `[Personalization:]`  | `custom_text`     | ""            | —              | Empty = no stamp                       |
| `[Personalization:]`  | `text_size`       | 6             | [2:0.5:20]     | Font size in mm                        |
| `[Personalization:]`  | `stamp_depth`     | 1.0           | [0.2:0.1:2.5]  | How deep the deboss cuts into the plate|
| `[Personalization:]`  | `text_position`   | "bottom"      | [top, bottom, left, right] | Which border edge to place text on |

### Implementation

1. Add the parameters in a new `[Personalization:]` Customizer section,
   after `[Registration Marks:]`.
2. Add assertions:
   - `text_size > 0`
   - `stamp_depth > 0`
   - `stamp_depth < plate_depth` (don't cut all the way through)
3. Create `personalization_stamp()` module:
   - Uses `linear_extrude(height = stamp_depth + 0.01)` of `text()`.
   - Font: `"Arial:style=Bold"`, `halign = "center"`, `valign = "center"`.
   - Positioned in the border area based on `text_position`:
     - `"bottom"`: centred on X, at `-(plate_length/2 - plate_border/2)` on Y
     - `"top"`: centred on X, at `+(plate_length/2 - plate_border/2)` on Y
     - `"left"` / `"right"`: rotated 90°, centred on the relevant edge
4. In `build()`, add to the `difference()` block:
   ```openscad
   if (len(custom_text) > 0) personalization_stamp();
   ```
5. Update presets with `custom_text: ""` (no stamp by default).
6. Bump version.

### Risks

- Large text with a small border will overflow into the SVG cutout area.
  Hard to assert against generically since text width depends on the font
  renderer. Document this in the parameter comment: "Ensure text fits
  within the border area."
- Font availability varies by OS. Arial is broadly available but not
  universal. Document the fallback.
