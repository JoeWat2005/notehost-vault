# Tree Recursion

[← INDEX](../INDEX.md) · [↑ Patterns](README.md) · [NAVIGATION](../NAVIGATION.md)

> **Mental model:** an ADT with recursive constructors is processed *structurally* — one equation per constructor. The "base" constructor stops the recursion; the "step" constructor recurses on each child and combines the results.

Pattern-match each constructor, recurse on subtrees. The course's #1 archetype.

## Binary tree (BT)
```haskell
data BT a = Empty | Fork a (BT a) (BT a)

f :: BT a -> r
f Empty        = base                          -- stop case
f (Fork x l r) = combine x (f l) (f r)         -- do work + recurse on both subtrees
```

### Ready specialisations
```haskell
size Empty        = 0
size (Fork _ l r) = 1 + size l + size r

height Empty        = 0
height (Fork _ l r) = 1 + max (height l) (height r)

flatten Empty        = []
flatten (Fork x l r) = flatten l ++ [x] ++ flatten r   -- in-order

mirror Empty        = Empty
mirror (Fork x l r) = Fork x (mirror r) (mirror l)

mapBT _ Empty        = Empty
mapBT f (Fork x l r) = Fork (f x) (mapBT f l) (mapBT f r)
```

## Rose tree
**Intuition:** like a binary tree but with *unbounded* children stored as a list. Apply `f` to every child via `map f xs`.
```haskell
data Rose a = Leaf a | Branch [Rose a]

f :: Rose a -> r
f (Leaf x)    = base x
f (Branch xs) = combine (map f xs)
```

### Ready specialisations
```haskell
sizeR (Leaf _)    = 1
sizeR (Branch xs) = 1 + sum (map sizeR xs)

isNBranching _ (Leaf _)    = True
isNBranching n (Branch xs) = length xs == n && all (isNBranching n) xs

prune _ (Leaf x)    = Leaf x
prune n (Branch xs) = Branch (map (prune n) (take n xs))
```

## Bound-threaded (BST valid)
```haskell
isBST t = go (minBound) (maxBound) t
  where
    go _ _ Empty = True
    go lo hi (Fork x l r) =
      lo < x && x < hi && go lo x l && go x hi r
```

## ⚠ Pitfalls
- `isBST Empty` should be `True` (not False)
- Shallow check on Rose: must include `&& all rec xs`, not just `length xs == n`
- Constructor names vary across course (BT/Fork, Tree/EmptyTree/Node, Bin/Lf/Nd) — read `Types.hs`
- Don't swap l/r unless mirroring

## See also
[Tree BT](../templates/tree-bt.md) · [Tree Rose](../templates/tree-rose.md) · [Traversals](traversals.md) · [Tree Recursion](../archetypes/01-tree-recursion.md) · [BST](../archetypes/11-bst.md)
