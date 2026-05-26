# Conway's Game of Life (W1)

[← INDEX](../INDEX.md) · [↑ Examples](README.md) · [NAVIGATION](../NAVIGATION.md)

Cellular automaton — terminal-animated. Lecture W1 example.

> **Technique:** a board is `[[Cell]]`. One generation = compute every cell's neighbour count, apply the rule. IO loop animates by clearing screen between frames.


## Types
```haskell
import Control.Concurrent (threadDelay)

type Cell = (Int, Int)
type Grid = [Cell]     -- sparse: list of live cells
```

## Neighbours
```haskell
neighbours :: Cell -> [Cell]
neighbours (x, y) =
  [ (x + i, y + j)
  | i <- [-1..1], j <- [-1..1]
  , not (i == 0 && j == 0)
  ]
```

## Counts
```haskell
isLive :: Cell -> Grid -> Bool
isLive c g = c `elem` g

liveNeighbours :: Grid -> Cell -> [Cell]
liveNeighbours g c = filter (`isLive` g) (neighbours c)

births :: Grid -> [Cell]
births g = [c | c <- nub (concatMap neighbours g),
               not (isLive c g),
               length (liveNeighbours g c) == 3]

survivors :: Grid -> [Cell]
survivors g = [c | c <- g, length (liveNeighbours g c) `elem` [2, 3]]
```

## One step
```haskell
step :: Grid -> Grid
step g = survivors g ++ births g
```

## Render (terminal with ANSI)
```haskell
cls :: IO ()
cls = putStr "\ESC[2J"

goto :: Cell -> IO ()
goto (x, y) = putStr ("\ESC[" ++ show y ++ ";" ++ show x ++ "H")

printCell :: Cell -> IO ()
printCell p = do goto p; putChar 'O'

terminalRender :: Grid -> IO ()
terminalRender g = do
  cls
  mapM_ printCell g
```

## Animation loop
```haskell
delayTenthSec :: Int -> IO ()
delayTenthSec n = threadDelay (n * 100000)

life :: Grid -> IO ()
life g = do
  terminalRender g
  delayTenthSec 1
  life (step g)
```

## Example glider
```haskell
glider :: Grid
glider = [(2,1), (3,2), (1,3), (2,3), (3,3)]

main :: IO ()
main = life glider
```

## Pattern
Combines [List Comprehensions](../list-comprehensions.md) + [IO](../monads/io.md) + terminal control. Low exam probability but classic W1 reference.

## Key insights
- **Sparse representation** (list of live cells, not 2D grid) — simpler, scales better
- `neighbours` returns 8 cells around each
- `survivors` and `births` are independent — combine via `++`
- `nub` important to dedupe potential births (a dead cell may be neighbour of multiple live cells)
- IO loop with `threadDelay` for animation
- ANSI `\ESC[2J` clears screen, `\ESC[y;xH` positions cursor

## ⚠ Pitfalls
- Empty grid: `step []` should be `[]` — special-case to avoid `minimum []`
- `nub` is O(n²) — fine for exam-scale grids
- `printCell` doesn't add newline — placement controlled via `goto`
- `life` recurses infinitely — kill with Ctrl+C

## See also
[IO](../monads/io.md) · [List Comprehensions](../list-comprehensions.md) · [Higher Order Functions](../higher-order-functions.md)
