# Eq / Ord / Num

[← INDEX](../INDEX.md) · [↑ Typeclasses](README.md) · [NAVIGATION](../NAVIGATION.md)

> **Mental model:** these three typeclasses let your *own* types behave like built-in numbers / strings. `Eq` = comparability. `Ord` = orderability (requires `Eq`). `Num` = arithmetic (so integer literals like `5` work for your type). Most of the time you can `deriving (Eq, Ord, Show)`; write the instance by hand only when you need custom behaviour.

## Eq
```haskell
class Eq a where
  (==), (/=) :: a -> a -> Bool
```

- Derive via `deriving Eq`
- Required by `elem`, `lookup`, `nub`, `\\`
- One of (==) or (/=) determines the other

### Custom Eq
```haskell
data Color = Red | Green | Blue
instance Eq Color where
  Red   == Red   = True
  Green == Green = True
  Blue  == Blue  = True
  _     == _     = False
```

## Ord
```haskell
data Ordering = LT | EQ | GT
class Eq a => Ord a where
  compare :: a -> a -> Ordering
  (<), (<=), (>), (>=) :: a -> a -> Bool
  max, min :: a -> a -> a
```

- Derive via `deriving Ord` (lex order over ctor declaration order)
- `compare x y = LT | EQ | GT` is the canonical method
- Required by `sort`, `maximum`, `minimum`, `Map`

### Lex order on lists
```haskell
compareLists []     []     = EQ
compareLists []     _      = LT
compareLists _      []     = GT
compareLists (x:xs) (y:ys) = case compare x y of
  EQ -> compareLists xs ys
  o  -> o
```

## Num
```haskell
class Num a where
  (+), (-), (*) :: a -> a -> a
  negate, abs, signum :: a -> a
  fromInteger :: Integer -> a
```

- Integer literals desugar through `fromInteger`
- Custom `Num` allows numeric literals to work for your type
- Extended by `Fractional`, `Integral`

### Custom Num (Bool as ring, course example)
```haskell
instance Num Bool where
  x + y         = x /= y           -- XOR
  x * y         = x && y           -- AND
  negate x      = x
  abs x         = x
  signum x      = x
  fromInteger 0 = False
  fromInteger _ = True
```

### Peano Nat as Num (course problem W3)
```haskell
instance Num [()] where
  m + n     = m ++ n
  m * n     = concat (replicate (length m) n)
  fromInteger n = replicate (fromIntegral n) ()
```

## ⚠ Pitfalls
- `Ord` requires `Eq` (declare both)
- `deriving Ord` uses ctor declaration order — careful when defining `data Player = O | B | X` (lex order matters for minimax!)
- `Num Bool` is unusual but valid — type annotations help disambiguate

## See also
[Functor](functor.md) · [Custom Instances](custom-instances.md)
