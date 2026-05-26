# typeclasses/ — Class declarations & instance patterns

→ [← INDEX](../INDEX.md) · [NAVIGATION](../NAVIGATION.md)

Reference for Haskell typeclasses you'll need to USE and INSTANCE.

> **One-line intuitions:**
> - **Functor** = "preserve structure, transform values" (`fmap`)
> - **Applicative** = "apply wrapped fn to wrapped value" (`<*>`)
> - **Monad** = "chain dependent contexted computations" (`>>=`/`do`)
> - **Alternative** = "try this; on failure try that" (`<|>`)
> - **Eq / Ord** = "comparable / orderable" (your custom type behaves like Int)
> - **Num** = "arithmetic — makes `5` work for your type via `fromInteger`"

## Files

| File | What it covers |
|------|----------------|
| [functor.md](functor.md) | `fmap` — preserve shape, transform values |
| [applicative.md](applicative.md) | `pure`, `<*>` — sequence effects |
| [monad.md](monad.md) | `return`, `>>=` — dependent computation |
| [alternative.md](alternative.md) | `empty`, `<\|>` — failure + choice |
| [eq-ord-num.md](eq-ord-num.md) | `==`, `compare`, `+`, `fromInteger` |
| [custom-instances.md](custom-instances.md) | How to write your own typeclass + instances |

## Hierarchy
```
Functor → Applicative → Monad
                            ↓
                         Alternative / MonadPlus
```

## Class-instance archetype
See [archetypes/06-functor-instance.md](../archetypes/06-functor-instance.md) — likely exam Q5 candidate.

## Related directories
- [monads/](../monads/) — specific Monad instances (Maybe, State, etc.)
- [templates/functor-instance.md](../templates/functor-instance.md) — copy-paste instance skeletons
- [templates/monad-instance.md](../templates/monad-instance.md) — full Functor+Applicative+Monad declarations
