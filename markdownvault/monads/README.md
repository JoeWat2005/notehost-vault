# monads/ — Specific monad references

→ [← INDEX](../INDEX.md) · [NAVIGATION](../NAVIGATION.md)

One file per monad. Each covers: type, instance, primitives, idiomatic patterns, pitfalls.

> **One-line intuitions for each monad:**
> - **Maybe** = "may fail; short-circuits on `Nothing`"
> - **Either** = "may fail *with a message*"
> - **State** = "hides a mutable variable in a `do`-block"
> - **Writer** = "side-channel log via Monoid"
> - **Reader** = "implicit read-only environment"
> - **IO** = "real-world effects, executed by the runtime"
> - **List `[]`** = "non-determinism — all possible results"
> - **MonadError** = "Either as a class — works on any error-supporting monad"
> - **Multi-effect** = "two class constraints; one function uses both effects"
> - **Free** = "computation as data; re-interpret it however you like"

## Files

| File | Use when | Effect |
|------|----------|--------|
| [overview.md](overview.md) | Choosing which monad to use | (decision table) |
| [maybe.md](maybe.md) | "may fail / return Nothing" | Partiality |
| [either.md](either.md) | "fail with error message" | Error with payload |
| [state.md](state.md) | "track mutable state / counter / game" | Threaded state |
| [writer.md](writer.md) | "accumulate log / trace / metric" | Monoid output |
| [io.md](io.md) | "interactive / main / putStrLn / getLine" | Real-world effects |
| [reader.md](reader.md) | "read-only environment / config" | Implicit env |
| [list-monad.md](list-monad.md) | "non-determinism / all possible" | Multiple results |
| [monaderror.md](monaderror.md) | Polymorphic error class | mtl-style |
| [multi-effect.md](multi-effect.md) | "State + Error together" | Stacked constraints |
| [free.md](free.md) | A3-style reified computation | Free monad over functor |

## Decision tree
```
Need failure?        → Maybe (no msg) / Either (with msg) / MonadError (class)
Need mutable state?  → State / MonadState
Need to log?         → Writer
Need IO?             → IO
Need to choose?      → list monad
Need env config?     → Reader
Multiple of above?   → multi-effect (mtl)
```

## Generic combinators (work for ANY monad)
Documented in [overview.md](overview.md) and [../mapm.md](../mapm.md):
- `mapM`, `mapM_`, `sequence`, `sequence_`
- `forM`, `forM_`, `replicateM`
- `when`, `unless`, `void`, `join`

## Related directories
- [../typeclasses/monad.md](../typeclasses/monad.md) — the Monad class itself
- [../templates/monad-instance.md](../templates/monad-instance.md) — writing your own
- [../patterns/monadic-recursion.md](../patterns/monadic-recursion.md) — recursion patterns
- [../interpreters/](../interpreters/) — eval patterns using these monads
