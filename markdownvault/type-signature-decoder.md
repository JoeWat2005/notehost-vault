# Type Signature Decoder

[← INDEX](INDEX.md) · [NAVIGATION](NAVIGATION.md)

Sig shape → which template to copy. Search by signature pattern.

> **Mental model:** the type signature usually *gives away* the implementation. `[a] -> [a]` is almost always a list rebuild. `Monad m => …` means you'll be in a `do`-block. `[[Int]] -> Bool` screams "transpose + diagonals". Read the type first, then look up the row.

## Pure list shapes
| Signature                          | Template                            |
|------------------------------------|-------------------------------------|
| `[a] -> Int`                       | cons recursion (length-style)       |
| `Num a => [a] -> a`                | sum/product via foldr               |
| `[a] -> [a]`                       | cons rebuild / reverse              |
| `Eq a => [a] -> [a]`               | dedupe / compress                   |
| `Ord a => [a] -> [a]`              | sort / msort / qsort                |
| `Ord a => [a] -> Bool`             | isSorted (look-ahead)               |
| `Ord a => [a] -> a`                | minimum / maximum                   |
| `Eq a => a -> [a] -> Bool`         | myElem (cons + ‖)                   |
| `Eq a => a -> [a] -> Int`          | count occurrences                   |
| `Eq a => a -> [a] -> [Int]`        | positions (zip with index)          |
| `Eq a => a -> [(a,b)] -> Maybe b`  | lookup                              |
| `Int -> [a] -> [a]`                | take / drop (count-decrement)       |
| `Int -> a -> [a]`                  | replicate                           |
| `[a] -> a`                         | head / last (partial)               |
| `[a] -> [a] -> [a]`                | merge / interleave / (++)           |
| `[a] -> [b] -> [(a,b)]`            | zip                                 |
| `Num a => [a] -> [a] -> a`         | dot product (zip + sum)             |
| `[[a]] -> [a]`                     | concat                              |
| `[[a]] -> [[a]]`                   | transpose / clean rows              |
| `[[Int]] -> Bool`                  | matrix predicate via transpose      |

## HOF shapes
| Signature                          | Template                            |
|------------------------------------|-------------------------------------|
| `(a -> b) -> [a] -> [b]`           | map                                 |
| `(a -> Bool) -> [a] -> [a]`        | filter                              |
| `(a -> b -> b) -> b -> [a] -> b`   | foldr                               |
| `(a -> Bool) -> [a] -> Bool`       | all / any                           |
| `(a -> Bool) -> [a] -> ([a], [a])` | partition / span                    |
| `[a -> a] -> (a -> a)`             | compose list of fns                 |
| `(a -> a) -> a -> [a]`             | iterate (infinite)                  |
| `(a -> a) -> a -> a`               | twice / fix                         |
| `(a -> b -> c) -> [a] -> [b] -> [c]` | zipWith                           |

## Maybe / Either shapes
| Signature                          | Template                            |
|------------------------------------|-------------------------------------|
| `[a] -> Maybe a`                   | safeHead                            |
| `Int -> Int -> Maybe Int`          | safeDivide                          |
| `Double -> Maybe Double`           | safeReciprocal                      |
| `[a] -> Int -> Maybe a`            | safeIndex                           |
| `[Maybe a] -> Maybe a`             | firstJust                           |
| `[Maybe a] -> [a]`                 | catMaybes (pattern split)           |
| `(a -> Maybe b) -> [a] -> [b]`     | mapMaybe                            |
| `[a] -> [b] -> Either String [(a,b)]`| zipEither                         |
| `Char -> Maybe Int`                | parseDigit                          |

## Tree shapes
| Signature                          | Template                            |
|------------------------------------|-------------------------------------|
| `BT a -> Int`                      | size / height / count               |
| `BT a -> [a]`                      | flatten (in-order)                  |
| `BT a -> BT a`                     | mirror / increment                  |
| `(a -> b) -> BT a -> BT b`         | mapBT / Functor                     |
| `Num a => BT a -> a`               | sumBT                               |
| `Ord a => BT a -> Bool`            | isBST (bound-threaded)              |
| `Ord a => a -> BT a -> BT a`       | insertBST / deleteBST               |
| `Ord a => a -> BT a -> Bool`       | memberBST                           |
| `Ord a => [a] -> BT a`             | foldr insertBST                     |
| `Ord a => BT a -> Maybe a`         | safe maxBT                          |
| `Eq a => a -> BT a -> Int`         | countBT                             |
| `Rose a -> Int`                    | sizeR / heightR                     |
| `Rose a -> [a]`                    | flattenR                            |
| `Int -> Rose a -> Bool`            | isNBranching                        |
| `Int -> Rose a -> Rose a`          | prune                               |
| `Expr -> Int`                      | evaluator                           |
| `Expr -> Circuit`                  | per-ctor rewrite (Mock Q5)          |
| `Env -> Expr -> Maybe Int`         | env-eval                            |
| `Env -> Expr -> Maybe Value`       | typed eval (BVal/IVal)              |

