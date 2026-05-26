# Archetype 19 — Extend an Interpreter

[← INDEX](../INDEX.md) · [↑ Archetypes](README.md) · [NAVIGATION](../NAVIGATION.md)

⭐⭐⭐ W10 Q1.

## Concept
Given working AST + parser + eval, add a new construct (if, while, for, new op).

**Intuition:** an interpreter has three layers — *syntax* (parser), *structure* (AST), *meaning* (eval). To add anything, touch all three. Forget one and it silently fails (parses but doesn't run, or vice versa).

## Shape — 3-layer change
1. **AST**: `data Expr += NewCtor …` or `data Program += NewStmt …`
2. **Parser**: new rule via `<|>`, fit precedence
3. **Evaluator**: new case in `eval` / `run`

## Example — add `for` loop

### 1. AST
```haskell
data Program = …
  | For Identifier Expr Expr Program     -- for i = lo to hi do body
```

### 2. Parser
```haskell
forStmt :: Parser Program
forStmt = do
  symbol "for"
  i  <- identif
  symbol "="
  lo <- expr
  symbol "to"
  hi <- expr
  symbol "do"
  body <- program
  return (For i lo hi body)
```

### 3. Evaluator
```haskell
run (For i lo hi body) m =
  let lo' = eval m lo
      hi' = eval m hi
      go n s
        | n > hi'    = s
        | otherwise  = go (n+1) (run body (update i n s))
  in go lo' m
```

## ⚠ Traps
- Forgetting one of the 3 layers (parser change without eval change = parsed-but-not-executed)
- Precedence placement (where in expr1..expr7?)
- Non-exhaustive patterns in eval (QuickCheck finds it)
- Scoping for new bindings (Let, lambda, for-loop counter)

## Combines with
[#16 Parser](16-parser.md) · [#08 Eval](08-env-eval.md) · [#05](05-adt-translation.md) (Cmd ADT design)

## Seen
W10 Q1 (do-while, if, for); A3-style extensions

## See also
[Overview](../interpreters/overview.md) · [Imperative Storage](../interpreters/imperative-storage.md) · [Parser Newtype](../templates/parser-newtype.md)
