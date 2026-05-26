# Multi-Effect Interpreter (State + Error)

[← INDEX](../INDEX.md) · [↑ Interpreters](README.md) · [NAVIGATION](../NAVIGATION.md)

> **Mental model:** a calculator that *both* remembers a running total (`State Int`) AND can crash on `/0` (`MonadError String`). The type `(MonadState Int m, MonadError String m) => …` says "any concrete monad supporting both". The function body uses `get`/`put`/`throwError` freely.

Calculator-style command interpreter with state AND errors.

## Setup
```haskell
import Control.Monad.State
import Control.Monad.Error.Class

data CalcCmd =
    EnterC
  | StoreC Int CalcCmd
  | AddC   Int CalcCmd
  | MultC  Int CalcCmd
  | DivC   Int CalcCmd
  | SubC   Int CalcCmd
```

## Polymorphic runCalc (ewan31-40.hs)
```haskell
runCalc :: (MonadState Int m, MonadError String m) => CalcCmd -> m ()
runCalc EnterC = return ()

runCalc (StoreC x next) = do
  put x
  runCalc next

runCalc (AddC x next) = do
  current <- get
  put (current + x)
  runCalc next

runCalc (MultC x next) = do
  current <- get
  put (current * x)
  runCalc next

runCalc (SubC x next) = do
  current <- get
  put (current - x)
  runCalc next

runCalc (DivC x next) =
  if x == 0
    then throwError "Division by zero"
    else do
      current <- get
      put (current `div` x)
      runCalc next
```

## Run with concrete stack
```haskell
type Calc = StateT Int (Either String)

run :: CalcCmd -> Either String (Int, Int)
run cmd = runStateT (runCalc cmd) 0
```

## ⚠ Pitfalls
- Order of mtl constraints in stack matters: `StateT s (Either e)` vs `ExceptT e (State s)` keep/lose state on throw differently
- `throwError` exits — state changes since last catch may be lost
- Validate operand (DivC check `x == 0`), not stored value

## See also
[Multi Effect](../monads/multi-effect.md) · [State](../monads/state.md) · [Monaderror](../monads/monaderror.md) · [Multi Effect](../archetypes/14-multi-effect.md)
