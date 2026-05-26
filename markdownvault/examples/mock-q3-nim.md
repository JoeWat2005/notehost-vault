# Mock Q3 — Nim (State monad)

[← INDEX](../INDEX.md) · [↑ Examples](README.md) · [NAVIGATION](../NAVIGATION.md)

10 marks: State monad game.

> **Technique:** the board is the state. Each move reads, computes, writes. Predicates like `gameOver` are pure functions of the current state — wrap them with `get`/`return`.

## Spec
```haskell
import Control.Monad.State

type NimBoard = (Int, Int)
type NimGame a = State NimBoard a
data Heap = First | Second

gameOver   :: NimGame Bool
takeTokens :: Int -> Heap -> NimGame ()
```

- `gameOver` — True iff both heaps empty
- `takeTokens n h` — remove n tokens from heap h, clamped at 0

## Canonical solution
```haskell
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

## Pattern
[#02](../archetypes/02-state-game.md) — State monad game.

## Example trace
```haskell
runState gameOver (0, 0)              -- (True,  (0, 0))
runState gameOver (3, 2)              -- (False, (3, 2))

execState (takeTokens 5 First) (3, 2)  -- (0, 2)   ← clamped
execState (takeTokens 1 Second) (3, 2) -- (3, 1)

-- Sequence:
execState (do takeTokens 2 First
              takeTokens 1 Second) (3, 2)   -- (1, 1)
```

## ⚠ Traps
- **Clamp underflow**: `max 0 (x - n)` not raw subtraction
- Forget `import Control.Monad.State` → auto-marker fails
- `State a s` vs `State s a` — `s` is FIRST type param

## See also
[State Game](../templates/state-game.md) · [State](../monads/state.md) · [Nim Game](nim-game.md)
