# Free Monad

[← INDEX](../INDEX.md) · [↑ Monads](README.md) · [NAVIGATION](../NAVIGATION.md)

> **Mental model:** the Free monad lets you describe a computation as *data*, then run it later with whatever interpreter you like. Instead of "executing" actions, you build a tree of them (`Pure x` = done; `Free f` = an effect, with the rest of the computation nested inside). One DSL — many interpreters (trace, schedule, run for real).

A3-style monad: data of computation that can be re-interpreted.

## Type
```haskell
data Free f a = Pure a | Free (f (Free f a))
```
A `Free f a` is either a pure value, or an effect (in functor `f`) wrapping the rest of the computation.

## Instances
```haskell
instance Functor f => Functor (Free f) where
  fmap g (Pure a)  = Pure (g a)
  fmap g (Free fa) = Free (fmap (fmap g) fa)

instance Functor f => Applicative (Free f) where
  pure                = Pure
  Pure g  <*> fa      = fmap g fa
  Free fg <*> fa      = Free (fmap (<*> fa) fg)

instance Functor f => Monad (Free f) where
  return        = Pure
  Pure a  >>= f = f a
  Free fa >>= f = Free (fmap (>>= f) fa)
```

## liftF — embed a single effect
```haskell
liftF :: Functor f => f a -> Free f a
liftF fa = Free (fmap Pure fa)
```

## unfree — run in the underlying monad
```haskell
unfree :: Monad m => Free m a -> m a
unfree (Pure a)  = return a
unfree (Free ma) = ma >>= unfree
```

## A3 patterns

### FreeState = State as Free
```haskell
type FreeState s a = Free (State s) a

getF :: FreeState s s
getF = liftF get

putF :: s -> FreeState s ()
putF s = liftF (put s)

fibF :: Int -> FreeState (Int, Int) ()
fibF 0 = return ()
fibF n = do
  (a, b) <- getF
  putF (b, a + b)
  fibF (n - 1)
```

### Functor sum for combining effects
```haskell
data FSum f g a = FLeft (f a) | FRight (g a)

instance (Functor f, Functor g) => Functor (FSum f g) where
  fmap h (FLeft fa)  = FLeft  (fmap h fa)
  fmap h (FRight ga) = FRight (fmap h ga)
```

### Yield + State
```haskell
data Yield a = Yield a   deriving Functor

type YieldState s a = Free (FSum (State s) Yield) a

getY :: YieldState s s
getY = liftF (FLeft get)

putY :: s -> YieldState s ()
putY s = liftF (FLeft (put s))

yield :: YieldState s ()
yield = liftF (FRight (Yield ()))
```

## Interpreting Free

### Pattern: case on Pure / Free
```haskell
trace :: FreeState s a -> State ([s], s) a
trace (Pure x) = return x
trace (Free m) = do
  -- weakened: run m's State action and store result history
  result <- wkState m
  trace result
```

### Round-robin scheduler
```haskell
roundRobin :: [YieldState s ()] -> State s ()
roundRobin []                          = return ()
roundRobin (Pure ()       : rest)      = roundRobin rest               -- drop done
roundRobin (Free (FRight (Yield k)) : rest) = roundRobin (rest ++ [k]) -- rotate
roundRobin (Free (FLeft  m)         : rest) = do
  next <- m                                                            -- run state step
  roundRobin (next : rest)
```

## Conceptual summary
- `Free` reifies a monadic computation as data
- Re-interpretable: same `Free` value can be run with different `f`-interpreters
- A3 used this to demo trace / round-robin / sleep schedulers over same DSL

## ⚠ Pitfalls
- `Pure` vs `Free` — case-match BOTH
- `fmap (fmap g)` (double-fmap) is correct in Functor instance — first fmap is over f, second over Free
- A3 supplied the instances — exam unlikely to ask you to write them from scratch
- The `Functor f =>` constraint is required EVERYWHERE

## See also
[Monad](../typeclasses/monad.md) · [Multi-Effect](multi-effect.md) · [State](state.md) · [Free Monad Trace](../examples/free-monad-trace.md)
