# Environment-Based Evaluator

[← INDEX](../INDEX.md) · [↑ Interpreters](README.md) · [NAVIGATION](../NAVIGATION.md)

> **Mental model:** an environment is a *lookup table* from names to values, passed alongside the expression. `Var x` becomes `lookup x env`. `Let x e body` extends the env when evaluating the body — *shadowing* (later bindings override earlier) emerges from `(x,v) : env`.

Add variable lookup via `Env`. Tier-1 exam pattern.

## Two env representations

### Assoc list
```haskell
type Env = [(String, Int)]
```

### Function-as-env (W7 / interpreter lecture)
```haskell
type Env = String -> Maybe Value

bind :: Env -> String -> Value -> Env
bind env x v = \y -> if x == y then Just v else env y
```

## With let-bindings
```haskell
data Expression
  = Literal Int
  | Variable String
  | Addition Expression Expression
  | Multiplication Expression Expression
  | Let String Expression Expression

eval :: Env -> Expression -> Maybe Int
eval env (Literal n)        = Just n
eval env (Variable x)       = lookup x env
eval env (Addition e1 e2)   = do
  v1 <- eval env e1
  v2 <- eval env e2
  return (v1 + v2)
eval env (Multiplication e1 e2) = do
  v1 <- eval env e1
  v2 <- eval env e2
  return (v1 * v2)
eval env (Let x e body) = do
  v <- eval env e
  eval ((x, v) : env) body          -- extended env
```

## Typed values (BVal / IVal)
```haskell
data Value = BVal Bool | IVal Int
data Expr  = Val Value | Var String | Plus Expr Expr | If Expr Expr Expr
type Env   = String -> Maybe Value

eval :: Env -> Expr -> Maybe Value
eval env (Val v) = Just v
eval env (Var x) = env x
eval env (Plus e1 e2) = do
  IVal x <- eval env e1    -- pattern-bind: fails to Nothing on type mismatch
  IVal y <- eval env e2
  return (IVal (x + y))
eval env (If c t f) = do
  BVal b <- eval env c
  if b then eval env t else eval env f
```

## ⚠ Pitfalls
- **Let scoping**: `eval ((x,v) : env) body`, NOT just `eval [(x,v)] body`
- function-env: `env x` vs assoc: `lookup x env` — different ops
- typed values: pattern-bind `IVal x <-` is INTENTIONAL (triggers Monad-fail)
- Don't forget Var = lookup

## See also
[Simple Eval](simple-eval.md) · [Monaderror Eval](monaderror-eval.md) · [Env Eval](../archetypes/08-env-eval.md) · [Env Eval Example](../examples/env-eval-example.md)
