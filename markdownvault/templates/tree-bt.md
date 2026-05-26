# Template — Binary tree recursion

[← INDEX](../INDEX.md) · [↑ Templates](README.md) · [NAVIGATION](../NAVIGATION.md)

> **What this pattern is doing:** one equation per constructor. `Empty` stops; `Fork x l r` does work with `x` and recurses on both subtrees. The recursion automatically covers the whole tree.

**When to use:** any function on a `BT`/`Tree` ADT. Always start from this skeleton.

```haskell
data BT a = Empty | Fork a (BT a) (BT a)

f :: BT a -> ResultType
f Empty        = base
f (Fork x l r) = combine x (f l) (f r)
```

## Worked specialisations

```haskell
size, height, sumBT :: BT a -> Int
leaves              :: BT a -> Int
mirror              :: BT a -> BT a
mapBT               :: (a -> b) -> BT a -> BT b
flatten             :: BT a -> [a]
countBT             :: Eq a => a -> BT a -> Int

size Empty        = 0
size (Fork _ l r) = 1 + size l + size r

height Empty        = 0
height (Fork _ l r) = 1 + max (height l) (height r)

leaves Empty                = 0
leaves (Fork _ Empty Empty) = 1
leaves (Fork _ l r)         = leaves l + leaves r

mirror Empty        = Empty
mirror (Fork x l r) = Fork x (mirror r) (mirror l)       -- swap subtrees

mapBT _ Empty        = Empty
mapBT f (Fork x l r) = Fork (f x) (mapBT f l) (mapBT f r)

flatten Empty        = []
flatten (Fork x l r) = flatten l ++ [x] ++ flatten r     -- in-order

sumBT Empty        = 0
sumBT (Fork x l r) = x + sumBT l + sumBT r

countBT _ Empty                                = 0
countBT y (Fork x l r) | y == x    = 1 + rec
                       | otherwise = rec
  where rec = countBT y l + countBT y r
```

## BST variants

```haskell
isBST :: Ord a => BT a -> Bool
isBST t = go t
  where
    go Empty        = True
    go (Fork x l r) = allLT x l && allGT x r && go l && go r
    allLT _ Empty        = True
    allLT y (Fork x l r) = x < y && allLT y l && allLT y r
    allGT _ Empty        = True
    allGT y (Fork x l r) = x > y && allGT y l && allGT y r

insertBST x Empty = Fork x Empty Empty
insertBST x t@(Fork v l r)
  | x < v  = Fork v (insertBST x l) r
  | x > v  = Fork v l (insertBST x r)
  | otherwise = t           -- duplicate: idempotent
```

## See also
[Tree Recursion](../patterns/tree-recursion.md) · [Tree Rose](tree-rose.md) · [BST](../archetypes/11-bst.md)
