# Free Monad Trace (A3)

[← INDEX](../INDEX.md) · [↑ Examples](README.md) · [NAVIGATION](../NAVIGATION.md)

Worked example from Assignment 3: interpret `FreeState` while recording every intermediate state.

> **Technique:** the Free monad reifies the computation as data. To trace, walk the `Pure`/`Free` structure case by case — at each `Free` step, run the underlying State, snapshot the state, recurse.


## Setup
```haskell
data Free f a = Pure a | Free (f (Free f a))
type FreeState s a = Free (State s) a

liftF :: Functor f => f a -> Free f a
liftF fa = Free (fmap Pure fa)

getF :: FreeState s s
getF = liftF get

putF :: s -> FreeState s ()
putF s = liftF (put s)
```

## Round-trip Rose ↔ Free []
```haskell
data Rose a = Lf a | Br [Rose a]

toRose :: Free [] a -> Rose a
toRose (Pure x)  = Lf x
toRose (Free xs) = Br (map toRose xs)

fromRose :: Rose a -> Free [] a
fromRose (Lf x)  = Pure x
fromRose (Br xs) = Free (map fromRose xs)

-- Law: toRose . fromRose = id  AND  fromRose . toRose = id  (true isomorphism)
```

## trace — record every intermediate state
```haskell
trace :: FreeState s a -> State ([s], s) a
trace (Pure x) = return x
trace (Free m) = do
  -- Step the underlying State, then record
  (history, s) <- get
  let (next, s') = runState m s
  put (s' : history, s')
  trace next
```

## roundRobin — cooperative scheduler over YieldState
```haskell
data Yield a = Yield a deriving Functor
data FSum f g a = FLeft (f a) | FRight (g a)
instance (Functor f, Functor g) => Functor (FSum f g) where
  fmap h (FLeft fa)  = FLeft  (fmap h fa)
  fmap h (FRight ga) = FRight (fmap h ga)

type YieldState s a = Free (FSum (State s) Yield) a

yield :: YieldState s ()
yield = liftF (FRight (Yield ()))

getY :: YieldState s s
getY = liftF (FLeft get)

putY :: s -> YieldState s ()
putY s = liftF (FLeft (put s))

roundRobin :: [YieldState s ()] -> State s ()
roundRobin [] = return ()
roundRobin (Pure () : rest) = roundRobin rest
roundRobin (Free (FRight (Yield k)) : rest) =
  roundRobin (rest ++ [k])         -- yields → back of queue
roundRobin (Free (FLeft m) : rest) = do
  next <- m                         -- run one state step
  roundRobin (next : rest)
```

## schedule — sleep counters
```haskell
data Sleep a = Sleep Int a deriving Functor
type SleepState s a = Free (FSum (State s) Sleep) a

sleep :: Int -> SleepState s ()
sleep n = liftF (FRight (Sleep n ()))

-- (full schedule impl in A3Solutions; uses thread + counter pairs)
```

## Pattern
[Archetype 06 Functor Instance](../archetypes/06-functor-instance.md) + [Multi-Effect](../monads/multi-effect.md). A3 demonstrates Free as a **reifiable computation DSL**.

## Key idea
**`Free m`** = data describing what to do
**Interpreter** (trace / roundRobin / schedule) = chooses what "doing" means

Same `Free` value can be:
- run normally (via `unfree`)
- traced (via `trace`)
- cooperatively scheduled (via `roundRobin`)
- sleep-aware scheduled (via `schedule`)

## See also
[Free Monad](../monads/free.md) · [Archetype 06 Functor Instance](../archetypes/06-functor-instance.md) · [Multi-Effect](../monads/multi-effect.md)
