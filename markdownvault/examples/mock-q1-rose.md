# Mock Q1 — Rose tree (isNBranching, prune)

[← INDEX](../INDEX.md) · [↑ Examples](README.md) · [NAVIGATION](../NAVIGATION.md)

10 marks: structural recursion on Rose tree.

> **Technique:** Rose tree recursion. The trap is checking a property *locally* without also recursing into children — every node must satisfy it, not just the root.

## Spec
```haskell
data Rose a = Leaf a | Branch [Rose a]

isNBranching :: Int -> Rose a -> Bool
prune        :: Int -> Rose a -> Rose a
```

- `isNBranching n t` — every Branch has exactly n children, recursively
- `prune n t` — keep only first n children of each branch

## Canonical solution
```haskell
isNBranching :: Int -> Rose a -> Bool
isNBranching _ (Leaf _)    = True
isNBranching n (Branch xs) = length xs == n && all (isNBranching n) xs

prune :: Int -> Rose a -> Rose a
prune _ (Leaf x)    = Leaf x
prune n (Branch xs) = Branch (map (prune n) (take n xs))
```

## Pattern
[#01](../archetypes/01-tree-recursion.md) — structural recursion on Rose.

## ⚠ Bug to avoid (`ewan20.hs` had this)
```haskell
-- WRONG: shallow check, doesn't recurse
isNBranching n (Branch xs) = length xs == n
```
Must include `&& all (isNBranching n) xs`.

## Trace
- `isNBranching 2 (Branch [Leaf 1, Leaf 2])` = True (2 children, leaves trivially OK)
- `isNBranching 2 (Branch [Leaf 1, Branch [Leaf 2]])` = False (inner branch has 1 child)
- `prune 1 (Branch [Branch [Leaf 'a', Leaf 'b'], Leaf 'c'])` = `Branch [Branch [Leaf 'a']]`

## See also
[Tree Rose](../templates/tree-rose.md) · [Tree Recursion](../patterns/tree-recursion.md)
