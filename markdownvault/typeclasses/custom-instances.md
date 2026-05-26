# Custom Typeclass Instances

[← INDEX](../INDEX.md) · [↑ Typeclasses](README.md) · [NAVIGATION](../NAVIGATION.md)

> **Mental model:** a typeclass is a *contract* — "any type that promises this method gets to use this set of functions". An `instance` is the promise: "here's how my type implements the contract." Constraints like `Eq a => Eq (T a)` say "if `a` is comparable, so is `T a` (and here's how)."

## Declaration syntax
```haskell
instance ClassName TypeName where
  method1 = …
  method2 = …
```

## With constraints
```haskell
instance Eq a => Eq (MyList a) where
  Nil           == Nil           = True
  (Cons x xs)   == (Cons y ys)   = x == y && xs == ys
  _             == _             = False

instance (Functor f, Functor g) => Functor (FSum f g) where
  fmap h (FLeft  fa) = FLeft  (fmap h fa)
  fmap h (FRight ga) = FRight (fmap h ga)
```

## Custom class declaration
```haskell
class MyEq a where
  (===) :: a -> a -> Bool

instance MyEq Bool where
  True  === True  = True
  False === False = True
  _     === _     = False

instance (MyEq a, MyEq b) => MyEq (a, b) where
  (x, y) === (u, v) = x === u && y === v

instance MyEq a => MyEq [a] where
  []     === []     = True
  (x:xs) === (y:ys) = x === y && xs === ys
  _      === _      = False
```

## Function-domain equality (Bool only)
```haskell
instance MyEq a => MyEq (Bool -> a) where
  f === g = f True === g True && f False === g False
```

## Default methods (MINIMAL)
```haskell
class YourEq a where
  (====), (=//=) :: a -> a -> Bool
  x ==== y = not (x =//= y)
  x =//= y = not (x ==== y)
  {-# MINIMAL (====) | (=//=) #-}
```

## Pragmas to know
- `{-# LANGUAGE FlexibleInstances #-}` — for `instance MyEq (Bool -> a)`
- `{-# LANGUAGE Safe #-}` — required by assignments
- `deriving (Show, Eq, Ord, Read, Enum, Bounded)` — auto-derive

## ⚠ Pitfalls
- Only `data` / `newtype` can be class instances
- One instance per type per class (overlap forbidden without pragma)
- Constraint must be propagated: `instance Eq a => Eq (T a)` not just `instance Eq (T a)`

## See also
[Functor](functor.md) · [Eq Ord Num](eq-ord-num.md) · [Functor Instance](../templates/functor-instance.md) · [Monad Instance](../templates/monad-instance.md)
