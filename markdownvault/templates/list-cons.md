# Template — List cons recursion

[← INDEX](../INDEX.md) · [↑ Templates](README.md) · [NAVIGATION](../NAVIGATION.md)

> **What this pattern is doing:** peel one element off the front of the list, recurse on the rest, combine. The base case (empty list) gives a "default" answer. Most list functions are this pattern with different `base` and `combine`.

```haskell
f :: [a] -> ResultType
f []     = base
f (x:xs) = combine x (f xs)
```

## Worked specialisations

Each one picks a different `base` and `combine`:
```haskell
myLength :: [a] -> Int
myLength []     = 0
myLength (_:xs) = 1 + myLength xs

mySum :: Num a => [a] -> a
mySum []     = 0
mySum (x:xs) = x + mySum xs

myMap :: (a -> b) -> [a] -> [b]
myMap _ []     = []
myMap f (x:xs) = f x : myMap f xs

myFilter :: (a -> Bool) -> [a] -> [a]
myFilter _ []     = []
myFilter p (x:xs)
  | p x       = x : myFilter p xs
  | otherwise = myFilter p xs

myElem :: Eq a => a -> [a] -> Bool
myElem _ []     = False
myElem y (x:xs) = y == x || myElem y xs

myAppend :: [a] -> [a] -> [a]
myAppend []     ys = ys
myAppend (x:xs) ys = x : myAppend xs ys
```

## Variations
- Two lists: 3 base cases + parallel recursion
- Count-driven: extra `n` arg with `n <= 0` base
- Look-ahead: `(x:y:xs)` pattern with 3 cases
- Conditional cons: guard before `x : f xs`

## See also
[List Recursion](../patterns/list-recursion.md) · [List Accumulator](list-accumulator.md)
