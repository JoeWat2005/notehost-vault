# Archetype 10 — Fold Reformulation

[← INDEX](../INDEX.md) · [↑ Archetypes](README.md) · [NAVIGATION](../NAVIGATION.md)

⭐⭐⭐ W4, S5 #41-47.

## Concept
Re-express a recursive list function using ONLY `foldr` or `foldl`.

**Intuition:** every `f [] = base ; f (x:xs) = step x (f xs)` is literally `foldr step base`. Find your `step` and `base`, then plug in.

## Shape
```haskell
f = foldr step base
-- equivalent: f [] = base ; f (x:xs) = step x (f xs)
```

## Typical sigs
```haskell
mapWithFoldr    :: (a -> b) -> [a] -> [b]
filterWithFoldr :: (a -> Bool) -> [a] -> [a]
lengthWithFoldr :: [a] -> Int
sumWithFoldr    :: Num a => [a] -> a
reverseWithFoldl :: [a] -> [a]
```

## Solution
[Folds](../patterns/folds.md) · [List Accumulator](../templates/list-accumulator.md)

```haskell
sumWithFoldr     = foldr (+) 0
lengthWithFoldr  = foldr (\_ n -> n + 1) 0
mapWithFoldr f   = foldr (\x xs -> f x : xs) []
filterWithFoldr p = foldr (\x xs -> if p x then x:xs else xs) []
reverseWithFoldl = foldl (flip (:)) []
concatWithFoldr  = foldr (++) []
composeWithFoldr = foldr (.) id
```

## ⚠ Traps
- foldl forces whole list (can't short-circuit on infinite)
- Use foldr if infinite-input or short-circuit needed
- `acc` is the recursive call's RESULT, not the remaining input
- reverse via foldr is O(n²) (`(++ [x])`); use foldl for O(n)
- Point-free style trips students: `length = foldr (\_ -> (+1)) 0` is correct

## Combines with
[#09](09-prelude-reimpl.md) · HOFs · list comp

## Seen
W4 problem sheet, S5 #41-47

## See also
[Folds](../patterns/folds.md) · [Prelude Reimpl](09-prelude-reimpl.md)
