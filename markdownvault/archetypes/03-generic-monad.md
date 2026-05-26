# Archetype 03 — Generic `Monad m =>` Combinator

[← INDEX](../INDEX.md) · [↑ Archetypes](README.md) · [NAVIGATION](../NAVIGATION.md)

⭐⭐⭐⭐ Mock Q2 (applyNTimes).

## Concept
Write a function polymorphic over any monad using only the Monad interface.

**Intuition:** the same recursion you'd write for a list, but every result is extracted with `<-`. You're forbidden from using monad-specific primitives like `get` or `tell` — only `do`/`return`/`<-`. This is why the same code works for Maybe, State, IO, etc.

## Shape
```haskell
f :: Monad m => ... -> m ...
-- do-block + return + (>>=) only; never reference a specific monad
```

## Typical sigs
```haskell
applyNTimes :: Monad m => m a -> (a -> m a) -> Int -> m [a]
mapM'   :: Monad m => (a -> m b) -> [a] -> m [b]
seq'    :: Monad m => [m a] -> m [a]
liftA2' :: Applicative f => (a -> b -> c) -> f a -> f b -> f c
join'   :: Monad m => m (m a) -> m a
```

## Solution
[Monadic Recursion](../patterns/monadic-recursion.md) · [mapM Tree](../templates/mapM-tree.md)

## ⚠ Traps
- using `get` / `tell` / specific-monad primitive → forces concreteness
- "exactly once" wording → no duplicate calls to `mf` in recursion
- `return [x]` vs `return x` — singleton list vs scalar
- forgetting base case → infinite loop on 0
- `pure (x:xs)` requires `xs` already-extracted via `<-`

## Combines with
[#01](01-tree-recursion.md) (mapM on tree) · [#02](02-state-game.md) (specialised State) · [#06](06-functor-instance.md)

## Seen
Mock Q2, S13 #127-130, S15 #142

## See also
[Mock Q2 Applyntimes](../examples/mock-q2-applyNTimes.md) · [Overview](../monads/overview.md)
