# 🎨 Customizable 3D Stencil Generator for OpenSCAD

This OpenSCAD script allows you to turn any 2D SVG file into a rigid, 3D-printable stencil. It works by defining a base plate and "punching out" the shape of your SVG vector file.

## ✨ Features

- **SVG import** — works with standard vector files (`.svg`)
- **Fully parametric** — adjust the size of the stencil plate and the scale of the artwork
- **Auto-centering** — the SVG design is automatically centered on the stencil plate
- **Adjustable thickness** — control how thick the stencil plate is for rigidity or flexibility

## ⚠️ Important: Preparing Your SVG

This script cuts the black parts of your SVG out of the stencil plate. Your SVG must be **stencil-ready** before use.

- **Bridges are required:** Any enclosed shape (e.g. the inside of the letter "O") will become a floating island and fall out when printed. You must add thin bridges to connect islands back to the surrounding plate.
- **Use a vector editor** such as [Inkscape](https://inkscape.org/) (free) to add bridges and clean up your SVG before importing.

## 🚀 How to Use

1. Download and install [OpenSCAD](https://openscad.org/) if you don't have it.
2. Place your SVG file in the **same folder** as `stencil.scad`.
3. Open `stencil.scad` in OpenSCAD.
4. Open the **Customizer** panel (`View` > `Hide Customizer`).
5. Set `svg_file` to your SVG filename.
6. Adjust the plate dimensions and SVG scale to your needs.
7. Press **F6** to render, then **F7** to export as STL.

## 🎛️ Parameters

### Object

| Parameter | Description | Default |
| :--- | :--- | :--- |
| `svg_file` | Filename of the SVG to import. Must be in the same folder as the `.scad` file. | `"_skull.svg"` |
| `svg_scale` | Scale factor applied to the imported SVG artwork. | `1` |
| `svg_extrusion` | Depth of the cutout through the stencil plate. | `2` |

### Stencil Plate

| Parameter | Description | Default |
| :--- | :--- | :--- |
| `stencil_width` | Width of the stencil plate (X-axis), in mm. | `500` |
| `stencil_length` | Length of the stencil plate (Y-axis), in mm. | `500` |
| `stencil_depth` | Thickness of the stencil plate (Z-axis), in mm. | `5` |

## 🧑‍💻 Author

- **Developed by:** Jerry van Heerikhuize
- **Email:** [jvanheerikhuize@gmail.com](mailto:jvanheerikhuize@gmail.com)
- **Version:** 1.0.0
- **Last Modified:** 25/01/25

## ⚖️ License

Licensed under the [Apache License 2.0](../LICENSE).
