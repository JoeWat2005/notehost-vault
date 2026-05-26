# Higher-Order Functions

[← INDEX](INDEX.md) · [NAVIGATION](NAVIGATION.md)

⭐⭐⭐ Tier-1 exam topic. Cross-cuts every other archetype.

> **Mental model:** in Haskell, functions are values just like `Int` or `String`. You can pass them as arguments (`map f xs`), return them (`flip f = \x y -> f y x`), or build them by partial application (`(+1)` is a function). This is what makes "compose 5 things into a pipeline" so natural.

## Core idea
Functions as arguments OR as return values.

## ⭐ Standard library HOFs (memorise types)

| Name           | Type                                             |
|----------------|--------------------------------------------------|
| `map`          | `(a -> b) -> [a] -> [b]`                         |
| `filter`       | `(a -> Bool) -> [a] -> [a]`                      |
| `foldr`        | `(a -> b -> b) -> b -> [a] -> b`                 |
| `foldl`        | `(a -> b -> a) -> a -> [b] -> a`                 |
| `foldr1`       | `(a -> a -> a) -> [a] -> a`                      |
| `zipWith`      | `(a -> b -> c) -> [a] -> [b] -> [c]`             |
| `zip`          | `[a] -> [b] -> [(a, b)]`                         |
| `takeWhile`    | `(a -> Bool) -> [a] -> [a]`                      |
| `dropWhile`    | `(a -> Bool) -> [a] -> [a]`                      |
| `span`         | `(a -> Bool) -> [a] -> ([a], [a])`               |
| `break`        | `(a -> Bool) -> [a] -> ([a], [a])`               |
| `all`          | `(a -> Bool) -> [a] -> Bool`                     |
| `any`          | `(a -> Bool) -> [a] -> Bool`                     |
| `concatMap`    | `(a -> [b]) -> [a] -> [b]`                       |
| `iterate`      | `(a -> a) -> a -> [a]`     (infinite!)           |
| `(.)`          | `(b -> c) -> (a -> b) -> (a -> c)`               |
| `($)`          | `(a -> b) -> a -> b`                             |
| `flip`         | `(a -> b -> c) -> b -> a -> c`                   |
| `const`        | `a -> b -> a`                                    |
| `curry`        | `((a, b) -> c) -> a -> b -> c`                   |
| `uncurry`      | `(a -> b -> c) -> (a, b) -> c`                   |

## Compose & pipeline

`(f . g) x = f (g x)`. Compose builds left-to-right syntactically but data flows right-to-left through the pipeline.

```haskell
sumSqrEven :: [Int] -> Int
sumSqrEven = sum . map (^2) . filter even

-- Read right-to-left: filter even, then square, then sum
```

## Currying & partial application

In Haskell, **every function takes one argument**. `f :: a -> b -> c` is sugar for `a -> (b -> c)`. Apply fewer args and you get back a function:
```haskell
add :: Int -> Int -> Int
add x y = x + y

inc :: Int -> Int
inc = add 1            -- partial application; `inc 4 == 5`
```

## Sections (partial application of operators)
```haskell
(+1)      -- \x -> x + 1
(2*)      -- \x -> 2 * x
(/2)      -- \x -> x / 2
(`div`2)  -- \x -> x `div` 2
(==5)     -- \x -> x == 5
(`elem` xs)  -- \x -> x `elem` xs
```

## Lambdas
```haskell
\x -> x + 1
\x y -> x * y
\(x, y) -> x + y
\_ -> 0       -- ignore arg
```

## ⭐ Reformulating recursion via fold

```haskell
sum     = foldr (+) 0
product = foldr (*) 1
length  = foldr (\_ n -> 1 + n) 0
map f   = foldr (\x xs -> f x : xs) []
filter p = foldr (\x xs -> if p x then x : xs else xs) []
concat  = foldr (++) []
and     = foldr (&&) True
or      = foldr (||) False
maximum = foldr1 max          -- partial on []
minimum = foldr1 min
reverse = foldl (flip (:)) []
compose = foldr (.) id        -- compose list of fns
```

## Specific patterns

### Twice / applyN
```haskell
twice :: (a -> a) -> a -> a
twice f = f . f

applyN :: Int -> (a -> a) -> a -> a
applyN 0 _ x = x
applyN n f x = applyN (n-1) f (f x)
```

### altMap (W4 problem)
```haskell
altMap :: (a -> b) -> (a -> b) -> [a] -> [b]
altMap _ _ []       = []
altMap f _ [x]      = [f x]
altMap f g (x:y:xs) = f x : g y : altMap f g xs
```

### Binary string transmitter (W5 lecture)
```haskell
type Bit = Int

bin2int :: [Bit] -> Int
bin2int = foldr (\x y -> x + 2*y) 0

int2bin :: Int -> [Bit]
int2bin 0 = []
int2bin n = n `mod` 2 : int2bin (n `div` 2)

make8 :: [Bit] -> [Bit]
make8 bs = take 8 (bs ++ repeat 0)

encode :: String -> [Bit]
encode = concatMap (make8 . int2bin . ord)

chop8 :: [Bit] -> [[Bit]]
chop8 [] = []
chop8 bs = take 8 bs : chop8 (drop 8 bs)

decode :: [Bit] -> String
decode = map (chr . bin2int) . chop8

transmit :: String -> String
transmit = decode . channel . encode
  where channel = id
```

## Church numerals (W4)
```haskell
type Church a = (a -> a) -> a -> a

zero :: Church a
zero f x = x

addChurch :: Church a -> Church a -> Church a
addChurch m n f x = m f (n f x)

mulChurch :: Church a -> Church a -> Church a
mulChurch m n f = m (n f)
```

## ⚠ Pitfalls
- `foldr (+)` requires base case → `foldr (+) 0`
- `foldl (-)` and `foldr (-)` give DIFFERENT results
- `iterate` is infinite — combine with `take`
- `map f . map g = map (f . g)` (fusion — use when efficient)
- right-fold short-circuits on infinite list; left-fold doesn't

## Helper-function patterns (style tips)

### `where` vs `let`
- `where` binds locals *at the bottom* of a function (top-down reading)
- `let … in …` binds locals *in an expression* (when only used once)
- Both are pure; pick whichever reads cleanest.

### Guards vs pattern matching
- **Pattern matching** — when you care about the *shape* (constructor) of the input. Use this for ADTs, lists, Maybe, etc.
- **Guards** — when shape is known but you want to branch on a *predicate* of the bound values. Use `|` with conditions.
- They compose freely: `f (Just x) | x > 0 = …` matches the ctor AND tests the value.

### Local helpers via `where`
```haskell
fastFib n = go n 0 1
  where
    go 0 a _ = a
    go k a b = go (k-1) b (a+b)
```
Keep the public type signature for `fastFib`; let `go` be a private detail.

## See also
[List Comprehensions](list-comprehensions.md) · [Folds](patterns/folds.md) · [List Recursion](patterns/list-recursion.md) · [Type Signature Decoder](type-signature-decoder.md)
