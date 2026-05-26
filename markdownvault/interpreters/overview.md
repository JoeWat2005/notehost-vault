# Interpreters — Overview

[← INDEX](../INDEX.md) · [↑ Interpreters](README.md) · [NAVIGATION](../NAVIGATION.md)

> **Mental model:** an interpreter is *tree recursion that returns a value*. The expression tree (AST) is just a recursive ADT; `eval` walks each ctor, combining sub-results. Each new effect (failure, env, state, error message) wraps the return type in a different monad — but the *shape* of `eval` is identical.

Evaluate an [AST](../templates/adt-declarations.md) by structural recursion over its constructors.

## Standard pipeline
```
source string  →  [parser]  →  AST  →  [evaluator]  →  result
```

## Variants by effect needed

| Effect           | Eval signature                                    | File |
|------------------|---------------------------------------------------|------|
| pure / total     | `Expr -> Int`                                     | [Simple Eval](simple-eval.md) |
| may fail         | `Expr -> Maybe Int`                               | [Simple Eval](simple-eval.md) |
| variables        | `Env -> Expr -> Maybe Value`                      | [Env Eval](env-eval.md) |
| error message    | `MonadError String m => Expr -> m Int`            | [Monaderror Eval](monaderror-eval.md) |
| state + error    | `(MonadState s m, MonadError e m) => Cmd -> m ()` | [Multi Effect Eval](multi-effect-eval.md) |
| imperative lang  | `Program -> Storage -> Storage`                   | [Imperative Storage](imperative-storage.md) |

## Universal evaluator template
```haskell
eval (Ctor0)         = base
eval (Ctor1 sub)     = combine (eval sub)
eval (Ctor2 e1 e2)   = combine (eval e1) (eval e2)
```

## Add a new operator (extend interpreter)
3-layer change:
1. **AST**: `data Expr += NewCtor …`
2. **Parser**: new rule, fit precedence
3. **Eval**: new pattern case

## See also
[Env Eval](../archetypes/08-env-eval.md) · [Multi Effect](../archetypes/14-multi-effect.md) · [Extend Interp](../archetypes/19-extend-interp.md) · [Tree Recursion](../patterns/tree-recursion.md)
