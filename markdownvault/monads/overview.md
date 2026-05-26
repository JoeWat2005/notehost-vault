# Monads — Overview

[← INDEX](../INDEX.md) · [↑ Monads](README.md) · [NAVIGATION](../NAVIGATION.md)

> **Mental model:** a monad is a *type with effects* — `m a` says "a computation that has some side-effect of kind `m`, and ultimately yields an `a`." `do`-notation lets you sequence such computations as if they were imperative statements. The *specific* `m` decides what "side effect" means: `Maybe` = may-fail, `State s` = mutable s, `IO` = real-world I/O, `[]` = nondeterminism, etc.

A monad is a type `m a` you can:
- **wrap a value in**: `pure / return :: a -> m a`
- **chain dependently**: `(>>=) :: m a -> (a -> m b) -> m b`

## Hierarchy
```
Functor → Applicative → Monad
                          ↓
                        Alternative (MonadPlus)
```

## do-notation
```haskell
do x <- m1                    --   m1 >>= \x ->
   y <- m2                    --     m2 >>= \y ->
   pure (combine x y)         --       pure (combine x y)
```

## Choose your monad

| Effect             | Monad                | File |
|--------------------|----------------------|------|
| failure (none)     | `Maybe a`            | [Maybe](maybe.md) |
| failure w/ msg     | `Either e a`         | [Either](either.md) |
| mutable state      | `State s a`          | [State](state.md) |
| accumulating log   | `Writer w a`         | [Writer](writer.md) |
| input/output       | `IO a`               | [IO](io.md) |
| read-only env      | `Reader r a`         | [Reader](reader.md) |
| non-determinism    | `[a]`                | [List Monad](list-monad.md) |
| error w/ class     | `MonadError e m`     | [Monaderror](monaderror.md) |
| multi-effect       | mtl constraints      | [Multi Effect](multi-effect.md) |
| reified DSL        | `Free f a`           | A3 |

## Generic combinators (work for any Monad)
```haskell
return     :: Monad m => a -> m a
(>>=)      :: Monad m => m a -> (a -> m b) -> m b
(>>)       :: Monad m => m a -> m b -> m b
sequence   :: Monad m => [m a] -> m [a]
mapM       :: Monad m => (a -> m b) -> [a] -> m [b]
mapM_      :: Monad m => (a -> m b) -> [a] -> m ()
replicateM :: Monad m => Int -> m a -> m [a]
forM       :: Monad m => [a] -> (a -> m b) -> m [b]
when       :: Applicative f => Bool -> f () -> f ()
unless     :: Applicative f => Bool -> f () -> f ()
void       :: Functor f => f a -> f ()
join       :: Monad m => m (m a) -> m a
liftM      :: Monad m => (a -> b) -> m a -> m b      -- = fmap
ap         :: Monad m => m (a -> b) -> m a -> m b    -- = <*>
```

## See also
[Monad](../typeclasses/monad.md) · [Monadic Recursion](../patterns/monadic-recursion.md) · [Triggers](../patterns/triggers.md)
