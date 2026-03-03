# 🖨️ OpenSCAD STL-to-Mold Generator

This OpenSCAD script generates a customizable two-part mold (with registration marks and a pouring hole) from an existing STL file.

You provide an STL file and this script builds a two-part, 3D-printable mold around it. You have full control over the object's placement (scale, rotation, translation) and the mold's dimensions.

## ✨ Features

- **STL to mold** — converts any standard STL file into a two-part block mold
- **Fully parametric** — all dimensions are controllable via the Customizer
- **Automatic registration marks** — generates spherical alignment keys so mold halves lock together precisely
- **Customizable pouring hole** — tapered hole with adjustable position and radii
- **Object preview** — toggle to visualize object placement before final render
- **Placement control** — full X/Y/Z rotation and translation for fine-tuning

## 🚀 How to Use

This script requires an existing STL file to work.

1. **Place your STL** — save your STL file (e.g. `my_object.stl`) in the **same folder** as this `.scad` file.
2. **Open in OpenSCAD** — open `mold_generator.scad` in OpenSCAD.
3. **Open the Customizer** — go to `View` > `Hide Customizer`.
4. **Set the object file** — change `object_file` to your STL filename (e.g. `"my_object.stl"`).
5. **Position your object** — set `object_preview = true`, then use the rotation and translation parameters to place your object inside the mold block. Adjust the mold dimensions to ensure a sufficient border around the object.
6. **Configure the mold** — adjust the pouring hole and registration mark settings as needed.
7. **Final render** — set `object_preview = false` once positioning is complete.
8. **Export each part separately:**
   - Comment out `mold_b();` in the `START` section, press **F6** to render, then **F7** to export Part A.
   - Comment out `mold_a();` and uncomment `mold_b();`, then repeat to export Part B.

## 🎛️ Parameters

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
| `mold_placement_gap` | Visual gap between the two mold halves in preview. | `10` |

### Pouring Hole

| Parameter | Description | Default |
| :--- | :--- | :--- |
| `pouring_hole_r1` | Radius of the pouring hole at the top. | `4` |
| `pouring_hole_r2` | Radius of the pouring hole at the bottom (creates a taper). | `3` |
| `pouring_hole_translate_x` | Moves the pouring hole along the X-axis. | `0` |
| `pouring_hole_translate_y` | Moves the pouring hole along the Y-axis. | `0` |
| `pouring_hole_translate_z` | Moves the pouring hole along the Z-axis. | `0` |

### Registration Marks

| Parameter | Description | Default |
| :--- | :--- | :--- |
| `registration_marks_size` | Diameter of the spherical alignment marks. | `7` |
| `registration_marks_margin` | Distance from the mold edge to the marks. | `3` |

## 🧑‍💻 Author

- **Developed by:** Jerry van Heerikhuize
- **Email:** [jvanheerikhuize@gmail.com](mailto:jvanheerikhuize@gmail.com)
- **Version:** 1.0.0

## ⚖️ License

Licensed under the [Apache License 2.0](../LICENSE).
