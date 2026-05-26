# List Recursion

[← INDEX](../INDEX.md) · [↑ Patterns](README.md) · [NAVIGATION](../NAVIGATION.md)

> **Mental model:** lists in Haskell are *recursive ADTs* with two constructors — `[]` (the empty list) and `(x:xs)` (cons: an element in front of a smaller list). So a function on a list naturally has two equations: one for `[]`, one for `(x:xs)`. The recursive call always operates on the *tail* — that's why it terminates.

Most fundamental pattern. Pattern-match `[]` and `(x:xs)`.

## Canonical schema (cons recursion)
```haskell
f :: [a] -> r
f []     = base               -- base case: empty list
f (x:xs) = combine x (f xs)   -- recursive case: head x, recurse on xs
```

## Common shapes

### Aggregate to scalar
**Idea:** the base case is the identity element of the operation (0 for +, 1 for *, False for ||).
```haskell
myLength :: [a] -> Int
myLength []     = 0
myLength (_:xs) = 1 + myLength xs

mySum :: Num a => [a] -> a
mySum []     = 0
mySum (x:xs) = x + mySum xs
```

### List rebuild (transform)
**Idea:** the base case is `[]`, and you rebuild the result by `cons`-ing transformed elements onto the recursive result.
```haskell
doubleList :: Num a => [a] -> [a]
doubleList []     = []
doubleList (x:xs) = (x*2) : doubleList xs
```

### Conditional cons (filter-like)
**Idea:** decide per-element whether to cons or skip.
```haskell
removeOdd :: Integral a => [a] -> [a]
removeOdd []     = []
removeOdd (x:xs)
  | even x    = x : removeOdd xs
  | otherwise = removeOdd xs
```

### Count-decrement
**Idea:** add an `Int` arg as a counter; stop when it hits 0 (and always handle `n <= 0`, not just `n == 0`).
```haskell
myTake :: Int -> [a] -> [a]
myTake n _  | n <= 0 = []
myTake _ []          = []
myTake n (x:xs)      = x : myTake (n-1) xs
```

### Two-list parallel
**Idea:** recurse on both lists together; one base case per "which list ran out first".
```haskell
myZip :: [a] -> [b] -> [(a, b)]
myZip []     _      = []
myZip _      []     = []
myZip (x:xs) (y:ys) = (x,y) : myZip xs ys
```

### Look-ahead (x:y:xs)
**Idea:** when you need to act on *adjacent* elements (alternations, sliding windows). Three base cases: `[]`, single `[x]`, pair `(x:y:xs)`.
```haskell
altMap :: (a -> b) -> (a -> b) -> [a] -> [b]
altMap _ _ []         = []
altMap f _ [x]        = [f x]
altMap f g (x:y:xs)   = f x : g y : altMap f g xs
```

## ⚠ Pitfalls
- empty-list base case for partial functions (`head [] = ⊥`)
- O(n²) reverse via `(++ [x])` — use [Accumulator](accumulator.md) instead
- forgetting `n <= 0` for take/drop

## See also
[Folds](folds.md) · [Accumulator](accumulator.md) · [List Cons](../templates/list-cons.md) · [Prelude Reimpl](../archetypes/09-prelude-reimpl.md)