## Monad shapes
| Signature                                                          | Template          |
|--------------------------------------------------------------------|-------------------|
| `Monad m => m a -> (a -> m a) -> Int -> m [a]`                     | applyNTimes (Mock Q2) |
| `Monad m => (a -> m b) -> [a] -> m [b]`                            | mapM              |
| `Monad m => [m a] -> m [a]`                                        | sequence          |
| `Monad m => Int -> m a -> m [a]`                                   | replicateM        |
| `Monad m => m (m a) -> m a`                                        | join              |
| `Applicative f => (a -> b -> c) -> f a -> f b -> f c`              | liftA2            |
| `Monad m => (a -> m b) -> BT a -> m (BT b)`                        | mapMTree          |

## State monad shapes
| Signature                          | Template                            |
|------------------------------------|-------------------------------------|
| `State Int Int`                    | fresh                               |
| `State s s`                        | get                                 |
| `s -> State s ()`                  | put                                 |
| `(s -> s) -> State s ()`           | modify                              |
| `BT a -> BT (Int, a)`              | labelTree (in-order with State)     |
| `BT a -> State Int ()`             | tree walker                         |
| `[a] -> State [a] ()`              | pushAll                             |
| `Int -> State Int Int`             | poll-until                          |
| `[Cmd] -> State [Int] ()`          | stack-calc interpreter              |
| `Ord a => [a] -> [(a, Int)]`       | frequency (group . sort)            |

## Game / specific
| Signature                          | Template                            |
|------------------------------------|-------------------------------------|
| `State (Int, Int) Bool`            | NimGame gameOver                    |
| `Int -> Heap -> State (Int, Int) ()`| takeTokens                         |
| `Grid -> Maybe Player`             | TTT winner                          |

## Writer shapes
| Signature                          | Template                            |
|------------------------------------|-------------------------------------|
| `Writer [String] ()`               | trace                               |
| `Int -> Writer [String] Int`       | with-log                            |
| `Int -> Writer (Sum Int) Int`      | with-metric                         |
| `Dir -> Writer [String] ()`        | logTraverse                         |

## Error shapes
| Signature                          | Template                            |
|------------------------------------|-------------------------------------|
| `MonadError String m => Expr -> m Int` | evalCalc                        |
| `(MonadState s m, MonadError e m) => Cmd -> m ()` | runCalc              |

## Parser shapes
| Signature                          | Template                            |
|------------------------------------|-------------------------------------|
| `Parser Char`                      | item / sat / digit / lower          |
| `(Char -> Bool) -> Parser Char`    | sat                                 |
| `Parser a -> Parser [a]`           | many / some                         |
| `Parser Int`                       | nat / natural                       |
| `Parser a -> Parser a`             | token                               |
| `String -> Parser String`          | symbol                              |
| `Parser Int` (recursive)           | expr / term / factor                |

## Misc / advanced
| Signature                          | Template                            |
|------------------------------------|-------------------------------------|
| `(a -> a) -> a`                    | fix combinator                      |
| `(Integer -> a) -> BT a`           | tstore (infinite memo tree)         |
| `BT a -> Integer -> a`             | tfetch                              |
| `[Int]` / `[Integer]` (no input)   | corecursive infinite list           |
| `Table -> Tree` / `Tree -> Table`  | ramify / tabulate (codec)           |
| `Eq a => [a] -> [(a, Int)]`        | rle                                 |
| `[(a, Int)] -> [a]`                | rld                                 |

## Class instance heads
| Head                               | What to write                        |
|------------------------------------|-------------------------------------|
| `instance Functor T where fmap`    | walk every ctor; apply f to a-slots |
| `instance Applicative T where pure, <*>` | minimal effect / sequence    |
| `instance Monad T where return, >>=`| short-circuit / fan-out / thread   |
| `instance Show T where show`       | string concat per ctor              |
| `instance Eq a => Eq (T a)`        | recurse on structure (constraint)   |

## See also
[If You See X](if-you-see-x.md) · [Common Templates](common-templates.md) · [Functor](functor.md)
