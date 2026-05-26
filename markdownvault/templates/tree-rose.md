# Template — Rose tree recursion

[← INDEX](../INDEX.md) · [↑ Templates](README.md) · [NAVIGATION](../NAVIGATION.md)

> **What this pattern is doing:** like binary tree, but `Branch` holds an arbitrary number of children stored as `[Rose a]`. Recurse over each child with `map f xs`; combine the results however you need.

**When to use:** any function on a Rose / general tree where the number of children is variable.

```haskell
data Rose a = Leaf a | Branch [Rose a]

f :: Rose a -> ResultType
f (Leaf x)    = base x
f (Branch xs) = combine (map f xs)
```

## Worked specialisations

```haskell
sizeR, heightR :: Rose a -> Int
flattenR       :: Rose a -> [a]
mapRose        :: (a -> b) -> Rose a -> Rose b
isNBranching   :: Int -> Rose a -> Bool
prune          :: Int -> Rose a -> Rose a

sizeR (Leaf _)    = 1
sizeR (Branch xs) = 1 + sum (map sizeR xs)

heightR (Leaf _)    = 0
heightR (Branch xs) = 1 + maximum (0 : map heightR xs)   -- 0 guards Branch []

flattenR (Leaf x)    = [x]
flattenR (Branch xs) = concatMap flattenR xs

mapRose f (Leaf x)    = Leaf (f x)
mapRose f (Branch xs) = Branch (map (mapRose f) xs)

-- Mock Q1 a, b
isNBranching _ (Leaf _)    = True
isNBranching n (Branch xs) = length xs == n && all (isNBranching n) xs

prune _ (Leaf x)    = Leaf x
prune n (Branch xs) = Branch (map (prune n) (take n xs))
```

## ⚠ Pitfalls
- **shallow check**: `isNBranching n (Branch xs) = length xs == n` MISSES the recursion. Need `&& all (isNBranching n) xs`.
- `heightR` over `Branch []` — use `maximum (0 : map …)` not `maximum (map …)` which crashes on empty

## See also
[Tree Recursion](../patterns/tree-recursion.md) · [Tree BT](tree-bt.md) · [Mock Q1 Rose](../examples/mock-q1-rose.md)
