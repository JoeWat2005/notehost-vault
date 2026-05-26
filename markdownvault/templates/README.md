# templates/ — Copy-paste code skeletons

→ [← INDEX](../INDEX.md) · [NAVIGATION](../NAVIGATION.md)

Pure copy-paste-and-adapt code. Open the file, copy the template, change names, fill in your specific cases.

> Each template now starts with a one-line "what this pattern is doing" so you can see the *idea* before the code, and includes type signatures on every example.

## Files

| File | Skeleton for |
|------|--------------|
| [list-cons.md](list-cons.md) | `f [] = b ; f (x:xs) = …` |
| [list-accumulator.md](list-accumulator.md) | `go` helper for O(n) |
| [tree-bt.md](tree-bt.md) | Binary tree (BT) operations |
| [tree-rose.md](tree-rose.md) | Rose tree operations |
| [mapM-tree.md](mapM-tree.md) | Monadic traversal preserving shape |
| [state-fresh.md](state-fresh.md) | State counter / labelling |
| [state-game.md](state-game.md) | State monad game (Nim-style) |
| [writer-trace.md](writer-trace.md) | Writer logging traversal |
| [functor-instance.md](functor-instance.md) | `instance Functor T` skeletons |
| [monad-instance.md](monad-instance.md) | Functor + Applicative + Monad triple |
| [parser-newtype.md](parser-newtype.md) | `newtype Parser` + primitives + grammar |
| [adt-declarations.md](adt-declarations.md) | Common `data` declarations |
| [type-decoder.md](type-decoder.md) | Type sig → template lookup (older — see [../type-signature-decoder.md](../type-signature-decoder.md)) |

## The one-file alternative
[../common-templates.md](../common-templates.md) has all 20 skeletons in a single file. Use that for fast scanning; use individual files for deeper context (variations + pitfalls).

## Related
- [../patterns/](../patterns/) — conceptual patterns these templates implement
- [../examples/](../examples/) — worked solutions applying these templates
