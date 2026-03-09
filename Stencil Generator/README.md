# Customizable Stencil Generator for OpenSCAD

A fully parametric 3D stencil generator. Import any SVG file and the plate automatically sizes to fit — set your SVG dimensions, scale, and border margin and the plate width and length are computed for you. Adjust handles, registration marks, and all other settings through the OpenSCAD Customizer with no code editing required.

## Features

- **Auto-sizing plate** — plate dimensions are derived from the SVG size, scale, and border margin automatically
- **SVG import** — works with any standard vector file (`.svg`)
- **Margin enforcement** — `min_border` physically clips the SVG cutout to its natural canvas boundary, preventing it from weakening the plate edge
- **Handle tabs** — two independently toggleable grip tabs for easy positioning without touching the artwork
- **Registration marks** — crosshair cutouts at all four corners for accurate multi-pass alignment
- **Preview and render quality** — toggle between fast preview and high-quality final render
- **Cross-section view** — slice the model to inspect plate thickness and cutout depth
- **Full parameter validation** — assertions catch invalid configurations before rendering

## Important: Preparing Your SVG

This script cuts the filled areas of your SVG out of the stencil plate. Your SVG must be **stencil-ready** before use.

- **Bridges are required:** Any enclosed shape (e.g. the inside of the letter "O") will become a floating island and fall out when printed. Add thin bridges to connect islands back to the surrounding plate.
- **Use a vector editor** such as [Inkscape](https://inkscape.org/) (free) to add bridges and clean up your SVG before importing.

## Finding Your SVG Dimensions

OpenSCAD imports SVG files at 96 DPI, converting pixel values to millimetres. To find the correct `svg_width` and `svg_height` values for your file:

- **In Inkscape:** open *File > Document Properties*. The canvas size in mm is shown directly.
- **Quick formula:** if your SVG reports dimensions in pixels, divide by `3.7795` to get mm.
- **In OpenSCAD:** set `svg_scale = 1`, render, and measure the imported shape in the viewport.

## Presets

Five presets are included covering common scale and border combinations. All presets assume a 100 × 100 mm SVG — update `svg_width` and `svg_height` for your own artwork.

| Preset | Scale | Border | Plate size* | Depth | Handles | Best For |
| :--- | ---: | ---: | ---: | ---: | :---: | :--- |
| **1x / Standard** | 1× | 10 mm | 120 × 120 mm | 3 mm | Yes | General use at natural SVG size |
| **2x / Large** | 2× | 15 mm | 230 × 230 mm | 4 mm | Yes | Doubled size with generous border |
| **3x / Poster** | 3× | 20 mm | 340 × 340 mm | 4 mm | Yes | Large-format wall or floor stencil |
| **0.5x / Mini** | 0.5× | 5 mm | 60 × 60 mm | 2 mm | No | Small labels, patches, or details |
| **1x / Tight Border** | 1× | 3 mm | 106 × 106 mm | 2 mm | No | Compact card-size stencils |

*Plate size assumes a 100 × 100 mm SVG. Actual plate size scales with your SVG dimensions.

### Loading a Preset

Presets are stored in `stencil_generator.json` and loaded directly from OpenSCAD's Customizer:

1. Open `stencil_generator.scad` in OpenSCAD
2. Open the **Customizer** panel if not already visible
3. Click the **dropdown menu** above the parameter list (shows "default" initially)
4. Select a preset name from the list (e.g., "2x / Large")
5. All parameters update instantly — press **F6** to render

### Command-Line Usage

You can also render presets from the command line using OpenSCAD's `-P` flag:

```bash
openscad -p stencil_generator.json -P "2x / Large" -o stencil_large.stl stencil_generator.scad
```

Available preset names:
- `1x / Standard`
- `2x / Large`
- `3x / Poster`
- `0.5x / Mini`
- `1x / Tight Border`

## How to Use

1. Download and install [OpenSCAD](https://openscad.org/) if you don't have it.
2. Place your SVG file in the **same folder** as `stencil_generator.scad`.
3. Open `stencil_generator.scad` in OpenSCAD.
4. Open the **Customizer** panel (`View` > `Hide Customizer`).
5. Set `svg_file`, `svg_width`, and `svg_height` to match your artwork.
6. Adjust `svg_scale` and `min_border` to control the output size.
7. Press **F6** to render, then **F7** to export as STL.

> **Tip:** Keep `preview_mode = true` while designing for faster feedback. Set it to `false` before your final render.

## Parameters

### Quality

| Parameter | Description | Default |
| :--- | :--- | :--- |
| `preview_mode` | Lower resolution for fast preview; disable for final render. | `true` |
| `show_cross_section` | Slice the model to inspect plate thickness and cutout depth. | `false` |

### SVG

| Parameter | Description | Default |
| :--- | :--- | :--- |
| `svg_file` | Filename of the SVG to import. Must be in the same folder as the `.scad` file. | `"_skull.svg"` |
| `svg_width` | Natural width of the SVG as imported by OpenSCAD, in mm. See [Finding Your SVG Dimensions](#finding-your-svg-dimensions). | `100` |
| `svg_height` | Natural height of the SVG as imported by OpenSCAD, in mm. | `100` |
| `svg_scale` | Uniform scale factor applied to the imported SVG artwork. | `1` |
| `min_border` | Minimum distance between the SVG cutout and the plate edge, in mm. The plate automatically expands by `2 × min_border` to accommodate this margin. | `10` |

### Stencil Plate

The plate dimensions are derived automatically — no manual width or length setting is needed.

| Parameter | Description | Derived value |
| :--- | :--- | :--- |
| *(stencil_width)* | Computed plate width. | `svg_width × svg_scale + 2 × min_border` |
| *(stencil_length)* | Computed plate length. | `svg_height × svg_scale + 2 × min_border` |
| `stencil_depth` | Thickness of the stencil plate (Z-axis), in mm. | `3` |

### Handles

| Parameter | Description | Default |
| :--- | :--- | :--- |
| `show_handle_1` | Enable handle tab on the positive-Y side of the stencil. | `true` |
| `show_handle_2` | Enable handle tab on the negative-Y side (opposite handle 1). | `true` |
| `handle_width` | Width of the handle tab (X-axis), in mm. | `30` |
| `handle_length` | Length the handle protrudes beyond the plate edge, in mm. | `40` |
| `handle_overlap` | How far the handle extends into the plate to ensure a watertight union. | `1` |

### Registration Marks

| Parameter | Description | Default |
| :--- | :--- | :--- |
| `show_registration_marks` | Cut crosshair alignment marks into all four corners of the plate. | `true` |
| `reg_mark_size` | Total length of each crosshair arm, in mm. | `10` |
| `reg_mark_width` | Width of each crosshair arm, in mm. | `1` |
| `reg_mark_inset` | Distance from the plate corner to the crosshair centre, in mm. | `8` |

## Geometry Constraints

The registration mark crosshairs must fit within the plate:

```text
reg_mark_inset + reg_mark_size / 2 < stencil_width  / 2
reg_mark_inset + reg_mark_size / 2 < stencil_length / 2
```

Violating this constraint will produce an assertion error before rendering.

## Author

- **Developed by:** Jerry van Heerikhuize
- **Email:** [jvanheerikhuize@gmail.com](mailto:jvanheerikhuize@gmail.com)
- **Version:** 1.3.0
- **Last Modified:** 07/03/26

## License

Licensed under the [Apache License 2.0](../LICENSE).
