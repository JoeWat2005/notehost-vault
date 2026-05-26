# Archetype 17 — Zipper Navigation

[← INDEX](../INDEX.md) · [↑ Archetypes](README.md) · [NAVIGATION](../NAVIGATION.md)

⭐ A1 (GridWithAPointer); not seen in problem sheets.

## Concept
Data type with focus point + surrounding context, enabling O(1) edit + move.

**Intuition:** instead of an index into a list/grid, you split the structure into "left of cursor", "the focused element", and "right of cursor". Moving is just shifting an element across the boundary. Edits become O(1) because the focus is *right there*.

## Shape
```haskell
-- 1D zipper
newtype Z a = Z (leftCtx, focus, rightCtx)

-- 2D zipper (A1)
newtype GridWithAPointer a =
  GridWithAPointer (Grid a, [a], a, [a], Grid a)
  -- above, leftRowRev, focus, rightRow, below
```

## Typical sigs
```haskell
moveLeft, moveRight, moveUp, moveDown :: Z a -> Z a
put :: a -> Z a -> Z a
```

## Solution
Pattern-match all components; cons/uncons between focus and ctx.

```haskell
moveLeft (GridWithAPointer (a, l:ls, f, rs, b)) =
  GridWithAPointer (a, ls, l, f:rs, b)
moveLeft _ = error "can't move left"

moveRight (GridWithAPointer (a, ls, f, r:rs, b)) =
  GridWithAPointer (a, f:ls, r, rs, b)
moveRight _ = error "can't move right"

moveUp (GridWithAPointer (Grid (row:above), ls, f, rs, Grid below)) =
  let i = length ls
      (l', f':r') = splitAt i row
      currentRow  = reverse ls ++ [f] ++ rs
  in GridWithAPointer (Grid above, reverse l', f', r', Grid (currentRow:below))
moveUp _ = error "can't move up"
```

## ⚠ Traps
- Boundary failure (use `error` or Maybe-ify)
- Left context orientation: reversed (closer-to-focus first) — easy to flip
- Row split off-by-one when moving up/down (use `length leftCtx`)
- Re-deriving all 4 moves — write moveLeft, then mirror 3 times

## Combines with
[ADT design](../templates/adt-declarations.md) · [#13 Show](13-pretty-print.md) · 4-way symmetry pattern

## Seen
A1 entire assignment; specific to Tatami covering. Unlikely on exam due to size.

## See also
[ADT Declarations](../templates/adt-declarations.md)
