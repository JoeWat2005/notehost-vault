# Caesar Cipher (list comprehensions + Data.Char)

[← INDEX](../INDEX.md) · [↑ Examples](README.md) · [NAVIGATION](../NAVIGATION.md)

Shift each letter by n positions in alphabet.

> **Technique:** `ord`/`chr` translate between Char and ASCII int. Shift inside the alphabet range via `mod 26`. Preserve case by branching on `isLower`/`isUpper`.

## Imports
```haskell
import Data.Char (ord, chr, isLower, isUpper)
```

## Shift one character
```haskell
shift :: Int -> Char -> Char
shift n c
  | isLower c = chr (ord 'a' + ((ord c - ord 'a' + n) `mod` 26))
  | isUpper c = chr (ord 'A' + ((ord c - ord 'A' + n) `mod` 26))
  | otherwise = c
```

## Encode whole string
```haskell
encode :: Int -> String -> String
encode n = map (shift n)
```

## Decode
```haskell
decode :: Int -> String -> String
decode n = encode (-n)
```

## Frequency analysis (S6 #56)
```haskell
freqs :: String -> [Float]
freqs cs = [percent (count c lowered) total | c <- ['a'..'z']]
  where
    lowered = [toLower c | c <- cs, isAlpha c]
    total   = length lowered

count :: Char -> String -> Int
count c cs = length [c' | c' <- cs, c == c']

percent :: Int -> Int -> Float
percent n m = fromIntegral n / fromIntegral m * 100
```

## Crack (chi-squared)
```haskell
table :: [Float]
table = [8.1, 1.5, 2.8, 4.2, 12.7, 2.2, 2.0, 6.1, 7.0, 0.2, 0.8, 4.0,
         2.4, 6.7, 7.5, 1.9, 0.1, 6.0, 6.3, 9.0, 2.8, 1.0, 2.4, 0.2, 2.0, 0.1]

chisqr :: [Float] -> [Float] -> Float
chisqr os es = sum [(o - e)^2 / e | (o, e) <- zip os es]

rotate :: Int -> [a] -> [a]
rotate n xs = drop n xs ++ take n xs

crack :: String -> String
crack cs = encode (- factor) cs
  where
    factor = head (positions (minimum chitab) chitab)
    chitab = [chisqr (rotate n (freqs cs)) table | n <- [0..25]]

positions :: Eq a => a -> [a] -> [Int]
positions x xs = [i | (y, i) <- zip xs [0..], x == y]
```

## Pattern
List comprehensions + Data.Char + chi-squared crack.

## See also
[List Recursion](../patterns/list-recursion.md) · `Data.Char` module
