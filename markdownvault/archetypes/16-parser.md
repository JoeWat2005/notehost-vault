# Archetype 16 — Parser Combinators

[← INDEX](../INDEX.md) · [↑ Archetypes](README.md) · [NAVIGATION](../NAVIGATION.md)

⭐⭐ W10 (optional XML/JSON), S14 #138-140, A2 Q6.

## Concept
Parse a String into a structured value using monadic parser combinators.

**Intuition:** a `Parser a` consumes a prefix and emits an `a`. `do` sequences parsers (then this, then that), `<|>` tries alternatives. The grammar in code is one-to-one with the BNF.

## Shape
```haskell
newtype Parser a = P (String -> [(a, String)])
-- primitives: item, sat, char, string, many, some, token
-- grammar: recursive descent with <|>
```

## Typical sigs
```haskell
parse :: Parser a -> String -> [(a, String)]
item, digit, lower :: Parser Char
many, some :: Parser a -> Parser [a]
expr, term, factor :: Parser Int
```

## Solution
[Parser Newtype](../templates/parser-newtype.md) · [Expr Parser](../examples/expr-parser.md)

## ⚠ Traps
- **Left recursion**: `expr = do {e <- expr; …}` infinite-loops; refactor to `chainl1`
- Greedy `<|>` doesn't backtrack — order alternatives MOST-SPECIFIC first
- Forgetting `token` to skip surrounding whitespace
- Empty parse-result list = failure (not exception)
- Course uses `[(a, String)]`; some live-code uses `Maybe (a, String)`

## Combines with
[Monad](../typeclasses/monad.md) · [Alternative](../typeclasses/alternative.md) · [#01 ADT](01-tree-recursion.md) · [#19](19-extend-interp.md)

## Seen
W10 problem sheet (optional), S14 #138-140, A2 Q6 (bracket parser via Maybe-stack)

## See also
[Parser Newtype](../templates/parser-newtype.md) · [Expr Parser](../examples/expr-parser.md)
