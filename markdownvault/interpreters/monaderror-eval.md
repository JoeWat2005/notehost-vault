# MonadError Evaluator

[← INDEX](../INDEX.md) · [↑ Interpreters](README.md) · [NAVIGATION](../NAVIGATION.md)

> **Mental model:** same recursion as [simple eval](simple-eval.md), but the return type is `m Int` with a `MonadError String m =>` constraint. Now `throwError "msg"` short-circuits with a *message* (not just `Nothing`). Concretely, run with `Either String`.

Evaluator that may throw an error of type `e` with a message.

## Setup
```haskell
import Control.Monad.Error.Class

data CalcExpr =
    Val Int
  | Add CalcExpr CalcExpr
  | Mult CalcExpr CalcExpr
  | Sub CalcExpr CalcExpr
  | Div CalcExpr CalcExpr
```

## Polymorphic eval
```haskell
evalCalc :: MonadError String m => CalcExpr -> m Int
evalCalc (Val x)        = return x
evalCalc (Add e1 e2)    = do x <- evalCalc e1; y <- evalCalc e2; return (x + y)
evalCalc (Mult e1 e2)   = do x <- evalCalc e1; y <- evalCalc e2; return (x * y)
evalCalc (Sub e1 e2)    = do x <- evalCalc e1; y <- evalCalc e2; return (x - y)
evalCalc (Div e1 e2)    = do
  x <- evalCalc e1
  y <- evalCalc e2
  if y == 0
    then throwError "Division by zero"
    else return (x `div` y)
```

## Concrete instance
- `Either String` is a `MonadError String`
- Running: `evalCalc expr :: Either String Int`

## Pattern
- `return x` for success
- `throwError msg` for failure
- do-block chains propagate error

## ⚠ Pitfalls
- Exam may forbid `Control.Monad.Error.Class` — fall back to `Either String a` directly
- `throwError` immediately short-circuits — no cleanup runs after
- Validate operand BEFORE dividing (check `y == 0` BEFORE the `div` call)

## See also
[Monaderror](../monads/monaderror.md) · [Either](../monads/either.md) · [Env Eval](env-eval.md) · [Multi Effect Eval](multi-effect-eval.md)
