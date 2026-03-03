# ✏️ Customizable Comb Generator for OpenSCAD

A fully parametric 3D comb generator. Adjust the spine, teeth count, spacing, and personalization entirely through the OpenSCAD Customizer — no code editing required.

## ✨ Features

- **Parametric spine and teeth** — control dimensions, count, and spacing independently
- **Tapered teeth** — each tooth narrows slightly at the tip for a more natural profile
- **Debossed personalization** — stamp custom text or an SVG logo into the spine
- **Preview and render quality** — toggle between fast preview and high-quality final render
- **Cross-section view** — slice the model in half to inspect tooth and spine geometry
- **Full parameter validation** — assertions catch invalid configurations before rendering

## 💇 Hair Type Presets

Five presets are included, optimized for different hair types and textures:

| Preset | tooth_width | tooth_gap | tooth_length | num_teeth | Best For |
| :--- | ---: | ---: | ---: | ---: | :--- |
| **Fine / Thin** | 1.0 mm | 1.0 mm | 20 mm | 55 | Fine, delicate hair that needs gentle styling |
| **Normal / Straight** | 1.5 mm | 1.5 mm | 25 mm | 45 | Everyday use; balanced geometry |
| **Thick / Coarse** | 2.0 mm | 3.0 mm | 30 mm | 25 | Dense, coarse hair that needs wider spacing |
| **Curly / Wavy** | 3.0 mm | 6.0 mm | 40 mm | 12 | Curls and waves; wide-tooth detangling comb |
| **Long / Detangling** | 2.0 mm | 4.0 mm | 50 mm | 20 | Long hair; extra-long teeth for deep detangling |

### Loading a Preset

Presets are stored in `comb-generator.json` and loaded directly from OpenSCAD's Customizer:

1. Open `comb-generator.scad` in OpenSCAD
2. Open the **Customizer** panel if not already visible
3. Click the **dropdown menu** above the parameter list (shows "default" initially)
4. Select a preset name from the list (e.g., "Curly / Wavy")
5. All parameters update instantly — press **F6** to render

### Command-Line Usage

You can also render presets from the command line using OpenSCAD's `-P` flag:

```bash
openscad -p comb-generator.json -P "Curly / Wavy" -o curly_comb.stl comb-generator.scad
```

Available preset names:
- `Fine / Thin`
- `Normal / Straight`
- `Thick / Coarse`
- `Curly / Wavy`
- `Long / Detangling`

## 🚀 How to Use

1. Download and install [OpenSCAD](https://openscad.org/) if you don't have it.
2. Open `comb-generator.scad` in OpenSCAD.
3. Open the **Customizer** panel (`View` > `Hide Customizer`).
4. Adjust the parameters to match your requirements (see the table below).
5. Press **F6** to render, then **F7** to export as STL.

> **Tip:** Keep `preview_mode = true` while designing for faster feedback. Set it to `false` before your final render.

## 🎛️ Parameters

### Quality

| Parameter | Description | Default |
| :--- | :--- | :--- |
| `preview_mode` | Lower resolution for fast preview; disable for final render. | `true` |
| `show_cross_section` | Slice the model in half to inspect tooth and spine geometry. | `false` |

### Comb

| Parameter | Description | Default |
| :--- | :--- | :--- |
| `comb_thickness` | Thickness of the comb (Z height). | `3` |
| `spine_width` | Width of the solid spine the teeth are attached to. | `15` |

### Teeth

| Parameter | Description | Default |
| :--- | :--- | :--- |
| `tooth_length` | Length of each tooth from the spine edge to the tip. | `25` |
| `tooth_width` | Width of each individual tooth at its base. | `1.5` |
| `tooth_gap` | Gap between adjacent teeth. | `1.5` |
| `num_teeth` | Number of teeth. | `45` |

### Personalization

| Parameter | Description | Default |
| :--- | :--- | :--- |
| `custom_text` | Text to deboss into the spine (used when `use_svg` is `false`). | `"YOUR TEXT"` |
| `text_size` | Font size of the debossed text. | `6` |
| `stamp_depth` | Depth of the debossed stamp into the spine surface. | `1.0` |

### SVG Stamp

| Parameter | Description | Default |
| :--- | :--- | :--- |
| `use_svg` | Use an SVG file as the stamp instead of text. | `false` |
| `svg_filename` | Path to the SVG file used when `use_svg` is `true`. | `"logo.svg"` |
| `svg_scale` | Uniform scale factor applied to the imported SVG. | `1.0` |

## ⚠️ Geometry Constraint

The stamp depth must be less than the comb thickness:

```text
stamp_depth < comb_thickness
```

Violating this constraint will produce an invalid shape. OpenSCAD will report an assertion error.

## 🧑‍💻 Author

- **Developed by:** Jerry van Heerikhuize
- **Email:** [jvanheerikhuize@gmail.com](mailto:jvanheerikhuize@gmail.com)
- **Version:** 1.2.0
- **Last Modified:** 03/03/26

## ⚖️ License

Licensed under the [Apache License 2.0](../LICENSE).
