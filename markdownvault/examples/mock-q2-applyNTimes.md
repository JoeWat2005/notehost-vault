# Mock Q2 — applyNTimes

[← INDEX](../INDEX.md) · [↑ Examples](README.md) · [NAVIGATION](../NAVIGATION.md)

10 marks: generic `Monad m =>` combinator.

> **Technique:** monadic recursion that works for *any* monad. The same code runs against IO, Maybe, State — because we only use `do`/`<-`/`return`, never monad-specific primitives.

## Spec
```haskell
applyNTimes :: Monad m => m a -> (a -> m a) -> Int -> m [a]
```

Apply `mf` to `mx` exactly n times, returning all `n+1` intermediate results (a list). Each monadic action runs exactly once.

## Canonical solution
```haskell
applyNTimes :: Monad m => m a -> (a -> m a) -> Int -> m [a]
applyNTimes mx _ 0 = do
  x <- mx
  return [x]
applyNTimes mx f n = do
  x  <- mx
  xs <- applyNTimes (f x) f (n - 1)
  return (x : xs)
```

## Pattern
[#03](../archetypes/03-generic-monad.md) — Monad m => combinator.

## Why it works in any monad
- `mx` is the seed
- `f x :: m a` is the next-step computation
- `do {x <- mx; …}` extracts and chains without ever naming a specific monad

## Example uses
```haskell
-- IO: prompt for next value n times
applyNTimes getLine (\s -> putStrLn ("Got: " ++ s) >> getLine) 3

-- Maybe: step that may fail
applyNTimes (Just 0) (\n -> if n < 5 then Just (n+1) else Nothing) 3

-- State Int: increment-each-step trace
runState (applyNTimes (return 0) (\n -> do put (n+1); return (n+1)) 3) 0
```

## ⚠ Traps
- **"Exactly once"**: don't duplicate `mf x` in your recursion
- Base case `n = 0` returns `[x]` (singleton), not `[]`
- `return x` vs `return [x]`

## See also
[Monadic Recursion](../patterns/monadic-recursion.md) · [Overview](../monads/overview.md)
