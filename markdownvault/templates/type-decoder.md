# Template — Type-signature decoder

[← INDEX](../INDEX.md) · [↑ Templates](README.md) · [NAVIGATION](../NAVIGATION.md)

Recognise type shapes instantly during exam.

> See the newer [type-signature-decoder](../type-signature-decoder.md) for a more complete master version.

## Pure list shapes
| Shape                              | Likely template                     |
|------------------------------------|-------------------------------------|
| `[a] -> Int`                       | cons recursion → Int                |
| `Num a => [a] -> a`                | sum/product via foldr               |
| `[a] -> [a]`                       | cons recursion rebuild              |
| `Eq a => [a] -> [a]`               | dedupe / compare-driven             |
| `Ord a => [a] -> [a]`              | sort                                |
| `Ord a => [a] -> Bool`             | isSorted                            |
| `Int -> [a] -> [a]`                | take / drop                         |
| `[a] -> [b] -> [(a, b)]`           | zip                                 |
| `(a -> b) -> [a] -> [b]`           | map                                 |
| `(a -> Bool) -> [a] -> [a]`        | filter                              |
| `(a -> b -> b) -> b -> [a] -> b`   | foldr                               |

## Maybe shapes
| Shape                              | Likely template                     |
|------------------------------------|-------------------------------------|
| `[a] -> Maybe a`                   | safeHead                            |
| `Int -> Int -> Maybe Int`          | safeDivide                          |
| `Eq a => a -> [(a,b)] -> Maybe b`  | lookup                              |
| `[Maybe a] -> [a]`                 | catMaybes                           |
| `(a -> Maybe b) -> [a] -> [b]`     | mapMaybe                            |

## Tree shapes
| Shape                              | Likely template                     |
|------------------------------------|-------------------------------------|
| `Tree -> Int`                      | size / height / count               |
| `Tree -> [a]`                      | flatten                             |
| `Tree -> Tree`                     | mirror / transform                  |
| `(a -> b) -> T a -> T b`           | mapT or Functor instance            |
| `Ord a => BT a -> Bool`            | isBST (bound-threaded)              |
| `Ord a => a -> BT a -> BT a`       | insert/delete BST                   |
| `Int -> Rose a -> Bool`            | isNBranching                        |
| `Int -> Rose a -> Rose a`          | prune                               |

## Monad shapes
| Shape                                                          | Likely template          |
|----------------------------------------------------------------|--------------------------|
| `Monad m => m a -> (a -> m a) -> Int -> m [a]`                 | applyNTimes              |
| `Monad m => (a -> m b) -> [a] -> m [b]`                        | mapM                     |
| `Monad m => [m a] -> m [a]`                                    | sequence                 |
| `State s a` returning Bool / ()                                | game predicate / mutator |
| `Env -> Expr -> Maybe Value`                                   | env evaluator            |
| `MonadError String m => Expr -> m Int`                         | eval with error          |
| `(MonadState s m, MonadError e m) => Cmd -> m ()`              | multi-effect interpreter |
| `Writer [String] ()`                                           | trace                    |

## ADT-to-ADT shapes
| Shape                              | Likely template                     |
|------------------------------------|-------------------------------------|
| `Expr -> Circuit`                  | per-ctor rewrite (Mock Q5)          |
| `Logic -> Logic`                   | normalisation (removeImplies)       |
| `Table -> Tree`                    | ramify (codec)                      |
| `Tree -> Table`                    | tabulate (codec)                    |

## Misc
| Shape                              | Likely template                     |
|------------------------------------|-------------------------------------|
| `[[Int]] -> Bool`                  | matrix predicate via transpose      |
| `Grid -> Maybe Player`             | TTT winner                          |
| `(a -> a) -> a`                    | fix combinator                      |
| `[Int]` / `[Integer]` (no input)   | corecursive infinite list           |

## See also
[INDEX](../INDEX.md) · [Triggers](../patterns/triggers.md) · [Priority](../archetypes/00-priority.md)
