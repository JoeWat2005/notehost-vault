# Archetype 18 — Lazy Memoisation via Infinite Data

[← INDEX](../INDEX.md) · [↑ Archetypes](README.md) · [NAVIGATION](../NAVIGATION.md)

⭐⭐ W8, S14 #136-137.

## Concept
Convert exponential recursion into O(1) (amortised) repeated-lookup via infinite list/tree.

**Intuition:** if every recursive call goes through one shared lazy table, repeated subproblems are computed once. Haskell's laziness means an "infinite tree" is only ever evaluated where you ask, so you pay only for what you use.

## Shape
```haskell
fastF = fix (memoT . step)
-- where step rec = recursive fn refactored to take its own recursive call as arg
```

## Typical sigs
```haskell
fix      :: (a -> a) -> a
memoList :: (Integer -> a) -> (Integer -> a)
tstore   :: (Integer -> a) -> BT a
tfetch   :: BT a -> Integer -> a
fibBT    :: Integer -> Integer
```

## Solution
[Lazy Memoization](../patterns/lazy-memoization.md) · [Fib Memo](../examples/fib-memo.md)

```haskell
fix :: (a -> a) -> a
fix f = let x = f x in x

fibstep :: (Integer -> Integer) -> Integer -> Integer
fibstep rec n
  | n < 2     = n
  | otherwise = rec (n-1) + rec (n-2)

-- Infinite-tree memoisation:
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

## ⚠ Traps
- Forgetting to memoise on EVERY recursive call (each must hit table)
- Strict eval (`seq`, BangPatterns) breaks laziness
- Test with large N to verify O(n), not still O(2^n)
- Confusing fix (recursion-via-fixpoint) with fix (one-shot evaluation)

## Combines with
[laziness](../patterns/lazy-memoization.md) · [BT](../templates/tree-bt.md) · fix combinator

## Seen
W8 (whole lecture), S14 #136-137. Never appeared in Mock — probably not on exam.

## See also
[Lazy Memoization](../patterns/lazy-memoization.md) · [Fib Memo](../examples/fib-memo.md)
