# Multi-Effect Monads (mtl)

[← INDEX](../INDEX.md) · [↑ Monads](README.md) · [NAVIGATION](../NAVIGATION.md)

> **Mental model:** to combine effects (e.g. "mutable state AND may throw error"), require multiple class constraints in your type: `(MonadState s m, MonadError e m) => …`. The caller picks a concrete stack that supports both — your function code stays the same.

Combine multiple effects via class constraints.

## Common combinations
```haskell
(MonadState s m, MonadError e m) => m a
(MonadState s m, MonadWriter w m) => m a
(MonadReader r m, MonadError e m) => m a
```

## Calculator with state + error (ewan31-40.hs)
```haskell
import Control.Monad.State
import Control.Monad.Error.Class

runCalc :: (MonadState Int m, MonadError String m) => CalcCmd -> m ()
runCalc EnterC = return ()

runCalc (StoreC x next) = do
  put x
  runCalc next

runCalc (AddC x next) = do
  current <- get
  put (current + x)
  runCalc next

runCalc (DivC x next) =
  if x == 0
    then throwError "Division by zero"
    else do
      current <- get
      put (current `div` x)
      runCalc next
```

## Why use mtl style
- Polymorphic over the monad stack
- Composable: caller picks concrete `StateT s (Either e)` or similar
- Tests can swap interpretation

## Concrete stacks
- `StateT s (Either e)` — state with error
- `WriterT w (State s)` — state + log
- `ReaderT r IO` — env + IO

## ⚠ Pitfalls
- Heavy imports — may conflict with "no extra imports" exam rule
- mtl constraints can be confusing; concrete `Either` simpler for one-effect
- `throwError` exits — state changes since last catch ARE lost (or kept, depending on stack order)

## See also
[State](state.md) · [Monaderror](monaderror.md) · [Multi Effect Eval](../interpreters/multi-effect-eval.md) · [Multi Effect](../archetypes/14-multi-effect.md)
