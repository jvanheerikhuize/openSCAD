# 🖨️ OpenSCAD STL-to-Mold Generator

This OpenSCAD script generates a customizable, two-part mold (with registration marks and a pouring hole) from an existing STL file.

You provide an STL file, and this script builds a two-part, 3D-printable mold around it. You have full control over the object's placement (scale, rotation, translation) and the mold's dimensions.



## ✨ Features

* **STL to Mold:** Converts any standard STL file into a two-part block mold.
* **Fully Parametric:** All dimensions are controllable via the Customizer.
* **Automatic Registration Marks:** Generates positive and negative spherical alignment keys to ensure the mold halves lock together perfectly.
* **Customizable Pouring Hole:** Add a tapered pouring hole and position it as needed.
* **Object Preview:** A built-in preview toggle helps you position your object inside the mold block before rendering.
* **Placement Control:** Full X/Y/Z rotation and translation controls for fine-tuning object placement.

## 🚀 How to Use

This script requires an existing STL file to work.

1.  **Place Your STL:** Save your object's STL file (e.g., `my_object.stl`) in the **same directory** as this `.scad` file.
2.  **Open in OpenSCAD:** Open this `.scad` file in OpenSCAD.
3.  **Open the Customizer:** Go to `View` > `Hide Customizer` to toggle the Customizer panel.
4.  **Set Object File:** In the `Object` parameters, change the `object_file` value to your STL's exact filename (e.g., `"my_object.stl"`).
5.  **Position Your Object:**
    * Set `object_preview = true`. This will show your object (often in lime green or blue) and the mold blocks.
    * Use the `object_rotation` and `object_translation` parameters to position your object inside the mold.
    * Adjust `mold_width`, `mold_length`, and `mold_depth` to ensure the object fits with enough of a border.
6.  **Configure Mold:** Adjust the pouring hole and registration mark settings to your liking.
7.  **Final Render:** Once you are happy with the placement, set `object_preview = false`.
8.  **Export Each Part:**
    * **To export Part A:** In the `START` section of the code (around line 125), add `//` to comment out `mold_b();` (so it looks like `// mold_b();`).
    * Press **F6** to Render the model.
    * Press **F7** to export the rendered Part A as an STL.
    * **To export Part B:** Comment out `mold_a();` and *un-comment* `mold_b();`.
    * Press **F6** to Render, then **F7** to export Part B.

## 🎛️ Configuration Parameters

All parameters are available in the OpenSCAD Customizer.

### Object
| Parameter | Description | Default |
| :--- | :--- | :--- |
| `object_file` | The filename of the STL you want to make a mold of. **Must be in the same folder.** | `"_skull.stl"` |
| `object_scale` | The scale factor for the imported object. `1` = 100%. | `1` |
| `object_preview` | `true` shows a preview of your object for positioning. Set to `false` for final render. | `true` |

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
| `mold_width` | The total width (X-axis) of one mold half. | `75` |
| `mold_length` | The total length (Y-axis) of one mold half. | `70` |
| `mold_depth` | The total depth/height (Z-axis) of one mold half. | `23` |
| `mold_placement_gap` | The visual gap between the two mold halves in the preview. | `10` |

### Pouring Hole
| Parameter | Description | Default |
| :--- | :--- | :--- |
| `pouring_hole_r1` | The radius of the pouring hole at the top. | `4` |
| `pouring_hole_r2` | The radius of the pouring hole at the bottom (creates a taper). | `3` |
| `pouring_hole_translate_x` | Moves the pouring hole along the X-axis. | `0` |
| `pouring_hole_translate_y` | Moves the pouring hole along the Y-axis. | `0` |
| `pouring_hole_translate_z` | Moves the pouring hole along the Z-axis. | `0` |

### Registration Marks
| Parameter | Description | Default |
| :--- | :--- | :--- |
| `registration_marks_size` | The diameter of the spherical alignment marks. | `7` |
| `registration_marks_margin` | The padding/distance from the mold edge to the marks. | `3` |

## 🧑‍💻 Author

* **Developed by:** Jerry van Heerikhuize
* **Email:** jvanheerikhuize@gmail.com
* **Version:** 1.0.0

## ⚖️ License

No license is specified. Please contact the author for permissions or add an open-source license (like MIT or GPL) if you intend to share it.
