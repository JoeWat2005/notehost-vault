# Template — Writer trace

[← INDEX](../INDEX.md) · [↑ Templates](README.md) · [NAVIGATION](../NAVIGATION.md)

> **What this pattern is doing:** walk a structure recursively; at every "interesting" point, `tell` a log line. The Writer monad accumulates the log automatically. Pair "enter"/"leave" lines around recursive calls if you want nesting visible.

```haskell
import Control.Monad.Writer

trace :: Show a => T a -> Writer [String] ()
trace (Atom x)        = tell ["seen: " ++ show x]
trace (Compound xs)   = do
  tell ["enter"]
  mapM_ trace xs
  tell ["leave"]
```

## Directory traversal (ewan31-40.hs)
```haskell
data Dir = File String String | SubDir String [Dir]

logTraverse :: Dir -> Writer [String] ()
logTraverse (File name _) = tell ["Passing file: " ++ name]
logTraverse (SubDir name contents) = do
  tell ["Entering directory: " ++ name]
  mapM_ logTraverse contents
  tell ["Leaving directory: " ++ name]
```

## Numeric accumulator
```haskell
g :: Int -> Writer (Sum Int) Int
g n = do
  tell (Sum n)
  return (n * 2)
```

## Run
```haskell
runWriter  :: Writer w a -> (a, w)        -- (result, log)
execWriter :: Writer w a -> w             -- log only
```

```haskell
let (_, logs) = runWriter (logTraverse myDir)
mapM_ putStrLn logs
```

## ⚠ Pitfalls
- Need `Monoid` for w. Raw `Int` isn't — use `Sum`/`Product`.
- `String` IS a Monoid via `++`, but `[String]` is cleaner for line-by-line logs.
- Use `<-` not `=` in do-blocks.

## See also
[Writer](../monads/writer.md) · [Writer Trace](../archetypes/15-writer-trace.md)
