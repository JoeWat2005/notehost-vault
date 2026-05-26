# patterns/ — Reusable code shapes

→ [← INDEX](../INDEX.md) · [NAVIGATION](../NAVIGATION.md)

Cross-cutting templates that appear across multiple archetypes. These are the **building blocks** — most exam answers combine 2-3 of these.

> **One-line intuitions:**
> - **List recursion** = `[] = base; (x:xs) = combine x (f xs)`
> - **Tree recursion** = one equation per constructor, recurse on children
> - **Folds** = "replace `(:)` with `op`, replace `[]` with `b`"
> - **Accumulator** = carry running state on the way *down*, not on the way back up
> - **Monadic recursion** = same as list-cons, but extract with `<-` instead of `=`
> - **Traversal** = "where you call `fresh`/print/visit determines pre/in/post-order"
> - **Codec** = encode + decode satisfy `decode . encode = id`
> - **ADT translation** = per-ctor rewrite, share subtrees with `let`/`where`
> - **Lazy memoisation** = route every recursive call through one shared lazy table

## Files

| File | What it covers |
|------|----------------|
| [list-recursion.md](list-recursion.md) | `f [] = b ; f (x:xs) = …` — most fundamental pattern |
| [tree-recursion.md](tree-recursion.md) | Per-constructor recursion on ADTs |
| [monadic-recursion.md](monadic-recursion.md) | Recursion inside `do`-blocks |
| [folds.md](folds.md) | `foldr` / `foldl` recipes |
| [traversals.md](traversals.md) | in-/pre-/post-order, BFS, labelling |
| [accumulator.md](accumulator.md) | `go` helper for O(n) |
| [map-mapM-traverse.md](map-mapM-traverse.md) | When to use which |
| [codec-pair.md](codec-pair.md) | encode/decode round-trip law |
| [adt-to-adt-translation.md](adt-to-adt-translation.md) | Per-ctor structural rewrite |
| [lazy-memoization.md](lazy-memoization.md) | `fix` + infinite trees |
| [triggers.md](triggers.md) | "If you see X → think Y" (older, see [if-you-see-x.md](../if-you-see-x.md) for newer) |
| [pitfalls.md](pitfalls.md) | Older pitfalls list — see [common-pitfalls.md](../common-pitfalls.md) for the master |

## Related directories
- [templates/](../templates/) — fully-formed copy-paste skeletons (more concrete than patterns)
- [archetypes/](../archetypes/) — exam-question shapes (more abstract than patterns)
- [examples/](../examples/) — worked solutions applying patterns
