# Morse Codec (A2)

[← INDEX](../INDEX.md) · [↑ Examples](README.md) · [NAVIGATION](../NAVIGATION.md)

Encode/decode pair with shortGap between chars, mediumGap between words. Also tree-based decode.

> **Technique:** codec pair — encode maps each char via a table and intercalates a separator; decode splits and inverse-maps. Tree decode descends a Morse tree by Beep/Silence bits to a leaf with the payload.

## Types
```haskell
data Atom = Beep | Silence  deriving (Eq, Show)
type Code = [Atom]
type Table = [(Char, Code)]

shortGap  = [Silence, Silence, Silence]
mediumGap = [Silence, Silence, Silence, Silence, Silence, Silence, Silence]
```

## Encode
```haskell
encodeWord :: Table -> String -> Code
encodeWord t = intercalate shortGap . map (lookupCode t)
  where
    lookupCode t c = case lookup c t of Just code -> code; _ -> []

encodeWords :: Table -> [String] -> Code
encodeWords t = intercalate mediumGap . map (encodeWord t)

encodeText :: Table -> String -> Code
encodeText t = encodeWords t . words
```

## Decode (with split helper)
```haskell
split :: Eq a => [a] -> [a] -> [[a]]
split _   []  = [[]]
split sep xs
  | sep `isPrefixOf` xs = [] : split sep (drop (length sep) xs)
  | otherwise           = (head xs : head rest) : tail rest
  where rest = split sep (tail xs)

decodeWord :: Table -> Code -> String
decodeWord t = map lookupChar . split shortGap
  where
    lookupChar code = case lookup code (map swap t) of
      Just c  -> c
      Nothing -> '?'
    swap (a, b) = (b, a)

decodeText :: Table -> Code -> String
decodeText t = unwords . map (decodeWord t) . split mediumGap
```

## Tree-based decode (ramify/tabulate)
```haskell
data Tree = Empty | Branch (Maybe Char) Tree Tree  deriving Show

ramify :: Table -> Tree
ramify [] = Empty
ramify ((c, []):xs) =
  case ramify xs of
    Empty                -> Branch (Just c) Empty Empty
    Branch _ l r         -> Branch (Just c) l r
ramify ((c, Beep:bs):xs) = insertRight c bs (ramify xs)
ramify ((c, Silence:bs):xs) = insertLeft c bs (ramify xs)
-- (helpers omitted — see Assignment2Solutions.hs)

tabulate :: Tree -> Table
tabulate t = go [] t
  where
    go _    Empty                     = []
    go path (Branch Nothing  l r)     = go (path ++ [Silence]) l ++ go (path ++ [Beep]) r
    go path (Branch (Just c) l r)     = (c, path) : go (path ++ [Silence]) l ++ go (path ++ [Beep]) r
```

## Round-trip laws
- `decodeText t (encodeText t s) = s`            (iso)
- `ramify (tabulate t) = t`                       (one direction; retract)
- `tabulate (ramify t)` may differ from t (multiple trees encode same table)

## Pattern
[#07 Codec](../archetypes/07-codec.md) · [#12 Rep conv](../archetypes/12-rep-conv.md)

## See also
[Codec Pair](../patterns/codec-pair.md) · [ADT Declarations](../templates/adt-declarations.md)
