# Archetype Priority Ranking

[← INDEX](../INDEX.md) · [↑ Archetypes](README.md) · [NAVIGATION](../NAVIGATION.md)

Composite score: F(req) × D(iff) × C(onceptual) × E(xam-likelihood). H/M/L.

## Tier 1 — almost certainly tested
| # | Archetype                                  | F | D | C | E | ⭐ |
|---|--------------------------------------------|---|---|---|---|---|
| [01](01-tree-recursion.md) | Tree-ADT structural recursion | H | M | H | H | ⭐⭐⭐⭐⭐ |
| [02](02-state-game.md)     | State monad game/sim           | H | M | H | H | ⭐⭐⭐⭐⭐ |
| [03](03-generic-monad.md)  | Generic `Monad m =>`           | M | H | H | H | ⭐⭐⭐⭐ |
| [04](04-matrix.md)         | Matrix predicate (transpose)   | M | L | M | H | ⭐⭐⭐⭐ |
| [05](05-adt-translation.md)| ADT-to-ADT translation         | M | M | H | H | ⭐⭐⭐⭐ |
| [06](06-functor-instance.md)| Functor/Applicative/Monad inst | M | M | H | H | ⭐⭐⭐⭐ |
| [08](08-env-eval.md)       | Environment evaluator          | M | M | H | H | ⭐⭐⭐⭐ |

## Tier 2 — very likely
| # | Archetype                                  | F | D | C | E | ⭐ |
|---|--------------------------------------------|---|---|---|---|---|
| [07](07-codec.md)          | Codec pair (encode/decode)     | M | M | H | M | ⭐⭐⭐ |
| [09](09-prelude-reimpl.md) | Reimplement Prelude (recursion)| H | L | M | M | ⭐⭐⭐ |
| [10](10-fold.md)           | Fold reformulation             | M | L | H | M | ⭐⭐⭐ |
| [11](11-bst.md)            | BST operations                 | M | M | M | M | ⭐⭐⭐ |
| [14](14-multi-effect.md)   | Multi-effect interpreter       | L | M | H | M | ⭐⭐⭐ |
| [19](19-extend-interp.md)  | Extend an interpreter          | L | M | H | M | ⭐⭐⭐ |

## Tier 3 — possible
| # | Archetype                                  | F | D | C | E | ⭐ |
|---|--------------------------------------------|---|---|---|---|---|
| [12](12-rep-conv.md)       | Representation conversion      | L | M | M | M | ⭐⭐ |
| [13](13-pretty-print.md)   | Custom Show pretty-printer     | L | M | L | M | ⭐⭐ |
| [15](15-writer-trace.md)   | Writer trace                   | L | L | M | M | ⭐⭐ |
| [16](16-parser.md)         | Parser combinators             | L | H | H | L | ⭐⭐ |
| [18](18-memo.md)           | Lazy memoization               | L | H | H | L | ⭐⭐ |

## Tier 4 — low probability
| # | Archetype                                  | F | D | C | E | ⭐ |
|---|--------------------------------------------|---|---|---|---|---|
| [17](17-zipper.md)         | Zipper navigation              | L | M | M | L | ⭐ |
| [20](20-laws.md)           | Iso / retract / laws (theory)  | L | M | M | L | ⭐ |

## Likely 5-question exam composition
Based on Mock = (Rose-rec, generic Monad, State-game, matrix-predicate, ADT-translation):
- Q1: [#01](01-tree-recursion.md) (BT or Rose; 2 sub-parts e.g. predicate + transform)
- Q2: [#03](03-generic-monad.md) (Monad m => combinator with intermediate-collection)
- Q3: [#02](02-state-game.md) (gameOver + makeMove)
- Q4: [#04](04-matrix.md) OR [#08](08-env-eval.md)
- Q5: [#05](05-adt-translation.md) OR [#06](06-functor-instance.md)

## Combination hot spots
- #1 + #2 → state traversal of tree (label every node)
- #1 + #3 → mapM-on-tree
- #1 + #6 → Functor instance for custom tree
- #1 + #5 → translate tree shape to another
- #1 + #8 → eval AST under Env
- #2 + #14 → calculator with state + error
- #5 + #8 → desugar then eval pipeline
- #7 + #1 → tree-based codec (Morse Tree decode)

## See also
[INDEX](../INDEX.md) · [Triggers](../patterns/triggers.md)
