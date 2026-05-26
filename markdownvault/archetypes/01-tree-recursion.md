# Archetype 01 — Tree-ADT Structural Recursion

[← INDEX](../INDEX.md) · [↑ Archetypes](README.md) · [NAVIGATION](../NAVIGATION.md)

⭐⭐⭐⭐⭐ The course's #1 archetype. Mock Q1, Q5, A2 wholesale, S8/9/15.

## Concept
Consume a recursively-defined ADT by pattern-matching each constructor; recurse on children.

**Intuition:** one equation per constructor. The base ctor stops; each recursive ctor does work + recurses on its children + combines.

## Shape
```haskell
data T = Base | Step part (T) (T) [...]

f Base         = base
f (Step p l r) = combine p (f l) (f r)
```

## Typical sigs
```haskell
size, height :: T -> Int
flatten      :: T -> [a]
mirror       :: T -> T
mapT         :: (a -> b) -> T a -> T b
isNBranching :: Int -> Rose a -> Bool
prune        :: Int -> Rose a -> Rose a
```

## Solution
[Tree BT](../templates/tree-bt.md) · [Tree Rose](../templates/tree-rose.md)

## ⚠ Traps
- shallow check on Rose (forget `&& all rec xs`) — see `ewan20.hs` bug
- isBST Empty should be True
- ctor names vary (BT/Fork vs EmptyTree/Node vs Bin/Lf/Nd)
- swap l/r incorrect (mirror needs it; other transforms don't)
- non-exhaustive patterns (QuickCheck WILL test Empty)

## Combines with
[#06 Functor](06-functor-instance.md) · [#15 Writer trace](15-writer-trace.md) · [#02 State (label)](02-state-game.md) · [#05 ADT-translation](05-adt-translation.md) · [#08 Env eval](08-env-eval.md)

## Seen
Mock Q1 (Rose isNBranching, prune), Mock Q5 (Expr→Circuit recursive), W5/6/7, A2 (Tree wholesale), S8/9/15, every student practice file.

## See also
[Tree Recursion](../patterns/tree-recursion.md) · [Mock Q1 Rose](../examples/mock-q1-rose.md) · [Mock Q5 Circuit](../examples/mock-q5-circuit.md)
