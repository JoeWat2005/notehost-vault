# Template — Accumulator helper `go`

[← INDEX](../INDEX.md) · [↑ Templates](README.md) · [NAVIGATION](../NAVIGATION.md)

> **What this pattern is doing:** instead of building the answer on the way *back up* (slow when concatenating), carry the running total in an extra arg called `acc`. The recursion terminates by returning `acc`. Same idea as `foldl`, written by hand.

**When to use:** "make it efficient" / O(n), need to thread state, naive recursion is doing `(++ [x])` or `reverse`.

```haskell
f :: [a] -> ResultType
f xs = go xs init
  where
    go []     acc = acc
    go (x:xs) acc = go xs (step x acc)
```

## Worked specialisations

```haskell
fastReverse :: [a] -> [a]
fastReverse xs = go xs []
  where
    go []     acc = acc
    go (x:xs) acc = go xs (x : acc)

fastFib :: Int -> Int
fastFib n = go n (0, 1)
  where
    go 0 (a, _) = a
    go n (a, b) = go (n-1) (b, a+b)

fastLength :: [a] -> Int
fastLength xs = go xs 0
  where
    go []     n = n
    go (_:xs) n = go xs (n+1)
```

## With pair-accumulator
```haskell
partition' p xs = go xs ([], [])
  where
    go []     (ts, fs) = (ts, fs)
    go (x:xs) (ts, fs)
      | p x       = go xs (x:ts, fs)
      | otherwise = go xs (ts, x:fs)
```

## Equivalence with foldl
```haskell
f xs = go xs init           ≡   foldl (flip step) init xs
  where go [] acc      = acc
        go (x:xs) acc  = go xs (step x acc)
```

## See also
[Accumulator](../patterns/accumulator.md) · [Folds](../patterns/folds.md) · [List Cons](list-cons.md)
