# Functor

[← INDEX](../INDEX.md) · [↑ Typeclasses](README.md) · [NAVIGATION](../NAVIGATION.md)

> **Mental model:** *Functor preserves structure.* `fmap` takes a pure `(a -> b)` and slips it inside the container, transforming every `a` to a `b` while leaving the shape (positions, ordering, nesting) untouched.

"Lift pure fn into a context, preserve shape."

## Class
```haskell
class Functor f where
  fmap :: (a -> b) -> f a -> f b

(<$>) :: Functor f => (a -> b) -> f a -> f b   -- infix fmap
```

## Laws
- `fmap id = id`
- `fmap (g . f) = fmap g . fmap f`

## Standard instances

### Maybe
```haskell
instance Functor Maybe where
  fmap _ Nothing  = Nothing
  fmap f (Just x) = Just (f x)
```

### List
```haskell
instance Functor [] where
  fmap = map
```

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

### Reader (function-as-functor)
```haskell
instance Functor ((->) r) where
  fmap = (.)
```

### Functor sum (compound)
```haskell
data FSum f g a = FLeft (f a) | FRight (g a)

instance (Functor f, Functor g) => Functor (FSum f g) where
  fmap h (FLeft  fa) = FLeft  (fmap h fa)
  fmap h (FRight ga) = FRight (fmap h ga)
```

## Rule for custom Functor
Walk every constructor; apply `f` to a-typed slots only; `fmap` recursively on `f a`-shaped slots; preserve shape.

## ⚠ Pitfalls
- fmap CHANGING shape (allowed to transform values only)
- forgetting class constraint `(Functor f, Functor g) =>`
- using `f` (parameter) and `f` (typevar) — alpha-rename

## See also
[Applicative](applicative.md) · [Monad](monad.md) · [Functor Instance](../templates/functor-instance.md) · [Functor Instance](../archetypes/06-functor-instance.md)
