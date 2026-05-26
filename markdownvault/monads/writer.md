# Writer Monad

[← INDEX](../INDEX.md) · [↑ Monads](README.md) · [NAVIGATION](../NAVIGATION.md)

> **Mental model:** Writer is the dual of Reader — alongside your result, you *accumulate* a side-channel value (a log, a sum, a counter) using a `Monoid` to combine entries. Each `tell w` appends; the final result and the combined log come out via `runWriter` / `execWriter`.

Emit a [Monoid] alongside the result. Use for logs / traces / metrics.

## Import
```haskell
import Control.Monad.Writer
```

## Type
```haskell
newtype Writer w a   -- conceptually: (a, w)
```
Requires `Monoid w` to combine outputs via `<>`.

## Primitive
```haskell
tell :: Monoid w => w -> Writer w ()    -- append w to output
```

## Runners
```haskell
runWriter  :: Writer w a -> (a, w)
execWriter :: Writer w a -> w
```

## Common w choices
| Effect            | w type         |
|-------------------|----------------|
| line-by-line log  | `[String]`     |
| concat string     | `String`       |
| numeric total     | `Sum Int`      |
| numeric product   | `Product Int`  |
| any-true          | `Any`          |
| all-true          | `All`          |

## Patterns

### Trace traversal
```haskell
logTraverse :: Dir -> Writer [String] ()
logTraverse (File n _)    = tell ["Pass: " ++ n]
logTraverse (SubDir n cs) = do
  tell ["Enter " ++ n]
  mapM_ logTraverse cs
  tell ["Leave " ++ n]
```

### Numeric accumulator
```haskell
g :: Int -> Writer (Sum Int) Int
g n = do tell (Sum n); return (n * 2)

-- Run:
fst (runWriter (g 3))   -- 6
snd (runWriter (g 3))   -- Sum 3
```

## ⚠ Pitfalls
- Need `Monoid` for w (raw `Int` isn't — use `Sum`/`Product`)
- `String` IS a monoid (via `++`), but `[String]` is usually cleaner
- Don't use `tell` in pure-fn — must be in Writer monad

## See also
[State](state.md) · [Writer Trace](../archetypes/15-writer-trace.md) · [Writer Trace](../templates/writer-trace.md)
