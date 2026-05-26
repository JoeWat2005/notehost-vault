# Reader Monad

[← INDEX](../INDEX.md) · [↑ Monads](README.md) · [NAVIGATION](../NAVIGATION.md)

> **Mental model:** Reader is "a function from environment to value, wrapped as a monad". Imagine every action implicitly takes a config object — `ask` retrieves it, `local` runs a sub-action with a tweaked one. Like State, but read-only.

Read-only environment threaded through computation.

## Type
```haskell
newtype Reader r a = Reader { runReader :: r -> a }
-- or just use ((->) r) as the Reader-functor
```

## Instances
```haskell
instance Functor (Reader r) where
  fmap g (Reader r) = Reader (g . r)

instance Applicative (Reader r) where
  pure x          = Reader (const x)
  Reader rf <*> Reader rx = Reader (\e -> rf e (rx e))

instance Monad (Reader r) where
  Reader r >>= f  = Reader (\e -> runReader (f (r e)) e)
```

## Primitives
```haskell
ask   :: Reader r r              -- get the environment
asks  :: (r -> a) -> Reader r a  -- project from env
local :: (r -> r) -> Reader r a -> Reader r a   -- modify env locally
```

## Function-as-Reader (no newtype)
```haskell
instance Functor ((->) r) where
  fmap = (.)

instance Applicative ((->) r) where
  pure  = const
  rf <*> rx = \e -> rf e (rx e)

instance Monad ((->) r) where
  return  = const
  m >>= f = \e -> f (m e) e
```

## Use cases
- Pure-functional environment for evaluator (alternative to passing `env` explicitly)
- Configuration / context not modified during traversal
- The course's `type Env = String -> Maybe Value` is a Reader-flavoured pattern

## ⚠ Pitfalls
- Rarely seen in exam directly; more often as `((->) r)` Functor/Monad in instance questions
- "Read-only" — for mutable, use [State](state.md)
- Not in course's `Control.Monad.State` import; standalone

## See also
[State](state.md) · [Monad](../typeclasses/monad.md) · [Env Eval](../interpreters/env-eval.md)
