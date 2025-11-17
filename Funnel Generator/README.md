# 🔧 Customizable Funnel for OpenSCAD

This project is a fully parametric 3D model of a funnel created in OpenSCAD. It allows you to customize the bowl, stem, and handle dimensions to create a funnel that perfectly fits your specific needs.



## ✨ Features

* **Fully Parametric:** Adjust all key dimensions.
* **Customizable Bowl:** Control the height and radius of the funnel's main bowl.
* **Customizable Stem:** Control the height and radii of the stem for a straight or tapered flow.
* **Optional Handles:** Add one or two handles for easier gripping and stability.
* **Adjustable Thickness:** Set the wall thickness for the entire model.
* **Smooth Transition:** A clean, hulled curve provides a smooth transition between the bowl and the stem.

## 🚀 How to Use

1.  Download and install [OpenSCAD](https://openscad.org/) (if you don't already have it).
2.  Open the `.scad` file in OpenSCAD.
3.  Open the **Customizer** panel (go to `View` > `Hide Customizer` to toggle it).
4.  Adjust the parameters in the Customizer to match your requirements (see the table below).
5.  Once you are happy with the design, **Render** the model (press **F6**).
6.  **Export** the model as an STL file (press **F7**) to use with your 3D printer's slicer.

## 🎛️ Parameters (Configuration)

All parameters are defined in the "CONFIGURATION" section at the top of the `.scad` file and are accessible through the OpenSCAD Customizer.

### Bowl
| Parameter | Description | Default |
| :--- | :--- | :--- |
| `bowl_height` | The height of the funnel's bowl. | `70` |
| `bowl_radius` | The top radius of the funnel's bowl. | `50` |

### Stem
| Parameter | Description | Default |
| :--- | :--- | :--- |
| `stem_height` | The height of the stem. | `50` |
| `stem_radius_1` | The radius of the stem at the top (where it joins the bowl). | `7` |
| `stem_radius_2` | The radius of the stem at the bottom (the exit). | `7` |

### Handle 1
| Parameter | Description | Default |
| :--- | :--- | :--- |
| `handle_1` | Show or hide the first handle (`true` / `false`). | `true` |
| `handle_1_width` | Width of the first handle. | `20` |
| `handle_1_length` | Length of the first handle. | `80` |

### Handle 2
| Parameter | Description | Default |
| :--- | :--- | :--- |
| `handle_2` | Show or hide the second handle (`true` / `false`). | `true` |
| `handle_2_width` | Width of the second handle. | `20` |
| `handle_2_length` | Length of the second handle. | `80` |

### Extra Settings
| Parameter | Description | Default |
| :--- | :--- | :--- |
| `thickness` | The wall thickness of the entire funnel. | `2` |
| `transition_curve_radius` | The radius of the smooth curve connecting the stem and bowl. | `20` |

## 🧑‍💻 Author

* **Developed by:** Jerry van Heerikhuize
* **Email:** jvanheerikhuize@gmail.com
* **Version:** 1.0.1
* **Last Modification:** 24/01/25

## ⚖️ License

No license is specified in the file. As the author, you might want to consider adding an open-source license (like MIT or GPL) to let others know how they can use, modify, and share your work.
