# Simple Evaluator

[← INDEX](../INDEX.md) · [↑ Interpreters](README.md) · [NAVIGATION](../NAVIGATION.md)

> **Mental model:** the AST is a tree; `eval` is tree recursion. Each constructor of `Expr` becomes one equation in `eval`. If evaluation can fail, wrap the result in `Maybe` and use `do`-notation so failure short-circuits automatically.

Per-constructor case-fold over `Expr`. No env, optionally Maybe for partiality.

## Plain Int eval (no failure)
```haskell
data Expr = Val Int | Add Expr Expr | Mul Expr Expr | Neg Expr

eval :: Expr -> Int
eval (Val n)   = n
eval (Add a b) = eval a + eval b
eval (Mul a b) = eval a * eval b
eval (Neg a)   = - eval a
```

## With Maybe (division by zero)
```haskell
data Expr = Val Int | Add Expr Expr | Div Expr Expr

eval :: Expr -> Maybe Int
eval (Val n)   = Just n
eval (Add a b) = do
  x <- eval a
  y <- eval b
  return (x + y)
eval (Div a b) = do
  x <- eval a
  y <- eval b
  if y == 0 then Nothing else Just (x `div` y)
```

## With Boolean expressions
```haskell
data BoolExpr = BoolVal Bool | And BoolExpr BoolExpr | Or BoolExpr BoolExpr

evalBool :: BoolExpr -> Bool
evalBool (BoolVal b) = b
evalBool (And l r)   = evalBool l && evalBool r
evalBool (Or l r)    = evalBool l || evalBool r
```

## Depth / size as alternate "eval"
```haskell
depth (Val _)   = 0
depth (Add a b) = 1 + max (depth a) (depth b)
```

## ⚠ Pitfalls
- Don't forget a constructor (non-exhaustive)
- For Maybe-eval, MUST handle propagation — use do-notation

## See also
[Env Eval](env-eval.md) · [Monaderror Eval](monaderror-eval.md) · [Tree Recursion](../patterns/tree-recursion.md) · [Env Eval](../archetypes/08-env-eval.md)
