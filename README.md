# OpenSCAD Generators

A collection of fully parametric OpenSCAD generators for 3D-printable objects. Each generator is self-contained and configurable via the built-in OpenSCAD Customizer — no coding required.

## Generators

### 🔧 [Funnel Generator](Funnel%20Generator/)

Create a customizable funnel with a bowl, tapered stem, optional handles, drip guard, and support for flat-sided (polygonal) profiles.

### 🖨️ [Mold Generator](Mold%20Generator/)

Turn any STL file into a two-part block mold, complete with registration marks and a pouring hole.

### 🎨 [Stencil Generator](Stencil%20Generator/)

Convert any SVG file into a rigid, 3D-printable stencil plate.

## Requirements

- [OpenSCAD](https://openscad.org/) 2021.01 or later

## Usage

1. Open the `.scad` file for the generator you want in OpenSCAD.
2. Open the **Customizer** panel (`View` > `Hide Customizer`).
3. Adjust the parameters to your needs.
4. Press **F6** to render, then **F7** to export as STL.

Each generator folder contains its own README with a full parameter reference.

## License

Licensed under the [Apache License 2.0](LICENSE).
