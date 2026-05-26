# Environment Evaluator with let-bindings

[← INDEX](../INDEX.md) · [↑ Examples](README.md) · [NAVIGATION](../NAVIGATION.md)

Evaluate typed expressions under variable environment.

> **Technique:** `eval :: Env -> Expr -> Maybe Int` recurses over the AST; `Var x` looks up `env`; `Let x e body` extends the env with `(x, eval-of-e)` when evaluating `body`. `Maybe` short-circuits on unbound vars.

## Spec
```haskell
data Expression =
    Literal Int
  | Variable String
  | Addition Expression Expression
  | Multiplication Expression Expression
  | Let String Expression Expression

type Env = [(String, Int)]

eval :: Env -> Expression -> Maybe Int
```

## Solution
```haskell
eval :: Env -> Expression -> Maybe Int
eval env (Literal n) = Just n

eval env (Variable x) = lookup x env

eval env (Addition e1 e2) = do
  v1 <- eval env e1
  v2 <- eval env e2
  return (v1 + v2)

eval env (Multiplication e1 e2) = do
  v1 <- eval env e1
  v2 <- eval env e2
  return (v1 * v2)

eval env (Let x e body) = do
  v <- eval env e
  eval ((x, v) : env) body                  -- extend env
```

## Trace
```haskell
-- "let x = 5 in x + 3"
eval [] (Let "x" (Literal 5) (Addition (Variable "x") (Literal 3)))
-- Just 8

-- "y * 2" with y unbound
eval [] (Multiplication (Variable "y") (Literal 2))
-- Nothing
```

## Typed-value variant (BVal / IVal)
```haskell
data Value = BVal Bool | IVal Int
data Expr = Val Value | Var String | Plus Expr Expr | If Expr Expr Expr
type Env = String -> Maybe Value

eval env (Plus e1 e2) = do
  IVal x <- eval env e1            -- pattern-bind: Nothing on type mismatch
  IVal y <- eval env e2
  return (IVal (x + y))

eval env (If c t f) = do
  BVal b <- eval env c
  if b then eval env t else eval env f
```

## ⚠ Traps
- **Let scoping**: `eval ((x,v):env) body`, NOT just `eval [(x,v)] body`
- Function-env: `env x` vs assoc: `lookup x env`
- Pattern-bind `IVal x <- …` in do is INTENTIONAL — Monad-fail propagates Nothing
- Var without lookup is the most common typo

## Pattern
[#08](../archetypes/08-env-eval.md) — environment-based evaluator.

## See also
[Env Eval](../interpreters/env-eval.md) · [Env Eval](../archetypes/08-env-eval.md)
