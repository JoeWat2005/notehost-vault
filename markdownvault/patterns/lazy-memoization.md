# Lazy Memoisation

[← INDEX](../INDEX.md) · [↑ Patterns](README.md) · [NAVIGATION](../NAVIGATION.md)

> **Mental model:** Haskell's *laziness* means an "infinite" data structure (list, tree) is only computed *as needed*. If you store all answers in one shared infinite structure and recurse via lookups into that structure, each sub-problem is solved *exactly once* — the language gives you memoisation for free.

Exponential → linear via infinite data + sharing.

## fix combinator
**Idea:** `fix f` is the value `x` that satisfies `x = f x`. Useful for turning a "recursive step" `(rec -> input -> output)` into the actual recursive function, by tying the knot.
```haskell
fix :: (a -> a) -> a
fix f = let x = f x in x
```

### Recursion via fix
```haskell
factorial = fix (\rec n -> if n == 0 then 1 else n * rec (n-1))
fibstep   = \rec n -> if n < 2 then n else rec (n-1) + rec (n-2)
fib       = fix fibstep    -- still O(2^n), nothing memoised!
```

## memoList (linear lookup)
```haskell
store :: (Integer -> a) -> [a]
store f = [f i | i <- [0..]]

fetch :: [a] -> (Integer -> a)
fetch xs n = xs !! fromIntegral n

memoList :: (Integer -> a) -> (Integer -> a)
memoList = fetch . store

fibML = fix (memoList . fibstep)    -- now O(n)
```

## memoTree (log lookup via infinite BT)
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

memoBT = tfetch . tstore
fibBT  = fix (memoBT . fibstep)
```

## Infinite lists (corecursive)
```haskell
ones  = 1 : ones
fibs  = 0 : 1 : zipWith (+) fibs (tail fibs)
sieve (p:xs) = p : sieve [x | x <- xs, x `mod` p /= 0]
primes = sieve [2..]
```

## Lazy Nat (short-circuit comparison)
```haskell
data Nat = Zero | Succ Nat   deriving (Eq, Ord)

infty = Succ infty           -- terminates because cmp is lazy
lengthNat :: [a] -> Nat
lengthNat []     = Zero
lengthNat (_:xs) = Succ (lengthNat xs)

-- length' [0..] > 5  ← loops
-- lengthNat [0..] > 5  ← works
```

## Laziness intuition (when does it help / hurt?)

- **Helps**: an "infinite" list/tree only evaluates the cells you actually look up. `repeat 0`, `[1..]`, `fibs = 0 : 1 : zipWith (+) fibs (tail fibs)` all work without OOM because GHC computes lazily.
- **Helps**: `foldr (||) False` on a long list of `Bool`s can short-circuit at the first `True` because `||` is lazy in its second arg.
- **Hurts** (space leak): `foldl (+) 0 [1..1e6]` builds a thunk-chain because `+` doesn't force its args. Use `foldl'` (strict, in `Data.List`) or accumulator with care.
- **Memoisation** works because the *same* lazy thunk in the shared structure is forced once and reused.

## ⚠ Pitfalls
- Forgetting `memoBT` wrap on EVERY recursive call (each must hit table)
- Strict evaluation (`!`, BangPatterns) breaks laziness
- Test with large N to verify O(n)

## See also
[Memo](../archetypes/18-memo.md) · [Fib Memo](../examples/fib-memo.md) · [ADT Declarations](../templates/adt-declarations.md)
