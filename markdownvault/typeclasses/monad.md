# Monad

[← INDEX](../INDEX.md) · [↑ Typeclasses](README.md) · [NAVIGATION](../NAVIGATION.md)

> **Mental model:** Applicative sequences *independent* effects. Monad sequences *dependent* ones — the second computation can *depend* on the result of the first (`x <- mx; my x`). `do`-notation is just sugar over `>>=`. The instance for each monad decides what "effect" means: failure (Maybe), state (State), nondeterminism (`[]`), IO, etc.

"Chain dependent contexted computations." Subclass of [Applicative](applicative.md).

## Class
```haskell
class Applicative m => Monad m where
  return :: a -> m a            -- = pure
  (>>=)  :: m a -> (a -> m b) -> m b
```

## Laws
- `return x >>= f = f x`           (left identity)
- `m >>= return = m`               (right identity)
- `(m >>= f) >>= g = m >>= (\x -> f x >>= g)`   (associativity)

## do-notation desugaring
```haskell
do x <- m1; rest      ≡   m1 >>= \x -> do rest
do m1; rest           ≡   m1 >> rest
do x <- m1; return x  ≡   m1
do return x; rest     ≡   rest
```

## Standard instances

### Maybe (short-circuit on failure)
```haskell
instance Monad Maybe where
  return        = Just
  Nothing >>= _ = Nothing
  Just x  >>= f = f x
```

### List (non-determinism)
```haskell
instance Monad [] where
  return x = [x]
  xs >>= f = concat (map f xs)
  -- equivalent: [y | x <- xs, y <- f x]
```

### Reader
```haskell
instance Monad ((->) r) where
  return  = const
  m >>= f = \e -> f (m e) e
```

### State (hand-rolled)
```haskell
newtype State s a = State { runState :: s -> (a, s) }

instance Monad (State s) where
  return x      = State (\s -> (x, s))
  State p >>= f = State $ \s ->
    let (x, s') = p s
        State q = f x
    in q s'
```

### Parser
```haskell
instance Monad Parser where
  return x  = P (\s -> [(x, s)])
  P p >>= f = P (\s -> concat [parse (f x) s' | (x, s') <- p s])
```

## ⚠ Pitfalls
- `>>=` for list using only first element instead of `concat (map f xs)` — WRONG, must fan out
- Confusing `m a` (parametric) with concrete monad in instance head
- Must also declare `Functor` and `Applicative` (Haskell enforces hierarchy)

## See also
[Applicative](applicative.md) · [Overview](../monads/overview.md) · [Monad Instance](../templates/monad-instance.md) · [Functor Instance](../archetypes/06-functor-instance.md)
