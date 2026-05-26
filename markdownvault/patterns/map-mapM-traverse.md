# map / mapM / traverse

[← INDEX](../INDEX.md) · [↑ Patterns](README.md) · [NAVIGATION](../NAVIGATION.md)

> **Mental model — three flavours of "apply a function to every element":**
> - `map`/`fmap` — pure function (no side effects)
> - `mapM` — monadic function, *collect* results
> - `mapM_` — monadic function, *discard* results (you just want the effects)
>
> Shape (the container) is always preserved.

Apply a function to every element, preserving shape.

## Pure: map (or fmap)
```haskell
map :: (a -> b) -> [a] -> [b]
map _ []     = []
map f (x:xs) = f x : map f xs

-- For other functors:
fmap :: Functor f => (a -> b) -> f a -> f b
```

## Monadic effect at each: mapM
```haskell
mapM :: Monad m => (a -> m b) -> [a] -> m [b]
mapM _ []     = return []
mapM f (x:xs) = do
  y  <- f x
  ys <- mapM f xs
  return (y : ys)
```

## Side-effect only: mapM_
```haskell
mapM_ :: Monad m => (a -> m b) -> [a] -> m ()
mapM_ _ []     = return ()
mapM_ f (x:xs) = f x >> mapM_ f xs
```

## Swap container inside-out: sequence
```haskell
sequence :: Monad m => [m a] -> m [a]
sequence []     = return []
sequence (m:ms) = do x <- m; xs <- sequence ms; return (x : xs)

-- mapM f = sequence . map f
```

## Tree variants (custom mapM)
```haskell
mapMTree :: Monad m => (a -> m b) -> BT a -> m (BT b)
mapMTree _ Empty        = return Empty
mapMTree f (Fork x l r) = do
  v' <- f x
  l' <- mapMTree f l
  r' <- mapMTree f r
  return (Fork v' l' r')
```

## When to use which
- `map`: pure transform on list
- `fmap`: pure transform on any Functor
- `mapM`: monadic effect at each element, COLLECT results
- `mapM_`: monadic effect, DISCARD results (just for side-effects)
- `sequence`: already have list-of-actions, want action-yielding-list
- `forM` / `forM_`: like mapM with args flipped (nice with inline lambda)

## See also
[Tree Recursion](tree-recursion.md) · [Overview](../monads/overview.md) · [Functor](../typeclasses/functor.md) · [mapM Tree](../templates/mapM-tree.md)
