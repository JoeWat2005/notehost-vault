# Template — State monad game / simulation

[← INDEX](../INDEX.md) · [↑ Templates](README.md) · [NAVIGATION](../NAVIGATION.md)

> **What this pattern is doing:** the game board IS the state. Each move = read the board, compute the new board, write it. Predicates like `gameOver` are pure functions of the current state.

**When to use:** Nim, TTT, any turn-based game, simulation with running score, board updates.

```haskell
import Control.Monad.State

type FooGame a = State BoardType a

gameOver :: FooGame Bool
gameOver = do
  s <- get
  return (predicate s)

makeMove :: ActionType -> FooGame ()
makeMove action = do
  s <- get
  put (apply action s)
```

## Nim (Mock Q3)
```haskell
type NimGame a = State (Int, Int) a
data Heap      = First | Second

gameOver :: NimGame Bool
gameOver = do
  (x, y) <- get
  return (x == 0 && y == 0)

takeTokens :: Int -> Heap -> NimGame ()
takeTokens n First = do
  (x, y) <- get
  put (max 0 (x - n), y)
takeTokens n Second = do
  (x, y) <- get
  put (x, max 0 (y - n))
```

## Sequence of moves
```haskell
applyMoves :: [(Int, Heap)] -> NimGame ()
applyMoves []           = return ()
applyMoves ((n, h):ms)  = do
  takeTokens n h
  applyMoves ms

-- Run:
runGame moves initial = execState (applyMoves moves) initial
```

## With reset on win (A3-style)
```haskell
applyMovesReset start []                = return ()
applyMovesReset start ((n, h) : moves)  = do
  takeTokens n h
  over <- gameOver
  if over then put start else return ()
  applyMovesReset start moves
```

## ⚠ Pitfalls
- Clamp underflow: `max 0 (x - n)`, not raw subtract
- Forget the `import Control.Monad.State`
- Order of state changes — `get` BEFORE you `put` the modified

## See also
[State](../monads/state.md) · [State Game](../archetypes/02-state-game.md) · [Mock Q3 Nim](../examples/mock-q3-nim.md) · [Nim Game](../examples/nim-game.md)
