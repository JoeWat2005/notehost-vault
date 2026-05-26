# If You See X → Think Y

[← INDEX](INDEX.md) · [NAVIGATION](NAVIGATION.md)

Scan question text for these phrases → jump to the right template.

> **How to use this page**: don't read top-to-bottom — `Ctrl+F` the keyword from the question. Each row says "if your question contains *this*, your answer uses *that*."

## Quick lookup — RECURSION
| Phrase in question                          | Pattern → template              |
|---------------------------------------------|--------------------------------|
| "implement my…" / "without using foo"       | cons recursion · [Common Templates](common-templates.md) #1.1 |
| "for each element"                          | cons recursion / map           |
| "efficient" / "single pass" / "O(n)"        | accumulator `go`               |
| "consecutive" / "adjacent" / "alternating"  | look-ahead `(x:y:xs)`          |
| "merge sorted lists"                        | dual-empty + Ord guard         |
| "first n" / "drop n" / "n times"            | count-decrement recursion      |
| "binary tree"                               | `data BT = Empty \| Fork …`    |
| "rose tree" / "any number of children"      | `data Rose = Leaf \| Branch [..]` |
| "in-/pre-/post-order"                       | flatten variant                |
| "without recursion"                         | foldr / foldl                  |

## MONADS
| Phrase                                      | Monad                          |
|---------------------------------------------|--------------------------------|
| "may fail" / "return Nothing if"            | `Maybe`                        |
| "fail with error message" / "throw error"   | `Either e` / `MonadError`      |
| "hidden / mutable / track state"            | `State s`                      |
| "accumulate logs" / "trace"                 | `Writer [String]`              |
| "running total alongside" / "metric"        | `Writer (Sum Int)`             |
| "interactive" / "main" / "side effect"      | `IO`                           |
| "non-determinism" / "all possible" / "search"| `[]` (list monad)             |
| "read-only env" / "configuration"           | `Reader r`                     |
| "Monad m =>"                                | generic combinator             |
| "state + error" / "calculator with /0"      | `(MonadState, MonadError)`     |
| "DSL of computation, re-interpret"          | `Free f`                       |

## TYPECLASSES
| Phrase                                      | Class                          |
|---------------------------------------------|--------------------------------|
| "preserve structure, transform values"      | `Functor` / `fmap`             |
| "apply wrapped fn to wrapped val"           | `Applicative` / `<*>`          |
| "chain dependent contexted comp"            | `Monad` / `>>=` / do           |
| "alternative / fallback"                    | `Alternative` / `<\|>`          |
| "custom equality / ordering"                | `Eq` / `Ord` / `compare`       |
| "integer literals over my type"             | `Num` / `fromInteger`          |
| "pretty print"                              | `Show` instance                |
| "auto-derived"                              | `deriving (Show, Eq, Ord, …)`  |

## INTERPRETERS / EVAL
| Phrase                                      | Template                       |
|---------------------------------------------|--------------------------------|
| "evaluate expression"                       | per-ctor case-fold             |
| "variables / let / environment"             | `Env -> Expr -> Maybe Value`   |
| "boolean AND integer expressions"           | typed `Value = BVal \| IVal`   |
| "throw error" + "interpreter"               | `MonadError String m`          |
| "While / If / Block / assignment :="        | `Program -> Storage -> Storage`|
| "execute commands in sequence"              | State dispatch                 |
| "translate Expr to Circuit"                 | per-ctor structural rewrite    |
| "remove Implies / normalize"                | per-ctor recursive rewrite     |
| "extend the interpreter"                    | 3-layer change (AST+parser+eval) |

## PARSERS
| Phrase                                      | Combinator                     |
|---------------------------------------------|--------------------------------|
| "parse a string into …"                     | `Parser a` combinators         |
| "BNF / grammar"                             | recursive descent              |
| "precedence"                                | stratified `expr`/`term`/`factor` |
| "zero or more"                              | `many`                         |
| "one or more"                               | `some`                         |
| "optional whitespace"                       | `token` / `space`              |
| "balanced brackets"                         | recursive parser w/ `<\|>`      |

## TRAVERSALS / TREES
| Phrase                                      | Template                       |
|---------------------------------------------|--------------------------------|
| "label every node with index"               | State traversal (fresh)        |
| "print every node"                          | `mapM_`                        |
| "preserve shape with effect at every node"  | `mapM` ([mapM](mapm.md))           |
| "all paths / addresses"                     | address enumeration            |
| "BST valid"                                 | bound-threaded recursion       |
| "BST insert / delete"                       | 3-way Ord guard / 4-case       |
| "mirror / flip"                             | swap l/r in recursion          |
| "isNBranching" / "prune"                    | Rose validator / transform     |
| "count / size / height / leaves"            | tree fold T2.1                 |

## LAZY / INFINITE
| Phrase                                      | Template                       |
|---------------------------------------------|--------------------------------|
| "infinite list"                             | `xs = e` corecursive          |
| "ones, fibs, primes"                        | knot-tying                     |
| "exponential → fast"                        | memoise via fix                |
| "doesn't loop on infinite input"            | lazy `Nat = Zero \| Succ Nat`  |
| "sieve"                                     | recursive filter on stream     |

## ADTs
| Phrase                                      | ADT                            |
|---------------------------------------------|--------------------------------|
| "value or absent"                           | `Maybe a`                      |
| "error-message-or-value"                    | `Either String a`              |
| "function as data"                          | `String -> Maybe v` etc.       |
| "focus + context for navigation"            | zipper newtype                 |
| "two equivalent reps"                       | conversion fns                 |
| "encode/decode"                             | codec pair                     |

## META (type-sig only, no English clue)
| Signature shape                             | Template                       |
|---------------------------------------------|--------------------------------|
| `Monad m => … -> m …`                       | generic combinator             |
| `Ord a => …`                                | sort / compare / BST           |
| `Tree -> X`                                 | structural recursion           |
| `[[Int]] -> Bool`                           | matrix predicate via transpose |
| `f a -> f b` w/ class                       | Functor / fmap                 |
| 4-fn spec "L/R/U/D"                         | write all 4, symmetric         |
| `Expr -> Circuit` / `Logic -> Logic`        | ADT-to-ADT translation         |
| `Env -> Expr -> Maybe Value`                | environment evaluator          |

## See also
[Common Templates](common-templates.md) · [Type Signature Decoder](type-signature-decoder.md) · [Common Pitfalls](common-pitfalls.md)
