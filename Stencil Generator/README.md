# Customizable Stencil Generator for OpenSCAD

A fully parametric 3D stencil generator. Import any SVG file and the plate automatically sizes to fit — set your SVG dimensions, design scale, and border margin and the plate width and length are computed for you. Adjust handles, registration marks, beveled edges, and all other settings through the OpenSCAD Customizer with no code editing required.

## Features

- **Auto-sizing plate** — plate dimensions are derived from the SVG size, design scale, and border margin automatically
- **SVG import** — works with any standard vector file (`.svg`)
- **Dual scaling** — `design_scale` controls the SVG cutout size; `model_scale` uniformly resizes the entire assembled stencil
- **Beveled cut edges** — optional stepped bevel widens the top (spray-side) opening, creating a knife-edge at the surface contact side to reduce paint bleed
- **Rounded plate corners** — configurable corner radius for a professional finish
- **Handle tabs** — two independently toggleable grip tabs with optional circular finger holes
- **Registration marks** — crosshair cutouts at all four corners for accurate multi-pass alignment
- **Margin enforcement** — `plate_border` physically clips the SVG cutout to its natural canvas boundary, preventing it from weakening the plate edge
- **Preview and render quality** — toggle between fast preview and high-quality final render
- **Cross-section view** — slice the model to inspect plate thickness and cutout depth
- **Full parameter validation** — assertions catch invalid configurations before rendering

## Important: Preparing Your SVG

This script cuts the filled areas of your SVG out of the stencil plate. Your SVG must be **stencil-ready** before use.

