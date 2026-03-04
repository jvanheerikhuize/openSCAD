# OpenSCAD Generators

A collection of fully parametric OpenSCAD generators for 3D-printable objects. Each generator is self-contained and configurable via the built-in OpenSCAD Customizer — no coding required.

## Generators

### 🔧 [Funnel Generator](Funnel%20Generator/) v1.2.0

Create a customizable funnel with a bowl, tapered stem, optional handles, drip guard, and support for flat-sided (polygonal) profiles.

### 🖨️ [Mold Generator](Mold%20Generator/) v2.0.0

Turn any STL file into a two-part block mold, complete with registration marks and a pouring hole.

### 🎨 [Stencil Generator](Stencil%20Generator/) v1.0.0

Convert any SVG file into a rigid, 3D-printable stencil plate.

### 🪮 [Comb Generator](comb-generator.scad) v1.2.0

Design parametric 3D combs with customizable tooth profiles, including 5 professional hair-type presets. Add personalized text or SVG engravings.

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
