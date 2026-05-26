# List Comprehensions

[← INDEX](INDEX.md) · [NAVIGATION](NAVIGATION.md)

⭐⭐⭐ Tier-1 exam topic. Often paired with HOFs.

> **Mental model:** a list comprehension is a *nested loop*: each `<-` is a `for` loop, each guard is an `if`, and the expression at the start is what gets emitted on each pass. Leftmost generator = outermost loop.

## Syntax
```
[expr | gen, gen, …, guard, guard, …]
```
- **generator**: `x <- xs` (x ranges over xs)
- **guard**: any Bool expression filtering
- **pattern-bind generator**: `(x, _) <- pairs` (also acts as a filter — non-matching pairs are dropped)

## Equivalence to do-on-list
```haskell
[x + y | x <- xs, y <- ys, x /= y]
-- equivalent to:
do x <- xs ; y <- ys ; if x /= y then return (x + y) else []
```

## ⭐ Canonical exercises

### Pythagorean triples
```haskell
pyths :: Int -> [(Int, Int, Int)]
pyths n = [(a, b, c) | a <- [1..n]
                     , b <- [1..n]
                     , c <- [1..n]
                     , a^2 + b^2 == c^2]
```

### Factors / primes / perfect numbers
```haskell
factors :: Int -> [Int]
factors n = [x | x <- [1..n], n `mod` x == 0]

isPrime :: Int -> Bool
isPrime n = factors n == [1, n]

primesUpTo :: Int -> [Int]
primesUpTo n = [x | x <- [2..n], isPrime x]

perfects :: Int -> [Int]
perfects n = [x | x <- [1..n], sum (init (factors x)) == x]
```

### Indexed positions (zip with index)
```haskell
positions :: Eq a => a -> [a] -> [Int]
positions x xs = [i | (y, i) <- zip xs [0..], x == y]
```

### Consecutive pairs
```haskell
pairs :: [a] -> [(a, a)]
pairs xs = zip xs (tail xs)
-- or:
pairs xs = [(x, y) | (x, y) <- zip xs (tail xs)]
```

### Scalar / dot product
```haskell
scalar :: Num a => [a] -> [a] -> a
scalar xs ys = sum [x * y | (x, y) <- zip xs ys]
```

### Cartesian product
```haskell
cartesian :: [a] -> [b] -> [(a, b)]
cartesian xs ys = [(x, y) | x <- xs, y <- ys]
```

### Matrix multiplication (triple-nested)
```haskell
matMul :: Int -> Int -> Int -> [[Int]] -> [[Int]] -> [[Int]]
matMul p q r a b =
  [[sum [a !! i !! k * b !! k !! j | k <- [0..q-1]]
   | j <- [0..r-1]]
  | i <- [0..p-1]]
```

### sortedness (via guard over pairs)
```haskell
sorted :: Ord a => [a] -> Bool
sorted xs = and [x <= y | (x, y) <- zip xs (tail xs)]
```

### concat via comprehension
```haskell
myConcat :: [[a]] -> [a]
myConcat xss = [x | xs <- xss, x <- xs]
```

### filter + map fused
```haskell
[f x | x <- xs, p x]
-- equivalent to: map f (filter p xs)
```

## Order of generators

**Leftmost generator is OUTER loop**:
```haskell
[(x, y) | x <- [1..3], y <- [1..2]]
-- [(1,1),(1,2),(2,1),(2,2),(3,1),(3,2)]
```

## Dependent generators
Later generators may use earlier-bound variables:
```haskell
[(x, y) | x <- [1..3], y <- [x..3]]
-- [(1,1),(1,2),(1,3),(2,2),(2,3),(3,3)]
```

## Pattern-bind generators
```haskell
firsts :: [(a, b)] -> [a]
firsts pairs = [x | (x, _) <- pairs]
```

## Caesar cipher (full pipeline)
```haskell
shift :: Int -> Char -> Char
shift n c
  | isLower c = chr (ord 'a' + (ord c - ord 'a' + n) `mod` 26)
  | otherwise = c

encode :: Int -> String -> String
encode n s = [shift n c | c <- s]
```

## Frequency analysis
```haskell
freqs :: String -> [Float]
freqs s = [percent (count c lowered) total | c <- ['a'..'z']]
  where lowered = [toLower c | c <- s, isAlpha c]
        total   = length lowered
```

## ⚠ Pitfalls
- comprehension semantics = nested loops, leftmost outer
- `[f x | x <- xs, p x]` ≠ `[f x | x <- xs] ++ [x | x <- xs, p x]`
- when ranges overlap (`y <- [x..]`), order matters
- empty input → empty result (no error)

## See also
[Higher Order Functions](higher-order-functions.md) · [List Recursion](patterns/list-recursion.md) · [List Monad](monads/list-monad.md) · [Examples Caesar Cipher](examples/caesar-cipher.md)
