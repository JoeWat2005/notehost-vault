# Fibonacci via Lazy Memoisation

[← INDEX](../INDEX.md) · [↑ Examples](README.md) · [NAVIGATION](../NAVIGATION.md)

Turn O(2^n) naive fib into O(n) via infinite memo-tree.

> **Technique:** route every recursive call through a shared lazy table. Haskell's laziness means each subproblem is computed only once, automatically.

## Naive (exponential)
```haskell
fib :: Integer -> Integer
fib n
  | n < 2     = n
  | otherwise = fib (n-1) + fib (n-2)
```

## Step refactor (recursive call as arg)
```haskell
fibstep :: (Integer -> Integer) -> Integer -> Integer
fibstep rec n
  | n < 2     = n
  | otherwise = rec (n-1) + rec (n-2)
```

## fix combinator (still exponential — no memo)
```haskell
fix :: (a -> a) -> a
fix f = let x = f x in x

fib1 :: Integer -> Integer
fib1 = fix fibstep            -- O(2^n)
```

## memoList (linear via infinite list)
```haskell
store :: (Integer -> a) -> [a]
store f = [f i | i <- [0..]]

fetch :: [a] -> Integer -> a
fetch xs n = xs !! fromIntegral n

memoList :: (Integer -> a) -> (Integer -> a)
memoList = fetch . store

fibML :: Integer -> Integer
fibML = fix (memoList . fibstep)    -- O(n) with O(n) lookups
```

## memoTree (log via infinite BT)
```haskell
data BT a = Empty | Fork a (BT a) (BT a)

tstore :: (Integer -> a) -> BT a
tstore f = Fork (f 0)
  (tstore (\n -> f (1 + 2*n)))
  (tstore (\n -> f (2 + 2*n)))

tfetch :: BT a -> Integer -> a
tfetch (Fork a _ _) 0 = a
tfetch (Fork _ l r) n
  | odd n     = tfetch l ((n-1) `div` 2)
  | otherwise = tfetch r ((n-2) `div` 2)

memoBT :: (Integer -> a) -> (Integer -> a)
memoBT = tfetch . tstore

fibBT :: Integer -> Integer
fibBT = fix (memoBT . fibstep)
```

## Verify the speedup
```haskell
-- ghci> :set +s
-- ghci> fib 30      -- seconds
-- ghci> fibBT 30    -- instant
-- ghci> fibBT 1000  -- still fast
```

## Pattern
[#18](../archetypes/18-memo.md) — lazy memoisation via infinite data.

## ⚠ Traps
- Without `fix`-wrap, `fibstep fibstep` doesn't even type-check
- Strict eval (`!`, BangPatterns) breaks laziness
- Forgetting to memoise on EVERY recursive call

## See also
[Lazy Memoization](../patterns/lazy-memoization.md) · [Memo](../archetypes/18-memo.md)
