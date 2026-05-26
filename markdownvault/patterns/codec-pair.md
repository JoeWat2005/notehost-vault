# Codec Pair (encode/decode)

[← INDEX](../INDEX.md) · [↑ Patterns](README.md) · [NAVIGATION](../NAVIGATION.md)

> **Mental model:** a codec is a *round-trip* — `decode` undoes `encode`. The encoder usually maps each piece and glues with a separator; the decoder splits on the separator and unmaps. Watch for the *retract* law: `decode . encode = id` is the strong direction; the reverse may not hold (multiple inputs encoding to the same output).

Two mutually-inverse functions satisfying `decode (encode s) = s`.

## Shape
```haskell
encode :: A -> B          -- often:  intercalate sep . map f
decode :: B -> A          -- often:  map g . split sep
```

## Morse example (A2)
```haskell
encodeWord :: Table -> String -> Code
encodeWord t = intercalate shortGap . map (lookupCode t)
  where lookupCode t c = case lookup c t of Just code -> code; _ -> []

decodeWord :: Table -> Code -> String
decodeWord t = map (lookupChar (swap t)) . split shortGap
```

## Helper: split
```haskell
split :: Eq a => [a] -> [a] -> [[a]]
split sep xs = case breakOn sep xs of
  (pre, [])   -> [pre]
  (pre, rest) -> pre : split sep (drop (length sep) rest)
  where
    breakOn pat = go
      where go xs | pat `isPrefixOf` xs = ([], xs)
            go []     = ([], [])
            go (x:xs) = let (a,b) = go xs in (x:a, b)
```

## RLE / RLD (compact codec)
```haskell
rle :: Eq a => [a] -> [(a, Int)]
rle []     = []
rle (x:xs) = (x, 1 + length same) : rle rest
  where same = takeWhile (== x) xs
        rest = dropWhile (== x) xs

rld :: [(a, Int)] -> [a]
rld = concatMap (\(x, n) -> replicate n x)
```

## Tree codec (Morse ramify/tabulate)
- `ramify :: Table -> Tree` — partition table by prefix, recurse
- `tabulate :: Tree -> Table` — DFS collecting paths
- Law: `ramify (tabulate t) = t` (retract, not full iso)

## ⚠ Pitfalls
- Swapped table for decode: `lookup c (map swap t)` ← needs reversal
- Non-greedy split (use `isPrefixOf` not `==`)
- Delimiter in codes (Morse: `dit` not contained in `shortGap`)
- Round-trip law: one direction may not imply the other (retract vs iso)

## See also
[Codec](../archetypes/07-codec.md) · [Morse Codec](../examples/morse-codec.md) · [ADT To ADT Translation](adt-to-adt-translation.md)
