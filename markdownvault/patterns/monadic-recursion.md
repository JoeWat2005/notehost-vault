# Monadic Recursion

[← INDEX](../INDEX.md) · [↑ Patterns](README.md) · [NAVIGATION](../NAVIGATION.md)

> **Mental model:** the *structure* of monadic recursion is the same as plain recursion (`f [] = base ; f (x:xs) = combine x (f xs)`), but every value you'd normally bind with `let`/`=` gets bound with `<-` instead, because it's coming out of a monadic context. `return` re-wraps a pure value back into the monad.

Recursion inside `do`-blocks where each step is a monadic action.

## Generic Monad m => combinator (Mock Q2)
**Idea:** same as cons-recursion, but each `<-` extracts a value from `m`. Works for *any* monad — so the same code handles Maybe, State, IO, etc.
```haskell
applyNTimes :: Monad m => m a -> (a -> m a) -> Int -> m [a]
applyNTimes mx _ 0 = do x <- mx; return [x]
applyNTimes mx f n = do
  x  <- mx
  xs <- applyNTimes (f x) f (n-1)
  return (x : xs)
```

## Sequence list of actions
```haskell
seq' :: Monad m => [m a] -> m [a]
seq' []     = return []
seq' (m:ms) = do x <- m; xs <- seq' ms; return (x : xs)
```

## mapM (apply monadic fn to each)
```haskell
mapM' :: Monad m => (a -> m b) -> [a] -> m [b]
mapM' _ []     = return []
mapM' f (x:xs) = do y <- f x; ys <- mapM' f xs; return (y : ys)
```

## Case-on-recursive-Maybe (short-circuit)
```haskell
takeMaybe :: Int -> [a] -> Maybe [a]
takeMaybe 0 _      = Just []
takeMaybe _ []     = Nothing
takeMaybe n (x:xs) = case takeMaybe (n-1) xs of
  Nothing   -> Nothing
  Just rest -> Just (x : rest)
-- IDIOMATIC equivalent:
takeMaybe n (x:xs) = do rest <- takeMaybe (n-1) xs; return (x : rest)
```

## Case-on-pair-of-Maybes (combine two recursive)
```haskell
case (rec a, rec b) of
  (Just x, Just y) -> Just (combine x y)
  _                -> Nothing
-- IDIOMATIC:
do x <- rec a; y <- rec b; return (combine x y)
```

## ⚠ Pitfalls
- Use `<-` (bind) not `=` (let) for monadic results
- "Exactly once" wording → don't duplicate the call to `mf` in recursion
- `pure (x:xs)` requires `xs` already-extracted via earlier `<-`
- Forgetting base case loops on 0

## See also
[Monadic Recursion](monadic-recursion.md) · [Overview](../monads/overview.md) · [Map mapM Traverse](map-mapM-traverse.md) · [Generic Monad](../archetypes/03-generic-monad.md) · [Mock Q2 Applyntimes](../examples/mock-q2-applyNTimes.md)
