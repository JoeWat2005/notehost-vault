# Maybe Monad

[← INDEX](../INDEX.md) · [↑ Monads](README.md) · [NAVIGATION](../NAVIGATION.md)

> **Mental model:** `Maybe a` = "either an `a` (success) or nothing (failure)". As a monad, the second the chain hits `Nothing`, the whole `do`-block short-circuits to `Nothing` — you don't need to write `if isJust …` everywhere.

Failure without error message. The canonical partiality wrapper.

## Type
```haskell
data Maybe a = Nothing | Just a
```

## Instance
```haskell
instance Monad Maybe where
  return        = Just
  Nothing >>= _ = Nothing
  Just x  >>= f = f x
```

Short-circuits on first `Nothing`.

## Common functions
```haskell
maybe       :: b -> (a -> b) -> Maybe a -> b
fromMaybe   :: a -> Maybe a -> a
catMaybes   :: [Maybe a] -> [a]
mapMaybe    :: (a -> Maybe b) -> [a] -> [b]
isJust      :: Maybe a -> Bool
isNothing   :: Maybe a -> Bool
fromJust    :: Maybe a -> a            -- partial
```

## Patterns

### case-on-recursive
```haskell
takeMaybe 0 _      = Just []
takeMaybe _ []     = Nothing
takeMaybe n (x:xs) = case takeMaybe (n-1) xs of
  Nothing   -> Nothing
  Just rest -> Just (x : rest)
```

### do-notation (idiomatic)
```haskell
takeMaybe n (x:xs) = do
  rest <- takeMaybe (n-1) xs
  return (x : rest)
```

### two recursive Maybes
```haskell
eval (Add a b) = do
  x <- eval a
  y <- eval b
  return (x + y)
```

### catMaybes by pattern
```haskell
cats []             = []
cats (Just x  : xs) = x : cats xs
cats (Nothing : xs) = cats xs
```

## Use cases
- `safeDivide`, `safeHead`, `safeIndex`
- `lookup :: Eq a => a -> [(a,b)] -> Maybe b`
- BST delete: `delete' :: Ord a => a -> BT a -> Maybe (BT a)`
- Morse trie payload: `Branch (Maybe Char) Tree Tree`
- env: `type Env = String -> Maybe Value`

## See also
[Either](either.md) · [Monadic Recursion](../patterns/monadic-recursion.md) · [Monad](../typeclasses/monad.md)
