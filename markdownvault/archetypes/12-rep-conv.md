# Archetype 12 — Representation Conversion

[← INDEX](../INDEX.md) · [↑ Archetypes](README.md) · [NAVIGATION](../NAVIGATION.md)

⭐⭐ A2 (Table↔Tree), A3 (Rose↔Free []), W11 Q1.

## Concept
Switch between two equivalent reps of the same data.

**Intuition:** structural recursion on the source, building the target as you go. Often the two reps have parallel constructors (e.g. `Leaf`↔`Pure`, `Branch`↔`Free`) — match each one.

## Shape
Structural recursion on source, build target.

## Typical sigs
```haskell
ramify   :: Table -> Tree
tabulate :: Tree -> Table
toRose   :: Free [] a -> Rose a
fromRose :: Rose a -> Free [] a
-- W11 Q1: reimplement TTT primitives with Grid = ([Move], [Move])
```

## Solution

### toRose / fromRose (A3)
```haskell
data Free f a = Pure a | Free (f (Free f a))
data Rose a   = Lf a | Br [Rose a]

toRose :: Free [] a -> Rose a
toRose (Pure x)  = Lf x
toRose (Free xs) = Br (map toRose xs)

fromRose :: Rose a -> Free [] a
fromRose (Lf x)  = Pure x
fromRose (Br xs) = Free (map fromRose xs)
```

### Tree → Table (tabulate)
```haskell
tabulate :: Tree -> Table
tabulate t = go [] t
  where
    go _    Empty                       = []
    go path (Branch Nothing  l r)       = go (path ++ [False]) l ++ go (path ++ [True]) r
    go path (Branch (Just c) l r)       = (c, path) : go (path ++ [False]) l ++ go (path ++ [True]) r
```

## ⚠ Traps
- Law check: iso (both inverse) vs retract (one direction only)
- Empty case (both sides have base case)
- Address rep: Direction vs Int vs Bool — match the spec
- Reusing wrong base case across directions

## Combines with
[#07 Codec](07-codec.md) · [#01](01-tree-recursion.md) · ADT design

## Seen
A2 (Table↔Tree), A3 (Rose↔Free []), W11 Q1, S15 #146

## See also
[Morse Codec](../examples/morse-codec.md) · [Codec Pair](../patterns/codec-pair.md)
