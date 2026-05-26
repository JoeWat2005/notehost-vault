# Triggers — "If you see X → think Y"

[← INDEX](../INDEX.md) · [↑ Patterns](README.md) · [NAVIGATION](../NAVIGATION.md)

Scan question text for these phrases; jump to the right pattern instantly.

> See also the newer [if-you-see-x](../if-you-see-x.md) for a tabular, faster lookup of the same idea.

## Recursion
- "for each element" / "implement my…" → [List Recursion](list-recursion.md)
- "efficient" / "single pass" / "O(n)" → [Accumulator](accumulator.md)
- "consecutive" / "adjacent pair" → look-ahead `(x:y:xs)` [List Recursion](list-recursion.md)
- "merge sorted lists" → dual-empty + Ord guard
- "binary tree" → [Tree Recursion](tree-recursion.md) (BT)
- "any number of children" / "rose tree" → Rose
- "in-/pre-/post-order" → [Traversals](traversals.md)

## Folds
- "using foldr" / "as a fold" → [Folds](folds.md)
- "without recursion" → fold or HOF
- "build up left-to-right" → foldl

## Monads
- "may fail" / "return Nothing" → [Maybe](../monads/maybe.md)
- "fail with error message" → [Either](../monads/either.md) / [Monaderror](../monads/monaderror.md)
- "hidden / mutable state" → [State](../monads/state.md)
- "accumulate logs" / "trace" → [Writer](../monads/writer.md)
- "interactive" / "main" → [IO](../monads/io.md)
- "non-determinism" / "search" → [List Monad](../monads/list-monad.md)
- "Monad m =>" → [Generic Monad](../archetypes/03-generic-monad.md)
- "state + error" → [Multi Effect](../monads/multi-effect.md)
- "DSL of computation, re-interpret" → Free monad

## Typeclasses
- "preserve structure, transform values" → [Functor](../typeclasses/functor.md)
- "apply wrapped fn to wrapped val" → [Applicative](../typeclasses/applicative.md)
- "chain dependent contexted comp" → [Monad](../typeclasses/monad.md)
- "alternative / fallback" → [Alternative](../typeclasses/alternative.md)
- "custom equality / ordering" → [Eq Ord Num](../typeclasses/eq-ord-num.md)
- "integer literals over my type" → Num via `fromInteger`
- "pretty print" → [Pretty Print](../archetypes/13-pretty-print.md)

## Interpreters
- "evaluate expression" → [Simple Eval](../interpreters/simple-eval.md)
- "variables / environment / let" → [Env Eval](../interpreters/env-eval.md)
- "throw error with message" → [Monaderror Eval](../interpreters/monaderror-eval.md)
- "boolean AND integer expressions" → typed Value `BVal/IVal`
- "While / If / assignment :=" → [Imperative Storage](../interpreters/imperative-storage.md)
- "execute commands in sequence" → State dispatch

## Parsers
- "parse a string into …" → [Parser](../archetypes/16-parser.md)
- "BNF / grammar" → recursive descent
- "precedence" → stratified `expr / term / factor`
- "zero or more" → `many`; "one or more" → `some`
- "balanced brackets" → recursive parser w/ `<|>`

## Traversals
- "label every node with index" → State traversal
- "print every node" → `mapM_`
- "preserve shape with effect at every node" → `mapM` ([Map mapM Traverse](map-mapM-traverse.md))
- "all paths / addresses" → address enumeration

## Tree processing
- "BST valid" → bound-threaded recursion
- "BST insert / delete" → 3-way Ord / 4-case
- "mirror / flip" → swap l/r in recursion
- "isNBranching" / "prune" → Rose validator/transform
- "Functor instance for tree" → mirror mapBT/mapRose

## Lazy evaluation
- "infinite list" → corecursive self-reference
- "ones, fibs, primes" → knot-tying
- "exponential → fast" → memoise via fix
- "doesn't loop on infinite input" → lazy Nat / short-circuit
- "sieve" → recursive filter on stream

## ADTs
- "value or absent" → `Maybe a`
- "error-with-message-or-value" → `Either String a`
- "function as data" → `type Env = String -> Maybe v`
- "focus + context for navigation" → zipper newtype
- "two equivalent reps" → conversion fns ([Rep Conv](../archetypes/12-rep-conv.md))
- "encode/decode" → codec pair ([Codec](../archetypes/07-codec.md))

## Meta — when unsure
- type sig `Monad m =>` → generic combinator
- type sig `Ord a =>` → sorting / compare
- sig `Tree -> X` → structural recursion
- sig `[[Int]] -> Bool` → matrix predicate via transpose
- sig `f a -> f b` w/ class → Functor / fmap
- 4-fn spec "L/R/U/D" → write all 4, symmetric (A1)

## See also
[INDEX](../INDEX.md) · [Pitfalls](pitfalls.md) · [Priority](../archetypes/00-priority.md)
