# Data.List + Data.Char Cheatsheet

[← INDEX](INDEX.md) · [NAVIGATION](NAVIGATION.md)

Quick reference for course-allowed library functions.

> **When to reach for this file:** you're sure a function "must exist" but can't remember its name. Common ones live in [Prelude Cheatsheet](prelude-cheatsheet.md); this file covers the focused `Data.List` / `Data.Char` extras plus a few idiomatic snippets.


## Data.List — most useful

| Function       | Type                                              | What it does                       |
|----------------|---------------------------------------------------|------------------------------------|
| `sort`         | `Ord a => [a] -> [a]`                             | ascending sort                     |
| `sortBy`       | `(a -> a -> Ordering) -> [a] -> [a]`              | custom-cmp sort                    |
| `sortOn`       | `Ord b => (a -> b) -> [a] -> [a]`                 | sort by projection                 |
| `group`        | `Eq a => [a] -> [[a]]`                            | runs of consecutive equal          |
| `groupBy`      | `(a -> a -> Bool) -> [a] -> [[a]]`                | custom-eq group                    |
| `nub`          | `Eq a => [a] -> [a]`                              | remove duplicates                  |
| `(\\)`         | `Eq a => [a] -> [a] -> [a]`                       | list difference                    |
| `union`        | `Eq a => [a] -> [a] -> [a]`                       | set union                          |
| `intersect`    | `Eq a => [a] -> [a] -> [a]`                       | set intersection                   |
| `intercalate`  | `[a] -> [[a]] -> [a]`                             | join with separator                |
| `intersperse`  | `a -> [a] -> [a]`                                 | put sep between elements           |
| `transpose`    | `[[a]] -> [[a]]`                                  | rows ↔ columns                     |
| `isPrefixOf`   | `Eq a => [a] -> [a] -> Bool`                      | prefix test                        |
| `isSuffixOf`   | `Eq a => [a] -> [a] -> Bool`                      | suffix test                        |
| `isInfixOf`    | `Eq a => [a] -> [a] -> Bool`                      | infix test                         |
| `stripPrefix`  | `Eq a => [a] -> [a] -> Maybe [a]`                 | strip if prefix; else Nothing      |
| `lookup`       | `Eq a => a -> [(a, b)] -> Maybe b`                | assoc lookup                       |
| `find`         | `(a -> Bool) -> [a] -> Maybe a`                   | first matching                     |
| `findIndex`    | `(a -> Bool) -> [a] -> Maybe Int`                 | first matching index               |
| `elemIndex`    | `Eq a => a -> [a] -> Maybe Int`                   | first index of x                   |
| `partition`    | `(a -> Bool) -> [a] -> ([a], [a])`                | (yes, no) split                    |
| `splitAt`      | `Int -> [a] -> ([a], [a])`                        | split at index                     |
| `tails`        | `[a] -> [[a]]`                                    | all suffixes                       |
| `inits`        | `[a] -> [[a]]`                                    | all prefixes                       |
| `zip3`         | `[a] -> [b] -> [c] -> [(a,b,c)]`                  | three-way zip                      |
| `zipWith3`     | `(a -> b -> c -> d) -> [a] -> [b] -> [c] -> [d]`  | three-way zipWith                  |
| `unfoldr`      | `(b -> Maybe (a, b)) -> b -> [a]`                 | dual of foldr                      |
| `permutations` | `[a] -> [[a]]`                                    | all permutations                   |
| `subsequences` | `[a] -> [[a]]`                                    | all subsequences                   |
| `words`        | `String -> [String]`                              | split on whitespace                |
| `unwords`      | `[String] -> String`                              | join with spaces                   |
| `lines`        | `String -> [String]`                              | split on newlines                  |
| `unlines`      | `[String] -> String`                              | join with newlines                 |

## Data.Char — most useful

| Function       | Type                          | What it does               |
|----------------|-------------------------------|----------------------------|
| `isDigit`      | `Char -> Bool`                | '0'-'9'?                   |
| `isAlpha`      | `Char -> Bool`                | letter?                    |
| `isAlphaNum`   | `Char -> Bool`                | letter or digit?           |
| `isSpace`      | `Char -> Bool`                | whitespace?                |
| `isUpper`      | `Char -> Bool`                | uppercase?                 |
| `isLower`      | `Char -> Bool`                | lowercase?                 |
| `toUpper`      | `Char -> Char`                | uppercase                  |
| `toLower`      | `Char -> Char`                | lowercase                  |
| `ord`          | `Char -> Int`                 | char to ASCII int          |
| `chr`          | `Int -> Char`                 | ASCII int to char          |
| `digitToInt`   | `Char -> Int`                 | '5' → 5; partial           |
| `intToDigit`   | `Int -> Char`                 | 5 → '5'; partial           |

## Common idioms

### Frequency map (no State needed)
```haskell
freqs :: Ord a => [a] -> [(a, Int)]
freqs xs = [(head g, length g) | g <- group (sort xs)]
```

### Caesar shift
```haskell
shift n c
  | isLower c = chr (ord 'a' + (ord c - ord 'a' + n) `mod` 26)
  | isUpper c = chr (ord 'A' + (ord c - ord 'A' + n) `mod` 26)
  | otherwise = c
```

### Split a list by separator
```haskell
split :: Eq a => [a] -> [a] -> [[a]]
split sep xs = case break (\y -> sep `isPrefixOf` (y : drop 0 xs)) xs of
  …  -- (less common; manually recursing on `isPrefixOf` is usually clearer)
```

### Words/unwords pipeline
```haskell
trimDouble :: String -> String
trimDouble = unwords . words   -- collapses runs of whitespace
```

### Title-case
```haskell
capitalize :: String -> String
capitalize []     = []
capitalize (c:cs) = toUpper c : map toLower cs
```

### Reverse only words
```haskell
reverseWords :: String -> String
reverseWords = unwords . map reverse . words
```

### Sort by length
```haskell
sortOn length [[1,2,3], [], [4]]
-- [[], [4], [1,2,3]]
```

### Run-length encoding via group
```haskell
rle :: Eq a => [a] -> [(a, Int)]
rle xs = [(head g, length g) | g <- group xs]
```

## ⚠ Pitfalls
- `nub` is O(n²) — fine for exam-size, avoid for big inputs
- `digitToInt 'a' = 10` (handles hex!) — careful with non-digits
- `lookup` returns Maybe — handle Nothing
- `sort` is stable; `sortBy` requires `Ord` not assumed
- `partition` walks WHOLE list (unlike `span` which stops at first failure)
- `groupBy` checks adjacent elements only — pre-sort if you want global grouping

## See also
[Higher Order Functions](higher-order-functions.md) · [List Comprehensions](list-comprehensions.md) · [Examples Caesar Cipher](examples/caesar-cipher.md) · [Examples Morse Codec](examples/morse-codec.md)
