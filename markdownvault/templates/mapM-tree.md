# Template — mapM on a tree (monadic traversal)

[← INDEX](../INDEX.md) · [↑ Templates](README.md) · [NAVIGATION](../NAVIGATION.md)

> **What this pattern is doing:** like `mapBT`, but the per-element transform is *monadic* — it can fail (Maybe), update state (State), do IO, etc. Bind every result with `<-`, then rebuild the tree with the same constructor.

**When to use:** label every node (with State), validate every node (with Maybe), print every node (with IO), etc.

Preserve tree structure, apply a monadic effect to every value.

## Binary tree
```haskell
mapMTree :: Monad m => (a -> m b) -> BT a -> m (BT b)
mapMTree _ Empty        = return Empty
mapMTree f (Fork x l r) = do
  v' <- f x
  l' <- mapMTree f l
  r' <- mapMTree f r
  return (Fork v' l' r')
```

## Rose tree
```haskell
mapMRose :: Monad m => (a -> m b) -> Rose a -> m (Rose b)
mapMRose f (Leaf x)    = do
  y <- f x
  return (Leaf y)
mapMRose f (Branch xs) = do
  ys <- mapM (mapMRose f) xs
  return (Branch ys)
```

## Side-effect only (mapM_ on tree)
```haskell
walkTree_ :: Monad m => (a -> m ()) -> BT a -> m ()
walkTree_ _ Empty        = return ()
walkTree_ f (Fork x l r) = do walkTree_ f l; f x; walkTree_ f r
```

## Generic monad — S11 #109
```haskell
mapMTree :: Monad m => (a -> m b) -> BT a -> m (BT b)
mapMTree g Empty        = return Empty
mapMTree g (Fork x l r) = do
  v' <- g x
  l' <- mapMTree g l
  r' <- mapMTree g r
  return (Fork v' l' r')

-- Specialised at m = State Int:
labelTree :: BT a -> State Int (BT (Int, a))
labelTree = mapMTree (\x -> do n <- get; put (n+1); return (n, x))
```

## ⚠ Pitfalls
- Result preserves shape — return same ctor with transformed values
- Order of effects = order of `<-` bindings (above is pre-order; swap for in/post)
- Don't `map` (pure) when you mean `mapM` (monadic)

## See also
[Map mapM Traverse](../patterns/map-mapM-traverse.md) · [Traversals](../patterns/traversals.md) · [Overview](../monads/overview.md)
