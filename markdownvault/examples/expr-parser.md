# Arithmetic Expression Parser

[← INDEX](../INDEX.md) · [↑ Examples](README.md) · [NAVIGATION](../NAVIGATION.md)

Recursive-descent parser for `expr = term ('+' expr | ε)` etc.

> **Technique:** stratify by precedence — one parser per level (`expr` for `+`, `term` for `*`, `factor` for atoms/parens). Each parser tries the operator alternative or falls back via `<|>`.

## Setup
```haskell
import Data.Char (isDigit, isSpace)
import Control.Applicative (Alternative(..))

newtype Parser a = P (String -> [(a, String)])
parse (P p) = p
```

## Instances (often pre-supplied)
```haskell
instance Functor Parser where
  fmap f (P p) = P (\s -> [(f x, s') | (x, s') <- p s])

instance Applicative Parser where
  pure x = P (\s -> [(x, s)])
  P p <*> P q = P (\s -> [(f x, s'') | (f, s') <- p s, (x, s'') <- q s'])

instance Monad Parser where
  P p >>= f = P (\s -> concat [parse (f x) s' | (x, s') <- p s])

instance Alternative Parser where
  empty = P (\_ -> [])
  P p <|> P q = P (\s -> case p s of [] -> q s; rs -> rs)
```

## Primitives
```haskell
item :: Parser Char
item = P (\s -> case s of [] -> []; (c:cs) -> [(c, cs)])

sat :: (Char -> Bool) -> Parser Char
sat p = do x <- item; if p x then return x else empty

digit = sat isDigit
char c = sat (== c)

space :: Parser ()
space = do _ <- many (sat isSpace); return ()

token :: Parser a -> Parser a
token p = do space; v <- p; space; return v

symbol :: String -> Parser String
symbol xs = token (mapM char xs)

nat :: Parser Int
nat = do xs <- some digit; return (read xs)

natural :: Parser Int
natural = token nat
```

## Grammar
```
expr   = term ('+' expr | ε)
term   = factor ('*' term | ε)
factor = '(' expr ')' | nat
```

## Recursive descent
```haskell
expr :: Parser Int
expr = do
  t <- term
  (do symbol "+"; e <- expr; return (t + e)) <|> return t

term :: Parser Int
term = do
  f <- factor
  (do symbol "*"; t <- term; return (f * t)) <|> return f

factor :: Parser Int
factor =
      (do symbol "("; e <- expr; symbol ")"; return e)
  <|> natural
```

## Run
```haskell
eval :: String -> Int
eval s = case parse expr s of
  [(n, "")] -> n
  _         -> error "parse error"
```

## Trace
```
parse expr "1+2*3"   -- [(7, "")]
parse expr "(1+2)*3" -- [(9, "")]
parse expr "1+2)*3"  -- [(3, ")*3")]   ← partial
```

## ⚠ Traps
- **Right-associative** by default (recursing right). For left-associative: use `chainl1`.
- **No left-recursion**: `expr = do e <- expr; …` infinite-loops
- Order `<|>` alternatives most-specific first
- Use `token` / `symbol` for whitespace skipping

## Pattern
[#16](../archetypes/16-parser.md) — parser combinators.

## See also
[Parser Newtype](../templates/parser-newtype.md) · [Alternative](../typeclasses/alternative.md)
