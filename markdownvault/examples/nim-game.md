# Nim Game (extended)

[← INDEX](../INDEX.md) · [↑ Examples](README.md) · [NAVIGATION](../NAVIGATION.md)

Full Nim playing using State monad.

> **Technique:** the board IS the State. Multi-step sequences chain naturally via `do`. Add IO if you want an interactive loop.

## Setup
```haskell
import Control.Monad.State

type NimBoard = (Int, Int)
type NimGame a = State NimBoard a
data Heap = First | Second
type Move = (Int, Heap)
```

## Primitives
```haskell
gameOver :: NimGame Bool
gameOver = do (x, y) <- get; return (x == 0 && y == 0)

takeTokens :: Int -> Heap -> NimGame ()
takeTokens n First = do (x, y) <- get; put (max 0 (x-n), y)
takeTokens n Second = do (x, y) <- get; put (x, max 0 (y-n))
```

## Apply sequence of moves
```haskell
applyMoves :: [Move] -> NimGame ()
applyMoves []           = return ()
applyMoves ((n, h):ms)  = do
  takeTokens n h
  applyMoves ms
```

## Reset-on-win variant (A3-style)
```haskell
applyMovesReset :: NimBoard -> [Move] -> NimGame ()
applyMovesReset _     [] = return ()
applyMovesReset start ((n, h):moves) = do
  takeTokens n h
  over <- gameOver
  if over then put start else return ()
  applyMovesReset start moves
```

## Winning strategy (simplified)
```haskell
nimSum :: NimBoard -> Int
nimSum (x, y) = x `xor` y

bestMove :: NimBoard -> Maybe Move
bestMove (x, y)
  | nimSum (x, y) == 0 = Nothing   -- losing position
  | x >= y && (x `xor` y) <= x = Just (x - (x `xor` y), First)
  | otherwise = Just (y - (x `xor` y), Second)
```
(Note: `xor` requires `import Data.Bits`; may not be available in exam.)

## Run examples
```haskell
runState gameOver (0, 0)                   -- (True, (0, 0))

execState (takeTokens 5 First) (3, 2)       -- (0, 2)

execState (applyMoves [(1, First), (1, Second)]) (3, 2)
-- (2, 1)
```

## Pattern
[#02](../archetypes/02-state-game.md) — State monad game.

## See also
[Mock Q3 Nim](mock-q3-nim.md) · [State Game](../templates/state-game.md)
