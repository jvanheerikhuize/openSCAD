# Spec 09 — Unify Handle Modules

## Problem

`handle_1()` and `handle_2()` are near-identical modules differing only
in the sign of the Y-translation. This duplication means every handle
change (grip holes, rounded ends, etc.) must be applied twice.

## Solution

Replace both modules with a single `handle(side)` module that takes a
`side` parameter (`+1` for positive-Y, `-1` for negative-Y).

### Implementation

1. Create `handle(side)` module:
   ```openscad
   module handle(side) {
       y_offset = side == 1
           ? plate_length / 2 - handle_overlap
           : -(plate_length / 2 + handle_length);
       translate([
           -handle_width / 2,
           y_offset,
           -plate_depth / 2
       ])
           cube([handle_width, handle_length + handle_overlap, plate_depth]);
   }
   ```
2. Update `build()`:
   ```openscad
   if (show_handle_1) handle(1);
   if (show_handle_2) handle(-1);
   ```
3. Remove `handle_1()` and `handle_2()` module definitions.
4. No preset or assertion changes.
5. Bump version.

### Dependencies

- Should be done before specs 02 (grip holes) and 03 (rounded ends) to
  avoid duplicating those features across two modules.

### Risks

- None. Behavioural output is identical.
