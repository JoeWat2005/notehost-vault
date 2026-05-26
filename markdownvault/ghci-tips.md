# GHCi Tips — exam-time debugging

[← INDEX](INDEX.md) · [NAVIGATION](NAVIGATION.md)

> **Two GHCi commands earn back the most marks**: `:t expr` (find a function's exact type) and `:reload` (after every edit). Most "won't compile" panic moments resolve once you read the type GHCi inferred.

## Loading
```
ghci MyFile.hs
:load MyFile.hs     -- (or :l)
:reload             -- (or :r) after editing
:cd path            -- change working directory
:quit               -- (or :q)
```

## Type inspection — USE OFTEN
```
:type expr          -- (or :t) show type of expression
:t myFunc
:t 1                -- Num a => a
:t (1 :: Int)       -- Int
:info Name          -- (or :i) class methods, instances, location
:i Functor
:kind Maybe         -- (or :k) kind of a type ctor
```

## Set runtime options
```
:set +s             -- show timing + allocation after every eval
:set +t             -- show type after every eval
:unset +s
:set -W             -- enable all warnings
```

## Debugging
```
:print x            -- show as much of x as evaluated
:force x            -- force x to WHNF and print
:break Main 42      -- breakpoint at line 42
:step               -- single-step execution
:continue           -- resume
```

## Browse modules
```
:browse Data.List   -- see all exports
:browse Prelude
```

## Test idioms

### Quick sanity check
```haskell
:t myFunction
myFunction [1,2,3]
myFunction Empty
myFunction (Fork 5 Empty Empty)
```

### QuickCheck a property (if Test.QuickCheck imported)
```haskell
import Test.QuickCheck
quickCheck (\xs -> myReverse (myReverse xs) == (xs :: [Int]))
```

### Time/memory comparison
```
:set +s
sum [1..100000]
fastFib 1000
```

### Show a tree
```haskell
showTree :: Show a => BT a -> String
showTree Empty = "."
showTree (Fork x l r) = "(" ++ show x ++ " " ++ showTree l ++ " " ++ showTree r ++ ")"
```

## Common typecheck errors

| Error                                       | Likely cause                            |
|---------------------------------------------|-----------------------------------------|
| `No instance for (Show …)`                  | derive Show, or use `print` not allowed |
| `Couldn't match expected type 'Int' with…`  | inferred type ≠ annotated type          |
| `Non-exhaustive patterns in function f`     | missing case (Empty / [] / Nothing)     |
| `Ambiguous occurrence`                      | two imports defined the same name       |
| `Variable not in scope: foo`                | forgot to define / wrong file loaded    |
| `Couldn't match type 'a' with 'IO a'`       | mixed pure code with IO action          |

## Useful one-shot eval idioms
```haskell
let x = 5 in x * x
[(x, y) | x <- [1..3], y <- [1..3], x < y]
foldr (+) 0 [1..10]
mapM_ print [1..5]
```

## Exam-specific
- Run `./presubmit.sh AssignmentN` from terminal (not GHCi)
- For Mock: `echo 'main' | stack repl` in assignment directory
- Don't add `import Data.Map` etc. — exam forbids extra imports

## Hoogle (allowed in exam)
- Web: <https://hoogle.haskell.org/>
- Search by NAME: `intercalate`
- Search by TYPE: `(a -> b) -> [a] -> [b]` → finds `map`, `fmap`
- Search SIG: `Ord a => [a] -> [a]` → finds `sort`

## See also
[Common Pitfalls](common-pitfalls.md) · [Exam Day Plan](exam-day-plan.md) · [Data List Char Cheatsheet](data-list-char-cheatsheet.md)
