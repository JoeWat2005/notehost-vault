# Label Tree (State traversal)

[← INDEX](../INDEX.md) · [↑ Examples](README.md) · [NAVIGATION](../NAVIGATION.md)

Assign a unique integer ID to every node in traversal order.

> **Technique:** combine tree recursion with the State monad — `fresh` produces the next unique label. Where you call `fresh` in the recursion (before / between / after subtree calls) determines pre/in/post-order labelling.

## Spec
```haskell
labelTree :: BT a -> BT (Int, a)
```

## Solution (in-order labelling)
```haskell
import Control.Monad.State

labelTree :: BT a -> BT (Int, a)
labelTree t = evalState (go t) 0
  where
    go Empty        = return Empty
    go (Fork x l r) = do
      l' <- go l                     -- label left first
      n  <- get; put (n+1)           -- fresh ID
      r' <- go r
      return (Fork (n, x) l' r')
```

## Pre-order variant
```haskell
goPre Empty        = return Empty
goPre (Fork x l r) = do
  n  <- get; put (n+1)               -- fresh first
  l' <- goPre l
  r' <- goPre r
  return (Fork (n, x) l' r')
```

## Post-order variant
```haskell
goPost Empty        = return Empty
goPost (Fork x l r) = do
  l' <- goPost l
  r' <- goPost r
  n  <- get; put (n+1)               -- fresh last
  return (Fork (n, x) l' r')
```

## Using fresh helper
```haskell
fresh :: State Int Int
fresh = do n <- get; put (n+1); return n

labelTreeIn :: BT a -> BT (Int, a)
labelTreeIn t = evalState (go t) 0
  where
    go Empty        = return Empty
    go (Fork x l r) = do
      l' <- go l
      n  <- fresh
      r' <- go r
      return (Fork (n, x) l' r')
```

## Pattern
[#02](../archetypes/02-state-game.md) + [#01](../archetypes/01-tree-recursion.md) — State threading through tree traversal.

## Example
```haskell
labelTree (Fork 'a' (Fork 'b' Empty Empty) (Fork 'c' Empty Empty))
-- Fork (1, 'a')
--   (Fork (0, 'b') Empty Empty)
--   (Fork (2, 'c') Empty Empty)
```

## See also
[State Fresh](../templates/state-fresh.md) · [Traversals](../patterns/traversals.md)
