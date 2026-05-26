# Archetype 15 — Writer Trace

[← INDEX](../INDEX.md) · [↑ Archetypes](README.md) · [NAVIGATION](../NAVIGATION.md)

⭐⭐ ewan31-40.hs, S11 #107-108, W9.

## Concept
Log every step of a traversal without polluting return type.

**Intuition:** `tell w` appends `w` to the running log. The Writer monad keeps the log alongside the result, so the function's return type stays clean while side-channel info accumulates.

## Shape
```haskell
f :: T -> Writer [String] ()
f (Leaf …)    = tell ["…"]
f (Branch xs) = do tell ["enter"]; mapM_ f xs; tell ["leave"]
```

## Typical sigs
```haskell
logTraverse :: Dir -> Writer [String] ()
g :: Int -> Writer (Sum Int) Int
collatz :: Int -> Writer [Int] Int
```

## Solution
[Writer Trace](../templates/writer-trace.md) · [Writer](../monads/writer.md)

```haskell
logTraverse :: Dir -> Writer [String] ()
logTraverse (File name _) = tell ["Passing file: " ++ name]
logTraverse (SubDir name contents) = do
  tell ["Entering directory: " ++ name]
  mapM_ logTraverse contents
  tell ["Leaving directory: " ++ name]
```

## ⚠ Traps
- Use `<-` not `=` for monadic bind
- Need a Monoid for w (raw `Int` isn't — use `Sum`/`Product`)
- `String` is a Monoid (via `++`) but `[String]` better for line logs
- Don't `tell` from pure code (compile error)

## Combines with
[#01](01-tree-recursion.md) (tree traversal) · do-notation · Monad

## Seen
ewan31-40.hs (logTraverse, countFiles), S11 #107-108, W9

## See also
[Writer](../monads/writer.md) · [Writer Trace](../templates/writer-trace.md)
