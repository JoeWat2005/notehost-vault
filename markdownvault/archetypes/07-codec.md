# Archetype 07 — Codec Pair (encode/decode round-trip)

[← INDEX](../INDEX.md) · [↑ Archetypes](README.md) · [NAVIGATION](../NAVIGATION.md)

⭐⭐⭐ A2 (Morse) wholesale; RLE/RLD; toRose/fromRose.

## Concept
Write two mutually-inverse functions; `decode (encode s) = s`.

**Intuition:** encoder usually maps each piece and glues with a separator; decoder splits on the separator and unmaps. For dictionary codecs, build the inverse table by swapping pairs.

## Shape
```haskell
encode :: A -> B          -- intercalate sep . map encodeOne
decode :: B -> A          -- map decodeOne . split sep
```

## Typical sigs
```haskell
encodeText :: Table -> String -> Code
decodeText :: Table -> Code -> String
rle :: Eq a => [a] -> [(a, Int)]
rld :: [(a, Int)] -> [a]
ramify :: Table -> Tree
tabulate :: Tree -> Table
toRose :: Free [] a -> Rose a
fromRose :: Rose a -> Free [] a
```

## Solution
[Codec Pair](../patterns/codec-pair.md) · [Morse Codec](../examples/morse-codec.md)

## ⚠ Traps
- Swapped table for inverse: `lookup k (map swap table)`
- Non-greedy split (use `isPrefixOf` not `==`)
- Delimiter conflicts (codes containing delimiter)
- Iso vs retract: encode∘decode = id may not imply decode∘encode = id
- `lookup` returns Maybe — handle Nothing

## Combines with
[#01](01-tree-recursion.md) (tree codec) · [#12](12-rep-conv.md) (Table↔Tree) · list ops

## Seen
A2 (all 6 tasks), S15 #146 (Tree↔Table), #147 (RLE↔RLD), A3 (toRose/fromRose)

## See also
[Morse Codec](../examples/morse-codec.md) · [Codec Pair](../patterns/codec-pair.md)
