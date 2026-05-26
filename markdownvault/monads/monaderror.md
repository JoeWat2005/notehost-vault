# MonadError

[← INDEX](../INDEX.md) · [↑ Monads](README.md) · [NAVIGATION](../NAVIGATION.md)

> **Mental model:** `MonadError` is the *class* version of [Either](either.md) — it says "any monad that can fail with an error of type `e`". Writing `MonadError String m =>` lets your function work for any concrete monad with error support (Either, ExceptT, multi-effect stacks…). `throwError` is the failure call; `catchError` recovers.

mtl-style class constraint for "may throw error of type e".

## Class
```haskell
class Monad m => MonadError e m where
  throwError :: e -> m a
  catchError :: m a -> (e -> m a) -> m a
```

## Concrete instance
- `Either e` is the canonical instance
- `ExceptT e m` for layered combinations

## Usage
```haskell
eval :: MonadError String m => CalcExpr -> m Int
eval (Val n)   = return n
eval (Add a b) = do x <- eval a; y <- eval b; return (x + y)
eval (Div a b) = do
  x <- eval a
  y <- eval b
  if y == 0 then throwError "Division by zero" else return (x `div` y)
```

## Why polymorphic m
- Works with `Either String` (concrete)
- Composes with `MonadState s` for combined effects
- Allows callers to choose interpretation

## Run with Either
```haskell
-- evalCalc returns Either String Int when m = Either String
runEval :: CalcExpr -> Either String Int
runEval = eval
```

## ⚠ Pitfalls
- Forget `import Control.Monad.Error.Class` or `Control.Monad.Except`
- `throwError` immediately exits; no cleanup possible
- Mock test forbids extra imports — use `Either e a` directly if so

## See also
[Either](either.md) · [Multi Effect](multi-effect.md) · [Monaderror Eval](../interpreters/monaderror-eval.md) · [Multi Effect](../archetypes/14-multi-effect.md)
