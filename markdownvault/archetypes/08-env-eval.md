# Archetype 08 — Environment-Based Evaluator

[← INDEX](../INDEX.md) · [↑ Archetypes](README.md) · [NAVIGATION](../NAVIGATION.md)

⭐⭐⭐⭐ W7, S15 #148, A3.

## Concept
Evaluate AST under an Env mapping vars to values, possibly with failure.

**Intuition:** `Env` is a lookup table; `Var x` becomes `env x` (or `lookup x env`). `Let x e body` evaluates `e` first, then extends the env with `(x,v)` when evaluating `body`. `Maybe` handles unbound-variable failure.

## Shape
```haskell
type Env = String -> Maybe Value     -- or [(String, Value)]
eval :: Env -> Expr -> Maybe Value
eval env (Val n)     = Just n
eval env (Var x)     = env x         -- (or lookup x env)
eval env (Add a b)   = do x <- eval env a; y <- eval env b; return (combine x y)
eval env (Let x e b) = do v <- eval env e; eval ((x, v) : env) b
```

## Typical sigs
```haskell
eval :: Env -> Expr -> Maybe Value
eval :: Env -> Expr -> Maybe Int
bind :: Env -> String -> Value -> Env
```

## Solution
[Env Eval](../interpreters/env-eval.md) · [ADT Declarations](../templates/adt-declarations.md)

## ⚠ Traps
- **Let scoping**: `eval ((x,v):env) body` (extend), NOT just `eval [(x,v)] body`
- function-env vs assoc-list: `env x` vs `lookup x env`
- typed Value (BVal/IVal): pattern-bind `IVal x <- …` in do is INTENTIONAL (gives Nothing on type mismatch — Monad-fail)
- Don't forget Var = lookup (most common typo)
- shadowing direction in Let — newer binding takes precedence (cons to front of list)

## Combines with
[#01 Expr as AST](01-tree-recursion.md) · [#14 with errors](14-multi-effect.md) · do-on-Maybe ([Maybe](../monads/maybe.md))

## Seen
W7 problem (typed Expr+Env), S15 #148, A3 (typed Expr in Free), ewan20-31.hs (Plus/Times/If/Lt typed)

## See also
[Env Eval](../interpreters/env-eval.md) · [Env Eval Example](../examples/env-eval-example.md) · [Maybe](../monads/maybe.md)
