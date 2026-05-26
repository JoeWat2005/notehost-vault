# Template — State for counters / fresh IDs

[← INDEX](../INDEX.md) · [↑ Templates](README.md) · [NAVIGATION](../NAVIGATION.md)

> **What this pattern is doing:** keep an `Int` (or any counter type) inside `State`. `fresh` is the classic "give me a unique number" primitive — `get` the current value, `put` the next, return the old. Use it inside a tree/list traversal to number nodes.

```haskell
import Control.Monad.State

fresh :: State Int Int
fresh = do n <- get; put (n+1); return n

countSomething :: TraversableType -> State Int ()
countSomething (Container xs) = mapM_ countSomething xs
countSomething Atom = modify (+1)
```

## Run wrappers
```haskell
runFresh :: State Int [Int]
runFresh = do { a <- fresh; b <- fresh; c <- fresh; return [a, b, c] }

evalState runFresh 0    -- [0, 1, 2]
execState runFresh 0    -- 3
```

## Label a tree (in-order)
```haskell
labelTree :: BT a -> BT (Int, a)
labelTree t = evalState (go t) 0
  where
    go Empty        = return Empty
    go (Fork x l r) = do
      l' <- go l
      n  <- get; put (n+1)
      r' <- go r
      return (Fork (n, x) l' r')
```

## Count files (modify counter)
```haskell
countFiles :: Dir -> State Int ()
countFiles (File _ _)    = modify (+1)
countFiles (SubDir _ cs) = mapM_ countFiles cs
```

## See also
[State](../monads/state.md) · [Traversals](../patterns/traversals.md) · [Label Tree](../examples/label-tree.md)
