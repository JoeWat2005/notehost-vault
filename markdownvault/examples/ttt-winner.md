# TTT Winner detection

[← INDEX](../INDEX.md) · [↑ Examples](README.md) · [NAVIGATION](../NAVIGATION.md)

Find winner of a tic-tac-toe grid by checking rows/cols/diags.

> **Technique:** matrix predicate. Combine rows + cols (via `transpose`) + both diagonals into one list of lines, then check if any is a winning triple.

## Types
```haskell
import Data.List (transpose)

data Player = X | O           deriving (Eq, Show)
type Grid = [[Maybe Player]]
```

## Solution
```haskell
winner :: Grid -> Maybe Player
winner grid = checkLines (rows ++ cols ++ diags)
  where
    rows = grid
    cols = transpose grid
    diags =
      [ [grid !! 0 !! 0, grid !! 1 !! 1, grid !! 2 !! 2]
      , [grid !! 0 !! 2, grid !! 1 !! 1, grid !! 2 !! 0]
      ]

checkLines :: [[Maybe Player]] -> Maybe Player
checkLines []           = Nothing
checkLines (line:lines) =
  case line of
    [Just p, Just q, Just r] | p == q && q == r -> Just p
    _                                            -> checkLines lines
```

## Pattern
[#04](../archetypes/04-matrix.md) — matrix predicate via transpose. Same shape as magic square.

## Example
```haskell
winner [[Just X, Just X, Just X], [Nothing, Just O, Nothing], [Just O, Nothing, Nothing]]
-- Just X (top row)

winner [[Just X, Just O, Just X], [Nothing, Just O, Nothing], [Nothing, Just O, Just X]]
-- Just O (middle column)

winner [[Nothing, Nothing, Nothing], [Nothing, Just X, Nothing], [Nothing, Nothing, Nothing]]
-- Nothing
```

## ⚠ Traps
- `(!!)` is partial — assumes 3×3 grid
- Don't forget anti-diagonal
- `Nothing` cells in a line don't match the `Just p, Just q, Just r` pattern

## See also
[Mock Q4 Magic Square](mock-q4-magic-square.md) · [Matrix](../archetypes/04-matrix.md)
