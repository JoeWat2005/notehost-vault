# Template — Functor instance

[← INDEX](../INDEX.md) · [↑ Templates](README.md) · [NAVIGATION](../NAVIGATION.md)

> **What this pattern is doing:** for each constructor of your ADT, apply `f` to each `a`-shaped slot and `fmap f` to each subtree-shaped slot. The constructor stays the same, only the contents change. *Functor preserves structure.*

```haskell
instance Functor T where
  fmap _ EmptyCtor     = EmptyCtor
  fmap f (Ctor1 x)     = Ctor1 (f x)                  -- f to a-typed slot
  fmap f (Ctor2 x l r) = Ctor2 (f x) (fmap f l) (fmap f r)  -- recurse on f-shaped slots
```

## Standard library shapes

### Maybe
```haskell
instance Functor Maybe where
  fmap _ Nothing  = Nothing
  fmap f (Just x) = Just (f x)
```

### List (= map)
```haskell
instance Functor [] where
  fmap = map
```

### Either (right-biased)
```haskell
instance Functor (Either e) where
  fmap _ (Left e)  = Left e
  fmap f (Right x) = Right (f x)
```

## Tree shapes

### Binary tree
```haskell
instance Functor BT where
  fmap _ Empty        = Empty
  fmap f (Fork x l r) = Fork (f x) (fmap f l) (fmap f r)
```

### Rose tree
```haskell
instance Functor Rose where
  fmap f (Leaf x)    = Leaf (f x)
  fmap f (Branch xs) = Branch (map (fmap f) xs)
```

### Custom: Bin (ewan31-40.hs)
```haskell
data Bin a = Lf | Nd a (Bin a) (Bin a)

instance Functor Bin where
  fmap _ Lf         = Lf
  fmap f (Nd x l r) = Nd (f x) (fmap f l) (fmap f r)
```

## Function-as-Functor
```haskell
instance Functor ((->) r) where
  fmap = (.)
```

## Functor sum (composed)
```haskell
data FSum f g a = FLeft (f a) | FRight (g a)

instance (Functor f, Functor g) => Functor (FSum f g) where
  fmap h (FLeft fa)  = FLeft  (fmap h fa)
  fmap h (FRight ga) = FRight (fmap h ga)
```

## Rule
Walk every ctor. Apply `f` to a-typed slots. Use `fmap` (recursively) on slots wrapping a.

## See also
[Functor](../typeclasses/functor.md) · [Monad Instance](monad-instance.md) · [Functor Instance](../archetypes/06-functor-instance.md)
