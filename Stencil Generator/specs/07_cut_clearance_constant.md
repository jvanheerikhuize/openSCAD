# Spec 07 — Boolean Cut Clearance Constant

## Problem

The magic number `+ 2` appears 6 times in the codebase as extrusion
overshoot for clean boolean difference operations. Its purpose is not
self-evident, and changing it requires editing multiple locations.

## Solution

Define a named constant `cut_clearance = 2;` in the `[Hidden]` section
and replace all `+ 2` boolean margins with `+ cut_clearance`.

### Affected locations

| Module                | Current code                                  |
|-----------------------|-----------------------------------------------|
| `assemble()`          | `plate_depth / 2 + 1` and cube dimensions     |
| `registration_marks()`| `plate_depth + 2` (×2, horizontal + vertical) |
| `svg_cutout()`        | `plate_depth + 2` (×2, cube + extrude)        |

Note: `assemble()` uses `+ 1` for the cross-section clip volume, which
is a different concern (half-space margin). This should remain separate
or use `cut_clearance / 2`.

### Implementation

1. Add `cut_clearance = 2;` in the `[Hidden]` section with comment:
   ```
   // Extra height added to boolean-cut volumes to guarantee clean
   // subtraction through the full plate depth (prevents z-fighting).
   ```
2. Replace all `plate_depth + 2` with `plate_depth + cut_clearance`.
3. Replace the `+ 1` in `assemble()` cross-section clip with
   `+ cut_clearance / 2` (or keep as-is with a comment — this one is
   less critical since it's a visual aid, not a boolean cut).
4. No new assertions needed (constant, not user-facing).
5. No preset changes needed.
6. Bump version.

### Risks

- None. Pure refactor, no functional change.
