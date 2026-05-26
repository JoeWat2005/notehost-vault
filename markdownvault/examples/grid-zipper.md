# Grid Zipper (A1 GridWithAPointer)

[← INDEX](../INDEX.md) · [↑ Examples](README.md) · [NAVIGATION](../NAVIGATION.md)

2D zipper navigator over a grid. From Assignment 1 (Tatami).

> **Technique:** instead of an `(x, y)` index, split the 2D grid into "above rows", "current row split around the focus", "below rows". Each move shuffles one element across a boundary. O(1) per move + per edit.


## Types
```haskell
newtype Grid a = Grid { grid :: [[a]] } deriving Eq

newtype GridWithAPointer a =
  GridWithAPointer (Grid a, [a], a, [a], Grid a)
  deriving Eq
-- (gridAbove, leftRow-reversed, focus, rightRow, gridBelow)
```

## Movement

### Left / Right (within current row)
```haskell
moveLeft :: GridWithAPointer a -> GridWithAPointer a
moveLeft (GridWithAPointer (a, l:ls, f, rs, b)) =
  GridWithAPointer (a, ls, l, f:rs, b)
moveLeft _ = error "can't move left"

moveRight :: GridWithAPointer a -> GridWithAPointer a
moveRight (GridWithAPointer (a, ls, f, r:rs, b)) =
  GridWithAPointer (a, f:ls, r, rs, b)
moveRight _ = error "can't move right"
```

### Up / Down (refocus across rows)
```haskell
moveUp :: GridWithAPointer a -> GridWithAPointer a
moveUp (GridWithAPointer (Grid (row:above), ls, f, rs, Grid below)) =
  let i       = length ls                          -- column index
      (l, fr) = splitAt i row
      f'      = head fr
      r'      = tail fr
      currentRow = reverse ls ++ [f] ++ rs
  in GridWithAPointer (Grid above, reverse l, f', r', Grid (currentRow:below))
moveUp _ = error "can't move up"

moveDown :: GridWithAPointer a -> GridWithAPointer a
moveDown (GridWithAPointer (Grid above, ls, f, rs, Grid (row:below))) =
  let i       = length ls
      (l, fr) = splitAt i row
      f'      = head fr
      r'      = tail fr
      currentRow = reverse ls ++ [f] ++ rs
  in GridWithAPointer (Grid (above ++ [currentRow]), reverse l, f', r', Grid below)
moveDown _ = error "can't move down"
```

## Put (overwrite focus)
```haskell
put :: a -> GridWithAPointer a -> GridWithAPointer a
put x (GridWithAPointer (a, ls, _, rs, b)) =
  GridWithAPointer (a, ls, x, rs, b)
```

## Show instance (pretty-print with ANSI highlight)
```haskell
instance Show a => Show (GridWithAPointer a) where
  show (GridWithAPointer (Grid above, ls, f, rs, Grid below)) =
    showRows above
    ++ showRowWithFocus (reverse ls) f rs
    ++ showRows below

showRowWithFocus :: Show a => [a] -> a -> [a] -> String
showRowWithFocus ls f rs =
  concatMap pad ls ++ "\ESC[44m" ++ pad f ++ "\ESC[0m" ++ concatMap pad rs ++ "\n"
  where pad x = show x ++ " "

showRows :: Show a => [[a]] -> String
showRows = concatMap (\r -> concatMap (\x -> show x ++ " ") r ++ "\n")
```

## Tatami placement (4-way symmetry)
```haskell
putTatamiUp :: Integer -> GridWithAPointer Integer -> GridWithAPointer Integer
putTatamiUp n = moveDown . put n . moveUp . put n

putTatamiDown :: Integer -> GridWithAPointer Integer -> GridWithAPointer Integer
putTatamiDown n = moveUp . put n . moveDown . put n

putTatamiRight :: Integer -> GridWithAPointer Integer -> GridWithAPointer Integer
putTatamiRight n = moveLeft . put n . moveRight . put n

putTatamiLeft :: Integer -> GridWithAPointer Integer -> GridWithAPointer Integer
putTatamiLeft n = moveRight . put n . moveLeft . put n
```

## Pattern
[Archetype 17 Zipper](../archetypes/17-zipper.md) — focus + context navigation.

## Key insights
- **leftRow is REVERSED** (so head = closest to focus). Reverse at boundaries.
- **column index = `length leftRow`** — used to splitAt row when moving up/down
- **4-way symmetric**: write `moveLeft`, then mirror 3 times. Same for `putTatami*`, `hasCornerXY`, `canMoveX`.
- Errors when boundary reached — A1 used `error`, not Maybe

## ⚠ Pitfalls
- Left-context orientation: REVERSED, easy to flip wrong way
- `splitAt i row` for up/down — must use `length ls`
- When moving up/down, current row goes BACK onto opposite side stack
- Don't forget to wrap rows back into `Grid` constructor

## See also
[Archetype 17 Zipper](../archetypes/17-zipper.md) · [ADT Declarations](../templates/adt-declarations.md)
