# Archetype 14 — Multi-Effect Interpreter (State + Error)

[← INDEX](../INDEX.md) · [↑ Archetypes](README.md) · [NAVIGATION](../NAVIGATION.md)

⭐⭐⭐ ewan31-40.hs, W9 extension.

## Concept
Interpret command/expr language where both mutable state AND failure arise.

**Intuition:** multiple class constraints (`MonadState s m, MonadError e m`) let one function use *both* effects. Inside the body you mix `get`/`put`/`modify` with `throwError` freely.

## Shape
```haskell
(MonadState s m, MonadError e m) => Cmd -> m ()
```

## Typical sigs
```haskell
evalCalc :: MonadError String m => CalcExpr -> m Int
runCalc  :: (MonadState Int m, MonadError String m) => CalcCmd -> m ()
```

## Solution
[Multi Effect Eval](../interpreters/multi-effect-eval.md) · [Multi Effect](../monads/multi-effect.md)

```haskell
runCalc (DivC x next) =
  if x == 0 then throwError "/0"
  else do current <- get; put (current `div` x); runCalc next
```

## ⚠ Traps
- Forget `import Control.Monad.{State, Error.Class}` — exam may forbid; fall back to concrete `StateT s (Either e) a`
- mtl constraints can confuse; concrete easier for one-effect
- `throwError` exits — state changes since last catch may be lost (or kept, depending on stack order)
- Validate operand (DivC checks `x == 0`), not stored value

## Combines with
[#02 State](02-state-game.md) · [#05](05-adt-translation.md) (commands as ADT) · [#08](08-env-eval.md) (eval as a sub-archetype)

## Seen
ewan31-40.hs (evalCalc, runCalc), W9 problem extension

## See also
[Multi Effect Eval](../interpreters/multi-effect-eval.md) · [Multi Effect](../monads/multi-effect.md)
