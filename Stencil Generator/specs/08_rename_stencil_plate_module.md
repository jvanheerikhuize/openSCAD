# Spec 08 — Rename `stencil_plate()` Module

## Problem

All variables now use the `plate_` prefix and the section header says
`PLATE`, but the module is still called `stencil_plate()`. This
inconsistency is minor but breaks the naming convention.

## Solution

Rename `stencil_plate()` → `plate()`.

### Implementation

1. Rename module definition on line ~192.
2. Update the call site in `build()` on line ~175.
3. No preset or assertion changes.
4. Bump version.

### Risks

- None. Internal rename only — no external API.
