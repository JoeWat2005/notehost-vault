# Mock Q4 — isMagicSquare

[← INDEX](../INDEX.md) · [↑ Examples](README.md) · [NAVIGATION](../NAVIGATION.md)

10 marks: matrix predicate via transpose.

> **Technique:** rows live in the input directly; columns come from `transpose`; the main diagonal is `zipWith (!!) xss [0..]`. Compare every sum to the target.

## Spec
```haskell
isMagicSquare :: [[Int]] -> Bool
```

A magic square is a square matrix where all row sums, column sums, and both diagonals are equal.

## Canonical solution
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

## Pattern
[#04](../archetypes/04-matrix.md) — matrix predicate via transpose.

## Example
```haskell
isMagicSquare [[2,7,6],[9,5,1],[4,3,8]]  -- True (3×3 magic, all sums = 15)
isMagicSquare [[1,2],[3,4]]              -- False
isMagicSquare []                         -- False
```

## ⚠ Traps
- **Empty grid case**: must return False (or `undefined` — depends on spec)
- Anti-diagonal (second diagonal): use `zipWith (!!) (reverse xss) [0..]` if asked
- Off-by-one in `[0..n-1]` — `[0..]` infinite is fine because zip-truncates
- Non-square matrix — `zipWith (!!) xss [0..]` crashes if rows shorter than length
- `(!!)` is partial — careful with jagged input

## Anti-diagonal alternative
```haskell
diag2 = zipWith (!!) (reverse xss) [0..]
```

## See also
[Matrix](../archetypes/04-matrix.md) · [TTT Winner](ttt-winner.md)
