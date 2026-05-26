# Alternative

[← INDEX](../INDEX.md) · [↑ Typeclasses](README.md) · [NAVIGATION](../NAVIGATION.md)

> **Mental model:** "Try this; if it fails, try that." `empty` is "no success at all"; `(<|>)` is "or else". Used heavily in parsers — try one alternative, fall through to another on failure. Also gives you `many`/`some` for repetition.

"Failure + choice." Subclass of [Applicative](applicative.md).

## Class
```haskell
class Applicative f => Alternative f where
  empty :: f a
  (<|>) :: f a -> f a -> f a
```

## Laws
- `empty <|> x = x`
- `x <|> empty = x`
- associativity: `(x <|> y) <|> z = x <|> (y <|> z)`

## Standard instances

### Maybe
```haskell
instance Alternative Maybe where
  empty                  = Nothing
  Nothing <|> r          = r
  l       <|> _          = l
```

### List
```haskell
instance Alternative [] where
  empty   = []
  (<|>)   = (++)
```

### Parser
```haskell
instance Alternative Parser where
  empty       = P (\_ -> [])
  P p <|> P q = P (\s -> case p s of [] -> q s; rs -> rs)
```

## Derived combinators
```haskell
many :: Alternative f => f a -> f [a]      -- 0+ repetitions
many p = some p <|> pure []

some :: Alternative f => f a -> f [a]      -- 1+ repetitions
some p = (:) <$> p <*> many p

optional :: Alternative f => f a -> f (Maybe a)
optional p = (Just <$> p) <|> pure Nothing
```

## Use cases
- Parser grammar alternatives: `expr <|> term <|> factor`
- "try-this-otherwise-default": `lookup k m <|> Just default_`
- Many/some loops in parsers

## ⚠ Pitfalls
- `<|>` for Parser is NOT backtracking-friendly — order matters: most-specific first
- `<|>` short-circuits in Maybe (returns first non-Nothing)
- `many p` of an always-succeeding parser = infinite loop

## See also
[Applicative](applicative.md) · [Maybe](../monads/maybe.md) · [Parser](../archetypes/16-parser.md) · [Parser Newtype](../templates/parser-newtype.md)
