# Template — Parser combinator (newtype Parser)

[← INDEX](../INDEX.md) · [↑ Templates](README.md) · [NAVIGATION](../NAVIGATION.md)

> **What this pattern is doing:** a `Parser a` is "consume some prefix of the input and produce an `a`, leaving the rest." `do` sequences parsers; `<|>` is alternatives; `many`/`some` are repetition. The grammar in code mirrors the BNF.

## Core type
```haskell
newtype Parser a = P (String -> [(a, String)])

parse :: Parser a -> String -> [(a, String)]
parse (P p) = p
```

## Instances (often pre-supplied)
```haskell
instance Functor Parser where
  fmap f (P p) = P (\s -> [(f x, s') | (x, s') <- p s])

instance Applicative Parser where
  pure x      = P (\s -> [(x, s)])
  P p <*> P q = P (\s -> [(f x, s'') | (f, s') <- p s, (x, s'') <- q s'])

instance Monad Parser where
  P p >>= f = P (\s -> concat [parse (f x) s' | (x, s') <- p s])

instance Alternative Parser where
  empty       = P (\_ -> [])
  P p <|> P q = P (\s -> case p s of [] -> q s; rs -> rs)
```

## Primitives
```haskell
item :: Parser Char
item = P (\s -> case s of [] -> []; (c:cs) -> [(c, cs)])

sat :: (Char -> Bool) -> Parser Char
sat p = do x <- item; if p x then return x else empty

char :: Char -> Parser Char
char c = sat (== c)

digit, lower, upper, alphanum :: Parser Char
digit = sat isDigit
lower = sat isLower
upper = sat isUpper
alphanum = sat isAlphaNum

string :: String -> Parser String
string []     = return []
string (c:cs) = do char c; string cs; return (c:cs)
```

## Whitespace + tokens
```haskell
space :: Parser ()
space = do _ <- many (sat isSpace); return ()

token :: Parser a -> Parser a
token p = do space; v <- p; space; return v

symbol :: String -> Parser String
symbol xs = token (string xs)

nat :: Parser Int
nat = do xs <- some digit; return (read xs)

natural :: Parser Int
natural = token nat
```

## Grammar (recursive descent)
```haskell
-- expr   = term ('+' expr | ε)
-- term   = factor ('*' term | ε)
-- factor = '(' expr ')' | nat

expr :: Parser Int
expr = do
  t <- term
  (do symbol "+"; e <- expr; return (t + e)) <|> return t

term :: Parser Int
term = do
  f <- factor
  (do symbol "*"; t <- term; return (f * t)) <|> return f

factor :: Parser Int
factor = (do symbol "("; e <- expr; symbol ")"; return e)
     <|> natural
```

## See also
[Alternative](../typeclasses/alternative.md) · [Parser](../archetypes/16-parser.md) · [Expr Parser](../examples/expr-parser.md)
