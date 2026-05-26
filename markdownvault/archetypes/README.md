# archetypes/ — 20 ranked exam-question shapes

→ [← INDEX](../INDEX.md) · [NAVIGATION](../NAVIGATION.md)

Each archetype = the SHAPE of a typical 10-mark exam question. Numbered 01-20, ranked by exam likelihood.

**Start here:** [00-priority.md](00-priority.md) — the ranking matrix.

> Every archetype file follows the same anatomy: **Concept** (one-line description + intuition) → **Shape** (the canonical code skeleton) → **Typical sigs** → **Solution** (link to template) → **Traps** → **Combines with** → **Seen** (where in the course).

## Tier 1 — almost certain (⭐⭐⭐⭐⭐ / ⭐⭐⭐⭐)
- [01-tree-recursion.md](01-tree-recursion.md) — structural recursion on tree ADT
- [02-state-game.md](02-state-game.md) — State monad game/sim
- [03-generic-monad.md](03-generic-monad.md) — `Monad m =>` combinator
- [04-matrix.md](04-matrix.md) — `[[Int]] -> Bool` via transpose
- [05-adt-translation.md](05-adt-translation.md) — `Expr -> Circuit` etc.
- [06-functor-instance.md](06-functor-instance.md) — typeclass instance
- [08-env-eval.md](08-env-eval.md) — environment-based evaluator

## Tier 2 — likely (⭐⭐⭐)
- [07-codec.md](07-codec.md) — encode/decode round-trip
- [09-prelude-reimpl.md](09-prelude-reimpl.md) — reimplement Prelude
- [10-fold.md](10-fold.md) — fold reformulation
- [11-bst.md](11-bst.md) — BST insert/delete/valid
- [14-multi-effect.md](14-multi-effect.md) — State + Error
- [19-extend-interp.md](19-extend-interp.md) — extend an interpreter

## Tier 3 — possible (⭐⭐)
- [12-rep-conv.md](12-rep-conv.md) — two reps, switch between
- [13-pretty-print.md](13-pretty-print.md) — custom Show
- [15-writer-trace.md](15-writer-trace.md) — Writer log
- [16-parser.md](16-parser.md) — parser combinators
- [18-memo.md](18-memo.md) — lazy memoisation

## Tier 4 — low probability (⭐)
- [17-zipper.md](17-zipper.md) — focus + context navigation
- [20-laws.md](20-laws.md) — iso / retract / typeclass laws

## File format
Each archetype file has:
- **Concept** — one line
- **Shape** — recurring code structure
- **Typical sigs** — common type signatures
- **Solution** — link to template
- **⚠ Traps** — common bugs
- **Combines with** — other archetypes pairing
- **Seen** — where in course (Mock / Wn / An / Sn)

## Likely exam composition
Q1 #01 · Q2 #03 · Q3 #02 · Q4 #04 or #08 · Q5 #05 or #06

## Related
- [../if-you-see-x.md](../if-you-see-x.md) — phrase → archetype
- [../examples/](../examples/) — worked solutions per archetype
- [../templates/](../templates/) — copy-paste code per archetype
