# State Monad

[← INDEX](../INDEX.md) · [↑ Monads](README.md) · [NAVIGATION](../NAVIGATION.md)

> **Mental model:** *State hides an accumulator.* `State s a` is really `s -> (a, s)` — give it a starting state, get back a value and a new state. The monad threads the state through automatically, so inside a `do`-block you can pretend you have a mutable `s`.

Hidden mutable state, threaded implicitly through do-block. **Tier-1 exam topic.**

## Import
```haskell
import Control.Monad.State
```

## Type
```haskell
newtype State s a = State { runState :: s -> (a, s) }
```

## Primitives
```haskell
get    :: State s s                  -- read current state
put    :: s -> State s ()            -- overwrite state
modify :: (s -> s) -> State s ()     -- = get >>= put . f
gets   :: (s -> a) -> State s a      -- = fmap f get
```

## Runners
```haskell
runState  :: State s a -> s -> (a, s)   -- full pair
evalState :: State s a -> s -> a        -- value only
execState :: State s a -> s -> s        -- final state only
```

## Idiomatic patterns

### Fresh counter (gensym)
```haskell
fresh :: State Int Int
fresh = do n <- get; put (n+1); return n
```

### Counter via modify
```haskell
countFiles :: Dir -> State Int ()
countFiles (File _ _)    = modify (+1)
countFiles (SubDir _ cs) = mapM_ countFiles cs
```

### Twin state (pair)
```haskell
factHelper 0 = return ()
factHelper n = do modify (* n); factHelper (n-1)

factorial n = execState (factHelper n) 1
```

### Game state (clamp)
```haskell
takeTokens n First  = do (x, y) <- get; put (max 0 (x-n), y)
takeTokens n Second = do (x, y) <- get; put (x, max 0 (y-n))
```

### Custom type synonym (Mock Q3)
```haskell
type NimGame a = State (Int, Int) a

gameOver :: NimGame Bool
gameOver = do (x, y) <- get; return (x == 0 && y == 0)
```

## ⚠ Pitfalls
- `State s a` — `s` is FIRST type param
- runState vs evalState vs execState — know which extracts what
- Forget `import Control.Monad.State` → auto-marker fails
- Use `modify` instead of `get >>= put . f` (cleaner)

## See also
[Writer](writer.md) · [Multi Effect](multi-effect.md) · [State Game](../archetypes/02-state-game.md) · [State Fresh](../templates/state-fresh.md) · [State Game](../templates/state-game.md)
