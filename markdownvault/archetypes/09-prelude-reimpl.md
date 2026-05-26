# Archetype 09 — Reimplement Prelude with Explicit Recursion

[← INDEX](../INDEX.md) · [↑ Archetypes](README.md) · [NAVIGATION](../NAVIGATION.md)

⭐⭐⭐ W2/4 sheets, S2/3, githubinitial.hs (1-50).

## Concept
Write your own version of length/reverse/map/filter/elem/take/drop/zip/replicate without using the Prelude version.

**Intuition:** the point is to *show the recursion structure yourself*. Use `f [] = base; f (x:xs) = …` directly. Resist the urge to substitute in a library shortcut.

## Shape
[List Recursion](../patterns/list-recursion.md) cons recursion OR [Accumulator](../patterns/accumulator.md) for fast variants.

## Typical sigs
```haskell
myLength    :: [a] -> Int
myReverse   :: [a] -> [a]
myMap       :: (a -> b) -> [a] -> [b]
myFilter    :: (a -> Bool) -> [a] -> [a]
myElem      :: Eq a => a -> [a] -> Bool
myTake      :: Int -> [a] -> [a]
myDrop      :: Int -> [a] -> [a]
myZip       :: [a] -> [b] -> [(a, b)]
myReplicate :: Int -> a -> [a]
myConcat    :: [[a]] -> [a]
myAppend    :: [a] -> [a] -> [a]
```

## Solution
[List Cons](../templates/list-cons.md)

## ⚠ Traps
- Calling Prelude function inside (defeats exercise)
- Quadratic naive reverse (`reverse xs ++ [x]`) — use accumulator
- Off-by-one in take/drop count
- `n <= 0` not just `n == 0`
- Empty-list partial functions (head/last) — usually leave partial unless asked to Maybe-ify

## Combines with
[#10 Fold reformulation](10-fold.md) (alternate solution) · HOFs

## Seen
W2/W4 problem sheets, S2/3, githubinitial.hs (1-50 — all idiomatic)

## See also
[List Recursion](../patterns/list-recursion.md) · [List Cons](../templates/list-cons.md) · [List Accumulator](../templates/list-accumulator.md)
