# 🎨 Customizable 3D Stencil Generator for OpenSCAD

This OpenSCAD script allows you to turn any 2D SVG file into a rigid, 3D-printable stencil. It works by defining a base plate and "punching out" the shape of your SVG vector file.

## ✨ Features

* **SVG Import:** Works with standard vector files (`.svg`).
* **Fully Parametric:** Adjust the size of the stencil plate and the scale of the artwork.
* **Auto-Centering:** The script automatically centers your SVG design within the stencil plate.
* **Adjustable Thickness:** Control how thick the stencil plate is for rigidity or flexibility.

## ⚠️ Important: Preparing Your SVG

**Please read this for a realistic result:**
This script cuts the black parts of your SVG out of the plastic. You must ensure your SVG is "Stencil Ready."
* **Bridges are required:** If you use a standard letter "O", the center circle is an "island" and will fall out