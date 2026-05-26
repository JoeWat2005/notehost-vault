# Traversals

[← INDEX](../INDEX.md) · [↑ Patterns](README.md) · [NAVIGATION](../NAVIGATION.md)

> **Mental model:** a traversal is a tree-walk that visits each node in some order. The three classic orders differ in *where the root sits relative to its subtrees*: pre-order = root before, in-order = root between, post-order = root after.

Linearise a tree into a list.

## Three orders (binary tree)
```haskell
inOrder, preOrder, postOrder :: BT a -> [a]

inOrder Empty        = []
inOrder (Fork x l r) = inOrder l ++ [x] ++ inOrder r          -- L, root, R

preOrder Empty        = []
preOrder (Fork x l r) = [x] ++ preOrder l ++ preOrder r       -- root, L, R

postOrder Empty        = []
postOrder (Fork x l r) = postOrder l ++ postOrder r ++ [x]    -- L, R, root
```

In-order on a BST gives a sorted list:
```haskell
bstsort :: Ord a => [a] -> [a]
bstsort = inOrder . foldr insertBST Empty
```

## Level-order (BFS)
```haskell
levels Empty        = []
levels (Fork x l r) = [x] : mergeLevels (levels l) (levels r)
  where mergeLevels xss []           = xss
        mergeLevels [] yss           = yss
        mergeLevels (xs:xss)(ys:yss) = (xs ++ ys) : mergeLevels xss yss

breadthFirst = concat . levels
```

## Rose tree traversal
```haskell
flattenR (Leaf x)    = [x]
flattenR (Branch xs) = concatMap flattenR xs
```

## State-labelled traversal (number every node)
**Intuition:** the position of `n <- get; put (n+1)` *between* the recursive calls determines whether labels appear in pre-, in-, or post-order. Below labels in in-order.
```haskell
labelTree :: BT a -> BT (Int, a)
labelTree t = evalState (go t) 0
  where
    go :: BT a -> State Int (BT (Int, a))
    go Empty        = return Empty
    go (Fork x l r) = do
      l' <- go l
      n  <- get; put (n+1)
      r' <- go r
      return (Fork (n, x) l' r')
```

## Side-effect-only traversal
**Idea:** when you only care about the *effects* per node (printing, logging), not building a new tree. Returns `()`.
```haskell
walk :: Monad m => (a -> m ()) -> BT a -> m ()
walk _      Empty        = return ()
walk action (Fork x l r) = do walk action l; action x; walk action r
```

## Address enumeration
```haskell
data Direction = L | R
type Address   = [Direction]

addresses Empty        = []
addresses (Fork _ l r) = [] : map (L:) (addresses l)
                            ++ map (R:) (addresses r)
```

## See also
[Tree Recursion](tree-recursion.md) · [mapM Tree](../templates/mapM-tree.md) · [State](../monads/state.md) · [Label Tree](../examples/label-tree.md)
