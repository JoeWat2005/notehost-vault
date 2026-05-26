# Archetype 11 — BST Operations

[← INDEX](../INDEX.md) · [↑ Archetypes](README.md) · [NAVIGATION](../NAVIGATION.md)

⭐⭐⭐ W6, S9 #81-85.

## Concept
Maintain `left < x < right` invariant across tree operations.

**Intuition:** at each `Fork`, compare with `Ord` and recurse only down ONE side. Insertions/deletions/membership all use the same 3-way split. To *check* BSTness, thread an `(lo, hi)` window of bounds top-down — every node must lie inside its inherited window.

## Shape
- insert: 3-way Ord guard (x<v / x>v / x==v)
- delete: 4-case (Empty/Empty, l/Empty, Empty/r, both → rightmost-of-left)
- valid: bound-threaded OR `ordered . inOrder`

## Typical sigs
```haskell
isBST     :: Ord a => BT a -> Bool
insertBST :: Ord a => a -> BT a -> BT a
deleteBST :: Ord a => a -> BT a -> BT a
member    :: Ord a => a -> BT a -> Bool
fromList  :: Ord a => [a] -> BT a
```

## Solution

### Bound-threaded isBST
```haskell
isBST :: Ord a => BT a -> Bool
isBST = go (Nothing, Nothing)
  where
    go _ Empty = True
    go (lo, hi) (Fork x l r) =
      maybe True (< x) lo
        && maybe True (> x) hi
        && go (lo, Just x) l
        && go (Just x, hi) r
```

### Insert
```haskell
insertBST x Empty = Fork x Empty Empty
insertBST x t@(Fork v l r)
  | x < v  = Fork v (insertBST x l) r
  | x > v  = Fork v l (insertBST x r)
  | otherwise = t                          -- duplicate: idempotent
```

### Delete (4-case)
```haskell
deleteBST _ Empty = Empty
deleteBST x (Fork v l r)
  | x < v = Fork v (deleteBST x l) r
  | x > v = Fork v l (deleteBST x r)
  | otherwise = case (l, r) of
      (Empty, Empty) -> Empty
      (l    , Empty) -> l
      (Empty, r    ) -> r
      (l    , r    ) -> let m = largestOf l
                        in Fork m (withoutLargest l) r

largestOf (Fork x _ Empty) = x
largestOf (Fork _ _ r)     = largestOf r

withoutLargest (Fork _ l Empty) = l
withoutLargest (Fork x l r)     = Fork x l (withoutLargest r)
```

## ⚠ Traps
- **isBST Empty = True** (NOT False — student bug)
- Local-only check (forgetting to thread bounds) → O(n²) and WRONG
- Delete consistency: rightmost-of-left OR leftmost-of-right (pick one)
- Insert duplicate handling — usually idempotent (== branch returns t)

## Combines with
[#01](01-tree-recursion.md) · [Ord](../typeclasses/eq-ord-num.md) · Maybe

## Seen
W6 problem sheet, S9 #81-85, hoogle.hs

## See also
[Tree BT](../templates/tree-bt.md) · [Tree Recursion](../patterns/tree-recursion.md)
