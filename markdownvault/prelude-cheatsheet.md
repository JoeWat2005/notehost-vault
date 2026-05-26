# Prelude + Control.Monad — Built-in Function Cheatsheet

[← INDEX](INDEX.md) · [NAVIGATION](NAVIGATION.md)

Every Prelude / Data.List / Data.Char / Control.Monad function you can use in the exam (no imports needed beyond what's already provided).

> **How to use this file:** `Ctrl+F` the function name when you can't quite remember its type. Functions marked "partial" crash on bad input — handle the empty/Nothing case yourself.

## 1. NUMERIC

```haskell
(+), (-), (*) :: Num a => a -> a -> a
negate, abs, signum :: Num a => a -> a
fromInteger   :: Num a => Integer -> a
fromIntegral  :: (Integral a, Num b) => a -> b   -- convert Int → Float etc.

div, mod      :: Integral a => a -> a -> a       -- truncated, mathematical
quot, rem     :: Integral a => a -> a -> a       -- truncated, towards zero
divMod, quotRem :: Integral a => a -> a -> (a, a)
even, odd     :: Integral a => a -> Bool
gcd, lcm      :: Integral a => a -> a -> a
toInteger     :: Integral a => a -> Integer

(/), recip    :: Fractional a => a -> a -> a
(^)           :: (Num a, Integral b) => a -> b -> a    -- non-negative int exp
(^^)          :: (Fractional a, Integral b) => a -> b -> a
(**)          :: Floating a => a -> a -> a              -- general exp
sqrt, exp, log :: Floating a => a -> a
sin, cos, tan, pi :: Floating a => …
floor, ceiling, round, truncate :: (RealFrac a, Integral b) => a -> b
```

## 2. COMPARISON / BOOLEAN

```haskell
(==), (/=)    :: Eq a => a -> a -> Bool
(<), (<=), (>=), (>) :: Ord a => a -> a -> Bool
compare       :: Ord a => a -> a -> Ordering   -- LT | EQ | GT
min, max      :: Ord a => a -> a -> a

(&&), (||)    :: Bool -> Bool -> Bool
not           :: Bool -> Bool
otherwise     :: Bool                          -- = True (for guards)
```

## 3. LIST CORE

```haskell
(:)           :: a -> [a] -> [a]
(++)          :: [a] -> [a] -> [a]
head, last    :: [a] -> a                      -- partial
tail, init    :: [a] -> [a]                    -- partial
null          :: [a] -> Bool
length        :: [a] -> Int
reverse       :: [a] -> [a]
(!!)          :: [a] -> Int -> a                -- partial
```

## 4. LIST TAKE / DROP / SPLIT

```haskell
take, drop    :: Int -> [a] -> [a]              -- lazy in list
splitAt       :: Int -> [a] -> ([a], [a])

takeWhile     :: (a -> Bool) -> [a] -> [a]
dropWhile     :: (a -> Bool) -> [a] -> [a]
span          :: (a -> Bool) -> [a] -> ([a], [a])     -- takeWhile + dropWhile
break         :: (a -> Bool) -> [a] -> ([a], [a])     -- span . not

replicate     :: Int -> a -> [a]
repeat        :: a -> [a]                       -- INFINITE
cycle         :: [a] -> [a]                     -- INFINITE
iterate       :: (a -> a) -> a -> [a]           -- INFINITE
```

## 5. LIST AGGREGATE / SEARCH

```haskell
sum, product  :: Num a => [a] -> a
maximum, minimum :: Ord a => [a] -> a           -- partial on []

all           :: (a -> Bool) -> [a] -> Bool
any           :: (a -> Bool) -> [a] -> Bool
and, or       :: [Bool] -> Bool

elem, notElem :: Eq a => a -> [a] -> Bool       -- O(n)
lookup        :: Eq a => a -> [(a, b)] -> Maybe b
```

## 6. LIST HIGHER-ORDER

```haskell
map           :: (a -> b) -> [a] -> [b]
filter        :: (a -> Bool) -> [a] -> [a]
foldr         :: (a -> b -> b) -> b -> [a] -> b
foldl         :: (b -> a -> b) -> b -> [a] -> b
foldr1, foldl1 :: (a -> a -> a) -> [a] -> a     -- partial on []
scanl, scanr  :: (a -> b -> a) -> a -> [b] -> [a]    -- intermediate fold results

concat        :: [[a]] -> [a]
concatMap     :: (a -> [b]) -> [a] -> [b]
```

## 7. ZIP

```haskell
zip           :: [a] -> [b] -> [(a, b)]
zip3          :: [a] -> [b] -> [c] -> [(a, b, c)]
zipWith       :: (a -> b -> c) -> [a] -> [b] -> [c]
zipWith3      :: (a -> b -> c -> d) -> [a] -> [b] -> [c] -> [d]
unzip         :: [(a, b)] -> ([a], [b])
unzip3        :: [(a, b, c)] -> ([a], [b], [c])
```

## 8. STRING (= [Char])

```haskell
lines         :: String -> [String]             -- split on '\n'
unlines       :: [String] -> String             -- join with '\n'
words         :: String -> [String]             -- split on whitespace
unwords       :: [String] -> String             -- join with ' '
show          :: Show a => a -> String
read          :: Read a => String -> a          -- partial
```

## 9. TUPLE

```haskell
fst           :: (a, b) -> a
snd           :: (a, b) -> b
curry         :: ((a, b) -> c) -> a -> b -> c
uncurry       :: (a -> b -> c) -> (a, b) -> c
```

## 10. FUNCTION

```haskell
id            :: a -> a
const         :: a -> b -> a                    -- ignore second arg
flip          :: (a -> b -> c) -> b -> a -> c
(.)           :: (b -> c) -> (a -> b) -> a -> c
($)           :: (a -> b) -> a -> b             -- low-precedence apply
seq           :: a -> b -> b                    -- force first arg, return second
asTypeOf      :: a -> a -> a                    -- = const
until         :: (a -> Bool) -> (a -> a) -> a -> a
```

## 11. MAYBE / EITHER ELIMINATORS

```haskell
maybe         :: b -> (a -> b) -> Maybe a -> b
fromMaybe     :: a -> Maybe a -> a              -- from Data.Maybe
either        :: (a -> c) -> (b -> c) -> Either a b -> c
catMaybes     :: [Maybe a] -> [a]               -- from Data.Maybe
mapMaybe      :: (a -> Maybe b) -> [a] -> [b]   -- from Data.Maybe
isJust        :: Maybe a -> Bool
isNothing     :: Maybe a -> Bool
fromJust      :: Maybe a -> a                   -- partial!
```

## 12. IO

```haskell
putStr        :: String -> IO ()
putStrLn      :: String -> IO ()
putChar       :: Char -> IO ()
print         :: Show a => a -> IO ()           -- = putStrLn . show

getLine       :: IO String
getChar       :: IO Char
getContents   :: IO String                      -- LAZY whole input
readLn        :: Read a => IO a

interact      :: (String -> String) -> IO ()
return        :: a -> IO a                      -- generally Monad m => a -> m a
```

## 13. Data.Char (allowed import)

```haskell
isDigit, isAlpha, isAlphaNum, isSpace :: Char -> Bool
isUpper, isLower, isPunctuation       :: Char -> Bool
toUpper, toLower                      :: Char -> Char
ord                                   :: Char -> Int     -- ASCII
chr                                   :: Int -> Char
digitToInt                            :: Char -> Int     -- '5' → 5; partial
intToDigit                            :: Int -> Char     -- 5 → '5'; partial
```

## 14. Data.List (allowed import)

```haskell
sort          :: Ord a => [a] -> [a]
sortBy        :: (a -> a -> Ordering) -> [a] -> [a]
sortOn        :: Ord b => (a -> b) -> [a] -> [a]

group         :: Eq a => [a] -> [[a]]              -- consecutive equal runs
groupBy       :: (a -> a -> Bool) -> [a] -> [[a]]

nub           :: Eq a => [a] -> [a]                -- remove duplicates (O n²)
(\\)          :: Eq a => [a] -> [a] -> [a]         -- list difference
union, intersect :: Eq a => [a] -> [a] -> [a]

intercalate   :: [a] -> [[a]] -> [a]               -- join with separator
intersperse   :: a -> [a] -> [a]                   -- put sep between elems

transpose     :: [[a]] -> [[a]]                    -- rows ↔ columns

isPrefixOf, isSuffixOf, isInfixOf :: Eq a => [a] -> [a] -> Bool
stripPrefix   :: Eq a => [a] -> [a] -> Maybe [a]

find          :: (a -> Bool) -> [a] -> Maybe a
findIndex     :: (a -> Bool) -> [a] -> Maybe Int
elemIndex     :: Eq a => a -> [a] -> Maybe Int
partition     :: (a -> Bool) -> [a] -> ([a], [a])

tails, inits  :: [a] -> [[a]]
permutations  :: [a] -> [[a]]
subsequences  :: [a] -> [[a]]

unfoldr       :: (b -> Maybe (a, b)) -> b -> [a]
```

## 15. Data.Maybe (often pre-imported)

```haskell
maybe         :: b -> (a -> b) -> Maybe a -> b
fromMaybe     :: a -> Maybe a -> a
catMaybes     :: [Maybe a] -> [a]
mapMaybe      :: (a -> Maybe b) -> [a] -> [b]
isJust, isNothing :: Maybe a -> Bool
fromJust      :: Maybe a -> a                   -- partial!
maybeToList   :: Maybe a -> [a]
listToMaybe   :: [a] -> Maybe a
```

## 16. Control.Monad

```haskell
return        :: Monad m => a -> m a
(>>=)         :: Monad m => m a -> (a -> m b) -> m b
(>>)          :: Monad m => m a -> m b -> m b         -- discard first
(<$>)         :: Functor f => (a -> b) -> f a -> f b  -- infix fmap
(<*>)         :: Applicative f => f (a -> b) -> f a -> f b
pure          :: Applicative f => a -> f a

-- Sequencing
mapM          :: Monad m => (a -> m b) -> [a] -> m [b]
mapM_         :: Monad m => (a -> m b) -> [a] -> m ()
sequence      :: Monad m => [m a] -> m [a]
sequence_     :: Monad m => [m a] -> m ()
forM, forM_   :: Monad m => [a] -> (a -> m b) -> m b  -- flipped mapM
replicateM    :: Monad m => Int -> m a -> m [a]
replicateM_   :: Monad m => Int -> m a -> m ()

-- Conditionals
when          :: Applicative f => Bool -> f () -> f ()
unless        :: Applicative f => Bool -> f () -> f ()
guard         :: Alternative f => Bool -> f ()        -- empty if False
void          :: Functor f => f a -> f ()

-- Higher-order monadic
join          :: Monad m => m (m a) -> m a
liftM         :: Monad m => (a -> b) -> m a -> m b    -- = fmap
liftM2        :: Monad m => (a -> b -> c) -> m a -> m b -> m c
ap            :: Monad m => m (a -> b) -> m a -> m b  -- = <*>
forever       :: Applicative f => f a -> f b          -- loop forever
```

## 17. Control.Monad.State (allowed for State problems)

```haskell
import Control.Monad.State

get           :: State s s
put           :: s -> State s ()
modify        :: (s -> s) -> State s ()
gets          :: (s -> a) -> State s a
state         :: (s -> (a, s)) -> State s a            -- general ctor
runState      :: State s a -> s -> (a, s)
evalState     :: State s a -> s -> a
execState     :: State s a -> s -> s
```

## 18. Control.Monad.Writer

```haskell
import Control.Monad.Writer

tell          :: Monoid w => w -> Writer w ()
runWriter     :: Writer w a -> (a, w)
execWriter    :: Writer w a -> w
```

## 19. Control.Monad.Error.Class

```haskell
import Control.Monad.Error.Class

throwError    :: MonadError e m => e -> m a
catchError    :: MonadError e m => m a -> (e -> m a) -> m a
```

## 20. ALTERNATIVE / MonadPlus

```haskell
empty         :: Alternative f => f a
(<|>)         :: Alternative f => f a -> f a -> f a
many          :: Alternative f => f a -> f [a]        -- 0+
some          :: Alternative f => f a -> f [a]        -- 1+
optional      :: Alternative f => f a -> f (Maybe a)
```

## 21. Data.Monoid (for Writer)

```haskell
Sum n, Product n   :: Monoid wrappers for Int (+, *)
Any b, All b       :: Monoid wrappers for Bool (||, &&)
mempty             :: Monoid a => a                    -- identity
(<>)               :: Semigroup a => a -> a -> a       -- combine
```

## 22. MISC

```haskell
error         :: String -> a                           -- runtime crash
undefined     :: a                                     -- "I'll fill this in"
seq           :: a -> b -> b                           -- force evaluation
```

## 23. CORE COMBINATOR INTUITIONS (one-liners)

| Combinator       | Intuition                                                                  |
|------------------|----------------------------------------------------------------------------|
| `map`            | "apply `f` to each element, preserve order"                                |
| `filter`         | "keep only elements satisfying `p`"                                        |
| `foldr`          | "replace `(:)` with `op` and `[]` with `b`" — right-associative            |
| `foldl`          | "running total from the left" — strict-ish, can't short-circuit on infinite|
| `mapM`           | "`map` with effects, collect results"                                       |
| `mapM_`          | "`map` for side-effects only — drop results"                                |
| `traverse`       | "`mapM` generalised to any Applicative + Traversable"                       |
| `sequence`       | "swap container and effect: `[m a] -> m [a]`"                              |
| `zip` / `zipWith`| "process two lists in lockstep; stops at the shorter one"                  |
| `concatMap`      | "`map` then `concat` — one-pass flatten"                                   |
| `all` / `any`    | "fold of `&&` / `\|\|` over a predicate"                                    |
| `elem` / `notElem` | "is `x` (not) in the list? — `Eq`-required, O(n)"                        |
| `(.)`            | "function composition: `(f . g) x = f (g x)`"                              |
| `($)`            | "low-precedence apply — kills parens: `f $ g x = f (g x)`"                 |
| `flip`           | "swap argument order: `flip f x y = f y x`"                                |
| Partial app      | "`add 1` is a *function* if `add :: Int -> Int -> Int`"                     |

## ⚠ Partial functions (crash on bad input)

`head`, `tail`, `init`, `last`, `maximum`, `minimum`, `foldr1`, `foldl1`, `(!!)`, `read`, `fromJust`, `error`, `div`/`mod` by 0, `digitToInt` for non-digit

## See also
[Data List Char Cheatsheet](data-list-char-cheatsheet.md) · [Type Signature Decoder](type-signature-decoder.md) · [Common Templates](common-templates.md) · [GHCi Tips](ghci-tips.md)
