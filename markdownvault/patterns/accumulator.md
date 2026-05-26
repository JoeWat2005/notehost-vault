# Accumulator Pattern (`go` helper)

[← INDEX](../INDEX.md) · [↑ Patterns](README.md) · [NAVIGATION](../NAVIGATION.md)

> **Mental model:** instead of building the answer *on the way back up* from the recursion, you carry it *on the way down*. The extra `acc` arg holds the partial answer so far. Equivalent to `foldl` written by hand — and converts O(n²) naive recursion to O(n).

## Canonical template
```haskell
f :: [a] -> r
f xs = go xs init
  where
    go []     acc = acc
    go (x:xs) acc = go xs (step x acc)
```
`init` is the starting accumulator. `step x acc` produces the next accumulator from the current element and the accumulator so far.

## Examples

### Fast reverse
**Why it works:** the naive `reverse (x:xs) = reverse xs ++ [x]` is O(n²) because `(++)` walks its left arg each call. Here we cons onto `acc` — O(1) — and end up with the reversed list automatically.
```haskell
fastReverse :: [a] -> [a]
fastReverse xs = go xs []
  where
    go []     acc = acc
    go (x:xs) acc = go xs (x : acc)
```

### Fast Fibonacci
**Why it works:** carry the last *two* values so each step only adds, instead of two recursive calls (exponential blow-up).
```haskell
fastFib :: Int -> Int
fastFib n = go n (0, 1)
  where
    go 0 (a, _) = a
    go n (a, b) = go (n-1) (b, a+b)
```

### Cycle detection (permutation)
**Why it works:** the accumulator carries everything visited so far. Stop when we'd revisit.
```haskell
cycleOf :: Int -> [Int] -> [Int]
cycleOf i p = go i []
  where
    go x seen
      | x `elem` seen = []
      | otherwise     = x : go (p !! x) (x : seen)
```

## When to use
- explicit "make it efficient" / O(n)
- need to carry running state through list
- multi-value accumulator (pair, list-of-seen)

## Variants
- Reversed-accumulator (use `reverse acc` at end) for order preservation
- Tuple-accumulator `(result, state)`
- Equivalent to `foldl op init xs` — `go` is the explicit form

## ⚠ Pitfalls
- If you need short-circuit, don't use accumulator (use foldr / explicit recursion)
- Forgetting to reverse final accumulator when order matters

## See also
[List Recursion](list-recursion.md) · [Folds](folds.md) · [List Accumulator](../templates/list-accumulator.md)
