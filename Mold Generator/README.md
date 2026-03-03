# 🖨️ OpenSCAD STL-to-Mold Generator

This OpenSCAD script generates a customizable two-part mold (with registration marks and a pouring hole) from an existing STL file.

You provide an STL file and this script builds a two-part, 3D-printable mold around it. You have full control over the object's placement (scale, rotation, translation) and the mold's dimensions.

## ✨ Features

- **STL to mold** — converts any standard STL file into a two-part block mold
- **Fully parametric** — all dimensions are controllable via the Customizer
- **Automatic registration marks** — spherical peg and socket alignment keys ensure the halves lock together precisely
- **Customizable pouring channel** — tapered channel with adjustable position and radii
- **Object preview** — transparent overlay toggle for positioning before final render
- **Placement control** — full X/Y/Z rotation and translation for fine-tuning
- **Preview and render quality** — toggle between fast preview and high-quality final render
- **Cross-section view** — slice both halves to inspect cavity geometry

## 📦 Example Part

An example STL file is included in this folder: **`example_part.stl`**

This is a simple mechanical bracket with multiple features:
- **Base platform** — 20×20×5 mm rectangular block
- **Vertical post** — 8×8 mm, 20 mm tall
- **Mounting plate** — 12×12 mm, 3 mm thick on top

### Quick Start with Example

1. Open `mold_generator.scad` in OpenSCAD
2. Open the **Customizer** panel
3. Set `object_file = "example_part.stl"`
4. Set `object_preview = true` to see the part
5. Adjust mold dimensions if needed (default 75×70×23 mm works well)
6. Set `object_preview = false` and press **F6** to render
7. Comment/uncomment `mold_a();` and `mold_b();` in the `build()` function to export each half separately

This example demonstrates how the mold generator handles objects with varying geometry and multiple levels.

## 🚀 How to Use

This script requires an existing STL file to work.

1. **Place your STL** — save your STL file (e.g. `my_object.stl`) in the **same folder** as this `.scad` file.
2. **Open in OpenSCAD** — open `mold_generator.scad` in OpenSCAD.
3. **Open the Customizer** — go to `View` > `Hide Customizer`.
4. **Set the object file** — change `object_file` to your STL filename (e.g. `"my_object.stl"`).
5. **Position your object** — set `object_preview = true`, then use the rotation and translation parameters to place your object inside the mold block. Adjust the mold dimensions to ensure a sufficient border around the object.
6. **Configure the mold** — adjust the pouring channel and registration mark settings as needed.
7. **Final render** — set `object_preview = false` once positioning is complete.
8. **Export each part separately** — in the `build()` module (near the top of the file), comment out one line at a time:
   - Comment out `mold_b();`, press **F6** to render, then **F7** to export Part A.
   - Restore `mold_b();`, comment out `mold_a();`, then repeat to export Part B.

## 🎛️ Parameters

### Quality

| Parameter | Description | Default |
| :--- | :--- | :--- |
| `preview_mode` | Lower resolution for fast preview; disable for final render. | `true` |
| `show_cross_section` | Slice both halves to expose the cavity geometry. | `false` |

### Object

| Parameter | Description | Default |
| :--- | :--- | :--- |
| `object_file` | Filename of the STL to make a mold of. Must be in the same folder. | `"_skull.stl"` |
| `object_scale` | Scale factor for the imported object (`1` = 100%). | `1` |
| `object_preview` | Show the object for positioning. Set to `false` for final render. | `true` |

### Object Rotation

| Parameter | Description | Default |
| :--- | :--- | :--- |
| `object_rotation_x` | Rotation of the object on the X-axis. | `0` |
| `object_rotation_y` | Rotation of the object on the Y-axis. | `-90` |
| `object_rotation_z` | Rotation of the object on the Z-axis. | `0` |

### Object Translation

| Parameter | Description | Default |
| :--- | :--- | :--- |
| `object_translate_x` | Moves the object along the X-axis (left/right). | `25` |
| `object_translate_y` | Moves the object along the Y-axis (front/back). | `0` |
| `object_translate_z` | Moves the object along the Z-axis (up/down). | `0` |

### Mold

| Parameter | Description | Default |
| :--- | :--- | :--- |
| `mold_width` | Total width (X-axis) of one mold half. | `75` |
| `mold_length` | Total length (Y-axis) of one mold half. | `70` |
| `mold_depth` | Total depth/height (Z-axis) of one mold half. | `23` |
| `mold_gap` | Visual gap between the two mold halves in preview. | `10` |

### Pouring Hole

| Parameter | Description | Default |
| :--- | :--- | :--- |
| `pouring_hole_r1` | Radius of the pouring channel at the entry point. | `4` |
| `pouring_hole_r2` | Radius of the channel at the cavity end (creates a taper). | `3` |
| `pouring_hole_translate_x` | Fine-tunes channel position along the channel axis. | `0` |
| `pouring_hole_translate_y` | Fine-tunes channel position transversely. | `0` |
| `pouring_hole_translate_z` | Fine-tunes channel position vertically. | `0` |

### Registration Marks

| Parameter | Description | Default |
| :--- | :--- | :--- |
| `registration_mark_size` | Diameter of the spherical alignment pegs and sockets. | `7` |
| `registration_mark_margin` | Distance from the mold edge to the mark centre. | `3` |
| `registration_mark_clearance` | Size reduction on the socket sphere for fit clearance. | `0.2` |

## 🧑‍💻 Author

- **Developed by:** Jerry van Heerikhuize
- **Email:** [jvanheerikhuize@gmail.com](mailto:jvanheerikhuize@gmail.com)
- **Version:** 2.0.0
- **Last Modified:** 03/03/26

## ⚖️ License

Licensed under the [Apache License 2.0](../LICENSE).
