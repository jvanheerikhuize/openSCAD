# 🔧 Customizable Funnel Generator for OpenSCAD

A fully parametric 3D funnel generator. Adjust the bowl, stem, handles, drip guard, and wall geometry entirely through the OpenSCAD Customizer — no code editing required.

## ✨ Features

- **Parametric bowl and stem** — independent radii, heights, and a smooth fillet transition
- **Flat-sided bowl** — optionally generate a polygonal funnel (square, hexagonal, etc.)
- **Optional handles** — two independently sized handles on opposite sides of the rim
- **Drip guard** — horizontal lip at the top rim to stop overflow running down the outside
- **Preview and render quality** — toggle between fast preview and high-quality final render
- **Cross-section view** — slice the model in half to inspect wall thickness and internal geometry
- **Full parameter validation** — assertions catch invalid configurations before rendering

## 🚀 How to Use

1. Download and install [OpenSCAD](https://openscad.org/) if you don't have it.
2. Open `funnel_generator.scad` in OpenSCAD.
3. Open the **Customizer** panel (`View` > `Hide Customizer`).
4. Adjust the parameters to match your requirements (see the table below).
5. Press **F6** to render, then **F7** to export as STL.

> **Tip:** Keep `preview_mode = true` while designing for faster feedback. Set it to `false` before your final render.

## 🎛️ Parameters

### Quality

| Parameter | Description | Default |
| :--- | :--- | :--- |
| `preview_mode` | Lower resolution for fast preview; disable for final render. | `true` |
| `show_cross_section` | Slice the model in half to inspect internal geometry. | `false` |

### Bowl

| Parameter | Description | Default |
| :--- | :--- | :--- |
| `bowl_inner_radius` | Inner radius of the bowl at its widest (top) opening. | `50` |
| `bowl_height` | Height of the bowl section. | `70` |
| `bowl_sides` | Number of flat sides (`0` = circular, `3`+ = polygonal). | `0` |

### Stem

| Parameter | Description | Default |
| :--- | :--- | :--- |
| `stem_radius_bottom` | Inner radius of the stem at the bottom opening. | `7` |
| `stem_radius_top` | Inner radius of the stem at the top, where it meets the bowl. | `7` |
| `stem_height` | Height of the stem section. | `50` |

### Handle 1

| Parameter | Description | Default |
| :--- | :--- | :--- |
| `show_handle_1` | Enable handle 1 (positive-Y side of the funnel). | `true` |
| `handle_1_width` | Width of handle 1. | `20` |
| `handle_1_length` | Length of handle 1. | `80` |

### Handle 2

| Parameter | Description | Default |
| :--- | :--- | :--- |
| `show_handle_2` | Enable handle 2 (negative-Y side, opposite handle 1). | `true` |
| `handle_2_width` | Width of handle 2. | `20` |
| `handle_2_length` | Length of handle 2. | `80` |

### Drip Guard

| Parameter | Description | Default |
| :--- | :--- | :--- |
| `show_drip_guard` | Enable the horizontal lip at the top rim. | `true` |
| `drip_guard_width` | How far the guard protrudes beyond the outer funnel wall. | `5` |
| `drip_guard_height` | Vertical height of the drip guard ring. | `2` |

### Extra

| Parameter | Description | Default |
| :--- | :--- | :--- |
| `wall_thickness` | Wall thickness. Exact on vertical surfaces; angled bowl walls will be slightly thinner. | `2` |
| `transition_curve_radius` | Radius of the rounded fillet connecting the stem to the bowl. | `20` |
| `handle_overlap` | How far handles extend into the funnel wall to ensure a watertight union. | `1` |

## ⚠️ Geometry Constraint

The transition fillet must fit within the bowl:

```text
stem_radius_top + transition_curve_radius ≤ bowl_inner_radius
```

Violating this constraint will produce an invalid shape. OpenSCAD will report an assertion error.

## 🧑‍💻 Author

- **Developed by:** Jerry van Heerikhuize
- **Email:** [jvanheerikhuize@gmail.com](mailto:jvanheerikhuize@gmail.com)
- **Version:** 1.2.0
- **Last Modified:** 03/03/26

## ⚖️ License

Licensed under the [Apache License 2.0](../LICENSE).
