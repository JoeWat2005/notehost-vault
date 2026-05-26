# interpreters/ — Evaluator and interpreter patterns

→ [← INDEX](../INDEX.md) · [NAVIGATION](../NAVIGATION.md)

Evaluate ASTs by structural recursion. Covers pure eval, env-based, error-handling, multi-effect, and full imperative-language interpreters.

> **One-line intuitions:**
> - **Simple eval** = "tree recursion that returns an `Int`"
> - **Env eval** = "+ a lookup table; `Var x` becomes `lookup x env`"
> - **MonadError eval** = "+ failure with a message via `throwError`"
> - **Multi-effect** = "+ mutable state via mtl class constraints"
> - **Imperative storage** = "statements transform memory (`Storage -> Storage`); expressions read it"

## Files

| File | Effect needed | Sig |
|------|--------------|-----|
| [overview.md](overview.md) | (decision table) | — |
| [simple-eval.md](simple-eval.md) | none / pure | `Expr -> Int` |
| [env-eval.md](env-eval.md) | variables / let-bindings | `Env -> Expr -> Maybe Value` |
| [monaderror-eval.md](monaderror-eval.md) | error messages | `MonadError String m => Expr -> m Int` |
| [multi-effect-eval.md](multi-effect-eval.md) | state + error | `(MonadState, MonadError) => Cmd -> m ()` |
| [imperative-storage.md](imperative-storage.md) | While/If/Block/`:=` | `Program -> Storage -> Storage` |

## Pipeline
```
source string  →  [parser]  →  AST  →  [evaluator]  →  result
```

## Extending an existing interpreter
See [../interpreter-extension.md](../interpreter-extension.md) — 3-layer change template.

## Related
- [../templates/parser-newtype.md](../templates/parser-newtype.md) — parser combinators
- [../archetypes/08-env-eval.md](../archetypes/08-env-eval.md) — exam archetype
- [../archetypes/19-extend-interp.md](../archetypes/19-extend-interp.md) — "add a new feature"
- [../examples/env-eval-example.md](../examples/env-eval-example.md) — worked example
- [../examples/expr-parser.md](../examples/expr-parser.md) — full parser + eval
