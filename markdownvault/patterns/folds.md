# Folds

[← INDEX](../INDEX.md) · [↑ Patterns](README.md) · [NAVIGATION](../NAVIGATION.md)

> **Mental model — `foldr`**: "replace every `(:)` in the list with `op`, and replace `[]` with `b`." So `foldr (+) 0 [1,2,3]` becomes `1 + (2 + (3 + 0))`. Any cons-recursion can be rewritten as `foldr`; the converse: any `foldr` *is* a structural recursion on a list.
>
> **Mental model — `foldl`**: "left-fold builds up the answer from the left, like a running total." Better for accumulator-style work but isn't lazy enough for infinite lists.

## foldr
```haskell
foldr :: (a -> b -> b) -> b -> [a] -> b
foldr op b []     = b
foldr op b (x:xs) = op x (foldr op b xs)
```

Equivalent recursion:
```haskell
f = foldr op b   ⇔   f [] = b ; f (x:xs) = op x (f xs)
```

## Ready specialisations (memorise)

The key insight: each one chooses a base (`b`) and a binary op (`op`) and the fold writes the recursion for you.
```haskell
sum     = foldr (+) 0                          -- :: Num a    => [a] -> a
product = foldr (*) 1                          -- :: Num a    => [a] -> a
length  = foldr (\_ n -> 1+n) 0                -- ::            [a] -> Int
map f   = foldr (\x xs -> f x : xs) []         -- :: (a -> b) -> [a] -> [b]
filter p = foldr (\x xs -> if p x then x:xs else xs) [] -- :: (a -> Bool) -> [a] -> [a]
concat  = foldr (++) []                        -- :: [[a]] -> [a]
or      = foldr (||) False                     -- :: [Bool] -> Bool
and     = foldr (&&) True                      -- :: [Bool] -> Bool
compose = foldr (.) id                         -- :: [a -> a] -> (a -> a)
```

## foldl (left, with accumulator)
```haskell
foldl :: (a -> b -> a) -> a -> [b] -> a
foldl op acc []     = acc
foldl op acc (x:xs) = foldl op (op acc x) xs
```

### Use foldl for
```haskell
reverse  = foldl (flip (:)) []
sum      = foldl (+) 0              -- also fine
fromList = foldr insertBST EmptyBT  -- BST builder
```

## foldr vs foldl decision
- **foldr** — folds from the *right*. Lazy in the second arg (so `foldr (&&) True (repeat False)` terminates). Works on infinite lists. Right-associates: `1 + (2 + (3 + 0))`.
- **foldl** — folds from the *left*. Strict accumulator (use `foldl'` for strict eval in Data.List). Left-associates: `((0 + 1) + 2) + 3`. Cannot short-circuit on infinite lists.

**Rule of thumb:** use `foldr` for list-rebuild and short-circuiting predicates (`and`, `or`, `any`, `all`). Use `foldl`/`foldl'` for numeric accumulation where you want O(1) space.

## foldr1 (non-empty)
```haskell
maximum = foldr1 max
minimum = foldr1 min
-- partial on []: use only when guaranteed non-empty
```

## ⚠ Pitfalls
- `acc` is the recursive result, NOT remaining input
- foldl forces whole list; foldr can short-circuit
- foldr1/foldl1 are partial on `[]`

## See also
[List Recursion](list-recursion.md) · [Accumulator](accumulator.md) · [Fold](../archetypes/10-fold.md) · [Monad](../typeclasses/monad.md)
