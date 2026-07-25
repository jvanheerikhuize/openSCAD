# Purpose

**Problem:** Designing 3D-printable objects requires balancing parametrization (for customization) with the need to share designs, but OpenSCAD scripts are often opaque and lack clear documentation of customizable parameters.

**Audience:** Makers, 3D printing enthusiasts, and hardware designers who want to share designs with built-in customization rather than requiring forking.

**Key constraints:** Must be parametric (customizable via OpenSCAD Customizer without code edits), generate both STL (for printing) and SVG (for reference/documentation), and include per-generator documentation.

**Success metric:** A maker can load an OpenSCAD design, adjust parameters in the Customizer UI, export STL/SVG variants, and print multiple versions without editing source code or understanding SCAD syntax.
