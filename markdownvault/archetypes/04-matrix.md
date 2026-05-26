# Archetype 04 — Matrix Predicate via Transpose

[← INDEX](../INDEX.md) · [↑ Archetypes](README.md) · [NAVIGATION](../NAVIGATION.md)

⭐⭐⭐⭐ Mock Q4 (magic square), TTT winner.

## Concept
Validate a property of `[[Int]]` / `Grid` by combining rows + columns + diagonals.

**Intuition:** rows live in the input; columns come from `transpose`; both diagonals are extracted with `zipWith (!!) xss [0..]` (main) and the reverse for anti-diagonal. Then `all` over all of them.

## Shape
```haskell
predicate xss =
  let rows  = xss
      cols  = transpose xss
      diag1 = zipWith (!!) xss [0..]
      diag2 = zipWith (!!) (reverse xss) [0..]
  in checkAll (rows ++ cols ++ [diag1, diag2])
```

## Typical sigs
```haskell
isMagicSquare :: [[Int]] -> Bool         -- Mock Q4
winner        :: Grid -> Maybe Player    -- TTT
allRowsEqual  :: [[a]] -> Bool
```

## Solution
```haskell
import Data.List (transpose)

isMagicSquare :: [[Int]] -> Bool
isMagicSquare [] = False
isMagicSquare xss =
  let target = sum (head xss)
      rowsOk = all (\r -> sum r == target) xss
      colsOk = all (\c -> sum c == target) (transpose xss)
      diag   = zipWith (!!) xss [0..]
      diagOk = sum diag == target
  in rowsOk && colsOk && diagOk
```

## ⚠ Traps
- off-by-one anti-diagonal (`reverse xss` or `[n-1, n-2 ..]`)
- empty grid base case
- non-square (validation `length xss == length (head xss)`)
- forgetting one of the two diagonals
- `(!!)` crashes on jagged lists
- confusing rows / cols (cols = `transpose rows`)

## Combines with
HOFs ([Folds](../patterns/folds.md)) · TTT ([#01](01-tree-recursion.md)-flavoured Grid) · list comp

## Seen
Mock Q4, S15 #141, S15 #150 (TTT winner), tiktaktoe.hs, ewan20.hs (manual columns variant)

## See also
[Mock Q4 Magic Square](../examples/mock-q4-magic-square.md) · [TTT Winner](../examples/ttt-winner.md)
