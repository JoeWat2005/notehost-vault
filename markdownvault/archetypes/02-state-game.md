# Archetype 02 — State Monad Game / Simulation

[← INDEX](../INDEX.md) · [↑ Archetypes](README.md) · [NAVIGATION](../NAVIGATION.md)

⭐⭐⭐⭐⭐ Mock Q3 (Nim), A3 (RoundRobin/schedule), S12.

## Concept
Model evolving state implicitly via State; expose `gameOver` predicate + action functions.

**Intuition:** the board IS the state. Each move = read board → compute new board → write back. Predicates like `gameOver` just inspect the current state.

## Shape
```haskell
type FooGame a = State BoardType a

gameOver :: FooGame Bool
gameOver = do s <- get; return (predicate s)

doMove :: Param -> FooGame ()
doMove p = do s <- get; put (apply p s)
```

## Typical sigs
```haskell
State (Int, Int) Bool                    -- predicate
Int -> Heap -> State (Int, Int) ()       -- mutator
execState (compute n) initial            -- runner
type NimGame a = State (Int, Int) a
```

## Solution
[State Game](../templates/state-game.md) · [State](../monads/state.md)

## ⚠ Traps
- forgetting `import Control.Monad.State` — auto-marker fails
- `State a s` vs `State s a` — `s` is FIRST
- clamp underflow (`max 0 (x - n)`)
- runState vs evalState vs execState — pick which extracts what
- `get >>= put . f` when `modify f` suffices

## Combines with
[#14 Multi-effect](14-multi-effect.md) · [#15 Writer](15-writer-trace.md) · [#01 Tree (labeling)](01-tree-recursion.md)

## Seen
Mock Q3, A3 (whole), S12 #111-120, S15 #144, W9

## See also
[Mock Q3 Nim](../examples/mock-q3-nim.md) · [Nim Game](../examples/nim-game.md) · [State Fresh](../templates/state-fresh.md)
