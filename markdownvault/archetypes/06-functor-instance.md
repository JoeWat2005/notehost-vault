# Archetype 06 — Functor / Applicative / Monad Instance

[← INDEX](../INDEX.md) · [↑ Archetypes](README.md) · [NAVIGATION](../NAVIGATION.md)

⭐⭐⭐⭐ S13 #121-126, A3 Free.

## Concept
Declare typeclass instance(s) for a custom type.

**Intuition:** `fmap` preserves the *shape* (constructor + arity) while replacing `a`-typed values; `pure` wraps; `<*>` sequences; `>>=` chains. For tree-shaped types, recurse with `fmap` on subtree slots.

## Shape
```haskell
instance Functor T where fmap f Ctor = ...
instance Applicative T where pure = ... ; (<*>) = ...
instance Monad T where return = ... ; (>>=) = ...
```

## Typical sigs
```haskell
fmap   :: (a -> b) -> T a -> T b
pure   :: a -> T a
(<*>)  :: T (a -> b) -> T a -> T b
(>>=)  :: T a -> (a -> T b) -> T b
```

## Solution
[Functor Instance](../templates/functor-instance.md) · [Monad Instance](../templates/monad-instance.md)

## ⚠ Traps
- fmap changing SHAPE (only allowed to transform values)
- Confusing `m a` (parametric) with concrete type in instance head
- `>>= ` for List using only first element → must `concatMap`
- Must declare ALL THREE (Functor, Applicative, Monad)
- Compound: `instance (Functor f, Functor g) => Functor (FSum f g)` — propagate constraints
- For `instance Monad (Either e)`, `e` is FIXED as outer parameter

## Combines with
[#01 Tree (Functor BT/Rose)](01-tree-recursion.md) · A3 Free monad · [Map mapM Traverse](../patterns/map-mapM-traverse.md)

## Seen
S7 #69-70 (custom Eq, Functor Maybe), S13 #121-126 (full chain), A3 (Free given), ewan31-40.hs (Functor Bin, Functor (FSum f g))

## See also
[Functor](../typeclasses/functor.md) · [Monad](../typeclasses/monad.md) · [Functor Instance](../templates/functor-instance.md)
