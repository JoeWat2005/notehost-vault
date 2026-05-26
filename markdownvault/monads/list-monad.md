# List Monad

[← INDEX](../INDEX.md) · [↑ Monads](README.md) · [NAVIGATION](../NAVIGATION.md)

> **Mental model:** the list monad is "non-determinism". Each `<- xs` is "for each possible value of `x` in `xs`, do the rest". The result is the *concatenation of every branch's results*. List comprehensions are sugar for this.

Non-determinism / "all possible" / search.

## Instance
```haskell
instance Monad [] where
  return x = [x]
  xs >>= f = concat (map f xs)
  -- equivalent: [y | x <- xs, y <- f x]
```

## Equivalence to list comprehensions
```haskell
do x <- xs                       [(x, y) | x <- xs, y <- ys]
   y <- ys              ≡
   return (x, y)
```

## Patterns

### Cartesian product
```haskell
pairs xs ys = do
  x <- xs
  y <- ys
  return (x, y)
```

### Knight moves (S11 #105)
```haskell
moves :: (Int, Int) -> [(Int, Int)]
moves (x, y) = do
  (dx, dy) <- [(1,2),(2,1),(-1,2),(-2,1),(1,-2),(2,-1),(-1,-2),(-2,-1)]
  let (nx, ny) = (x + dx, y + dy)
  if 0 <= nx && nx < 8 && 0 <= ny && ny < 8
    then return (nx, ny)
    else []
```

### Filtering via guard
```haskell
import Control.Monad (guard)

triples n = do
  a <- [1..n]
  b <- [a..n]
  c <- [b..n]
  guard (a*a + b*b == c*c)
  return (a, b, c)
```

## ⚠ Pitfalls
- `xs >>= f` is `concatMap f xs`, NOT `map f xs`
- Empty list = failure; `do _ <- []; …` produces `[]`
- `guard False = []`, `guard True = [()]`

## See also
[Monad](../typeclasses/monad.md) · [List Recursion](../patterns/list-recursion.md)