- **Bridges are required:** Any enclosed shape (e.g. the inside of the letter "O") will become a floating island and fall out when printed. Add thin bridges to connect islands back to the surrounding plate.
- **Use a vector editor** such as [Inkscape](https://inkscape.org/) (free) to add bridges and clean up your SVG before importing.

## Finding Your SVG Dimensions

OpenSCAD imports SVG files at 96 DPI, converting pixel values to millimetres. To find the correct `svg_native_width` and `svg_native_height` values for your file:

- **In Inkscape:** open *File > Document Properties*. The canvas size in mm is shown directly.
- **Quick formula:** if your SVG reports dimensions in pixels, divide by `3.7795` to get mm.
- **In OpenSCAD:** set `design_scale = 1`, render, and measure the imported shape in the viewport.

## Presets

Five presets are included covering common scale and border combinations. All presets assume a 100 x 100 mm SVG — update `svg_native_width` and `svg_native_height` for your own artwork.

| Preset | Design Scale | Border | Plate size* | Depth | Corners | Handles | Grip Holes | Best For |
| :--- | ---: | ---: | ---: | ---: | ---: | :---: | :---: | :--- |
| **Standard** | 1x | 10 mm | 120 x 120 mm | 3 mm | 2 mm | Yes | No | General use at natural SVG size |
| **Large (2x)** | 2x | 15 mm | 230 x 230 mm | 4 mm | 2 mm | Yes | Yes | Doubled size with generous border |
| **Poster (3x)** | 3x | 20 mm | 340 x 340 mm | 4 mm | 2 mm | Yes | Yes | Large-format wall or floor stencil |
| **Mini (0.5x)** | 0.5x | 5 mm | 60 x 60 mm | 2 mm | 2 mm | No | No | Small labels, patches, or details |
| **Tight Border** | 1x | 3 mm | 106 x 106 mm | 2 mm | 0 | No | No | Compact card-size stencils |

*Plate size assumes a 100 x 100 mm SVG. Actual plate size scales with your SVG dimensions.

### Loading a Preset

Presets are stored in `stencil_generator.json` and loaded directly from OpenSCAD's Customizer:

1. Open `stencil_generator.scad` in OpenSCAD
2. Open the **Customizer** panel if not already visible
3. Click the **dropdown menu** above the parameter list (shows "default" initially)
4. Select a preset name from the list (e.g., "Large (2x)")
5. All parameters update instantly — press **F6** to render

### Command-Line Usage

You can also render presets from the command line using OpenSCAD's `-P` flag:

```bash
openscad -p stencil_generator.json -P "Large (2x)" -o stencil_large.stl stencil_generator.scad
```

Available preset names:
- `Standard`
- `Large (2x)`
- `Poster (3x)`
- `Mini (0.5x)`
- `Tight Border`

## How to Use

1. Download and install [OpenSCAD](https://openscad.org/) if you don't have it.
2. Place your SVG file in the **same folder** as `stencil_generator.scad`.
3. Open `stencil_generator.scad` in OpenSCAD.
4. Open the **Customizer** panel (`View` > `Hide Customizer`).
5. Set `svg_file`, `svg_native_width`, and `svg_native_height` to match your artwork.
6. Adjust `design_scale` and `plate_border` to control the output size.
7. Press **F6** to render, then **F7** to export as STL.

> **Tip:** Keep `preview_mode = true` while designing for faster feedback. Set it to `false` before your final render.

## Parameters

### Quality

| Parameter | Description | Default |
| :--- | :--- | :--- |
| `preview_mode` | Lower resolution for fast preview; disable for final render. | `true` |
| `show_cross_section` | Slice the model to inspect plate thickness and cutout depth. | `false` |

### SVG File

| Parameter | Description | Default |
| :--- | :--- | :--- |
| `svg_file` | Filename of the SVG to import. Must be in the same folder as the `.scad` file. | `"bee_stencil.svg"` |
| `svg_native_width` | Native width of the SVG as imported by OpenSCAD, in mm. See [Finding Your SVG Dimensions](#finding-your-svg-dimensions). | `100` |
| `svg_native_height` | Native height of the SVG as imported by OpenSCAD, in mm. | `100` |

### Design

| Parameter | Description | Default |
| :--- | :--- | :--- |
| `design_scale` | Scale factor for the SVG cutout only — the plate auto-sizes around the scaled artwork. | `1` |
| `bevel_width` | How much wider the top (spray-side) opening is than the bottom per side, in mm. Creates a knife-edge at the surface contact side. `0` = vertical walls. | `0` |
| `bevel_depth` | Height of the beveled portion measured down from the top face, in mm. | `1` |

### Plate

The plate dimensions are derived automatically — no manual width or length setting is needed.

| Parameter | Description | Default |
| :--- | :--- | :--- |
| *(plate_width)* | Computed plate width. | `svg_native_width x design_scale + 2 x plate_border` |
| *(plate_length)* | Computed plate length. | `svg_native_height x design_scale + 2 x plate_border` |
| `plate_border` | Distance between the SVG cutout and the plate edge, in mm. | `10` |
| `plate_depth` | Thickness of the stencil plate (Z-axis), in mm. | `3` |
| `plate_corner_radius` | Radius of the rounded corners on the plate. `0` = sharp corners. | `2` |

### Model Scale

| Parameter | Description | Default |
| :--- | :--- | :--- |
| `model_scale` | Uniform scale applied to the entire assembled model (plate, cutout, handles, marks). Use this to resize the whole stencil proportionally. | `1` |

### Handles

| Parameter | Description | Default |
| :--- | :--- | :--- |
| `show_handle_1` | Enable handle tab on the positive-Y side of the stencil. | `true` |
| `show_handle_2` | Enable handle tab on the negative-Y side (opposite handle 1). | `true` |
| `handle_width` | Width of the handle tab (X-axis), in mm. | `30` |
| `handle_length` | Length the handle protrudes beyond the plate edge, in mm. | `40` |
| `handle_overlap` | How far the handle extends into the plate to ensure a watertight union. | `1` |
| `show_handle_grip` | Cut a circular finger hole through each enabled handle. | `false` |
| `handle_grip_diameter` | Diameter of the circular grip hole, in mm. | `15` |

### Registration Marks

| Parameter | Description | Default |
| :--- | :--- | :--- |
| `show_registration_marks` | Cut crosshair alignment marks into all four corners of the plate. | `true` |
| `reg_mark_size` | Total length of each crosshair arm, in mm. | `10` |
| `reg_mark_width` | Width of each crosshair arm, in mm. | `1` |
| `reg_mark_inset` | Distance from the plate corner to the crosshair centre, in mm. | `8` |

## Geometry Constraints

The following constraints are enforced by assertions:

```text
bevel_depth < plate_depth
plate_corner_radius <= min(plate_width, plate_length) / 2
reg_mark_inset > plate_corner_radius
reg_mark_inset + reg_mark_size / 2 < plate_width  / 2
reg_mark_inset + reg_mark_size / 2 < plate_length / 2
handle_grip_diameter < handle_width
handle_grip_diameter < handle_length
```

Violating any constraint will produce an assertion error before rendering.

## Author

- **Developed by:** Jerry van Heerikhuize
- **Email:** [jvanheerikhuize@gmail.com](mailto:jvanheerikhuize@gmail.com)
- **Version:** 1.7.0
- **Last Modified:** 07/04/26

## License

Licensed under the [Apache License 2.0](../LICENSE).
