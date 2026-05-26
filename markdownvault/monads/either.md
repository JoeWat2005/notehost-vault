# Either Monad

[← INDEX](../INDEX.md) · [↑ Monads](README.md) · [NAVIGATION](../NAVIGATION.md)

> **Mental model:** like [Maybe](maybe.md), but the failure carries a payload (usually an error message). Short-circuits on the *first* `Left`. Convention: `Left` = error, `Right` = success.

Failure WITH error message. Richer than [Maybe](maybe.md).

## Type
```haskell
data Either a b = Left a | Right b
```

Convention: `Left` = error, `Right` = success.

## Instance
```haskell
instance Monad (Either e) where
  return         = Right
  Left  e >>= _  = Left e
  Right x >>= f  = f x
```

## Common functions
```haskell
either :: (a -> c) -> (b -> c) -> Either a b -> c   -- eliminator
lefts  :: [Either a b] -> [a]
rights :: [Either a b] -> [b]
```

## Patterns

### Error-typed evaluator
```haskell
eval :: Expr -> Either String Int
eval (Val n)   = Right n
eval (Div a b) = do
  x <- eval a
  y <- eval b
  if y == 0 then Left "Division by zero" else Right (x `div` y)
```

### zipEither (W5 problem)
```haskell
zipEither :: [a] -> [b] -> Either String [(a, b)]
zipEither []     []     = Right []
zipEither []     _      = Left "first list shorter"
zipEither _      []     = Left "second list shorter"
zipEither (x:xs) (y:ys) = do
  rest <- zipEither xs ys
  return ((x, y) : rest)
```

## Use cases
- Evaluator with diagnostic error messages
- Parser with location info
- Validation with single error (multi-error → Validation, not in course)

## ⚠ Pitfalls
- The `e` in `Either e a` is FIRST type param; `Monad (Either e)` fixes `e`
- Pattern match `Left/Right`, not `Just/Nothing`

## See also
[Maybe](maybe.md) · [Monaderror](monaderror.md) · [Monaderror Eval](../interpreters/monaderror-eval.md)
