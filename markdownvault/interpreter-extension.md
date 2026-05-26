# Interpreter Extension — 3-Layer Change

[← INDEX](INDEX.md) · [NAVIGATION](NAVIGATION.md)

Adding a new construct (operator, statement, expression) to an existing interpreter.

> **Mental model:** an interpreter has three independent layers — *what the syntax looks like* (parser), *what the language allows* (AST data type), and *what it means* (evaluator). When you add a new construct, you must touch ALL THREE. Forget any one and the construct silently fails.

## The 3 layers (NEVER FORGET ANY)
```
       1. AST                  2. PARSER                3. EVALUATOR
   data Expr +=            new rule via <|>        new pattern case
   data Program +=         fit precedence          in eval / run
```

---

## TEMPLATE — adding a new statement

### Layer 1: AST
```haskell
data Program = …                            -- existing constructors
  | NewStmt args …                          -- ← add ctor
```

### Layer 2: Parser
```haskell
parseProgram :: Parser Program
parseProgram =
      parseAssign
  <|> parseBlock
  <|> parseWhile
  <|> parseNewStmt           -- ← add alternative
```

```haskell
parseNewStmt :: Parser Program
parseNewStmt = do
  symbol "newkeyword"
  arg1 <- parseExpr
  arg2 <- parseProgram
  return (NewStmt arg1 arg2)
```

### Layer 3: Evaluator
```haskell
run :: Program -> Storage -> Storage
-- existing cases …
run (NewStmt e body) m = …                  -- ← add case
```

---

## WORKED EXAMPLE — adding `for` loop

### 1. AST
```haskell
data Program =
    Identifier := Expr
  | Block [Program]
  | While Expr Program
  | If Expr Program
  | IfElse Expr Program Program
  | For Identifier Expr Expr Program        -- ← NEW
```

### 2. Parser
```haskell
parseFor :: Parser Program
parseFor = do
  symbol "for"
  i  <- identif
  symbol "="
  lo <- parseExpr
  symbol "to"
  hi <- parseExpr
  symbol "do"
  body <- parseProgram
  return (For i lo hi body)
```
Then add `<|> parseFor` to the program parser.

### 3. Evaluator
```haskell
run (For i lo hi body) m =
  let lo' = eval m lo
      hi' = eval m hi
      go n s
        | n > hi'   = s
        | otherwise = go (n + 1) (run body (update i n s))
  in go lo' m
```

---

## WORKED EXAMPLE — adding `do-while`

### 1. AST
```haskell
data Program = … | DoWhile Program Expr     -- ← NEW
```

### 2. Parser
```haskell
parseDoWhile :: Parser Program
parseDoWhile = do
  symbol "do"
  body <- parseProgram
  symbol "while"
  cond <- parseExpr
  return (DoWhile body cond)
```

### 3. Evaluator
```haskell
run (DoWhile p e) m =
  let m' = run p m
  in if eval m' e /= 0
       then run (DoWhile p e) m'
       else m'
```

---

## WORKED EXAMPLE — adding `++`/`--` (post-inc/dec)

### 1. AST
```haskell
data Program = … | Inc Identifier | Dec Identifier
```

### 2. Parser
```haskell
parseInc = do
  i <- identif
  symbol "++"
  return (Inc i)

parseDec = do
  i <- identif
  symbol "--"
  return (Dec i)
```

### 3. Evaluator
```haskell
run (Inc i) m = update i (m i + 1) m
run (Dec i) m = update i (m i - 1) m
```

---

## ADDING A NEW OPERATOR (e.g. modulo)

### 1. AST
```haskell
data OpName = Add | Sub | Mul | Div | Mod   -- ← already had Mod, but if not, add it
```

### 2. Parser
```haskell
mulOp = parseOp "*" Mul <|> parseOp "/" Div <|> parseOp "%" Mod   -- ← add
```

### 3. Evaluator
```haskell
opEval Mod [x, y] = x `mod` y               -- ← add
```

---

## EXTENDING TO USE STATE (replace Storage with monad)

If asked to monadify the evaluator:
```haskell
type Stored = State Storage

eval :: Expr -> Stored Integer
eval (Var x) = do m <- get; return (m x)
eval (Op o es) = do
  vs <- mapM eval es
  return (opEval o vs)

run :: Program -> Stored ()
run (i := e) = do
  v <- eval e
  modify (update i v)
run (Block ps) = mapM_ run ps
run (While e p) = do
  v <- eval e
  if v /= 0
    then do run p; run (While e p)
    else return ()
```

---

## ADDING MAYBE FOR ERRORS

```haskell
eval :: Storage -> Expr -> Maybe Integer
eval m (Var x)   = Just (m x)              -- or `lookup x m` for partial
eval m (Op Div [a, b]) = do
  x <- eval m a
  y <- eval m b
  if y == 0 then Nothing else Just (x `div` y)

run :: Program -> Storage -> Maybe Storage
run (i := e)       m = do v <- eval m e; return (update i v m)
run (Block [])     m = Just m
run (Block (p:ps)) m = do m' <- run p m; run (Block ps) m'
```

---

## ⚠ TRAPS
- **Forgetting any one of the 3 layers**:
  - Add to AST but not parser → can't construct it via source
  - Add to parser but not eval → "parsed but not executed" silent bug
  - Add to eval but not AST → won't compile
- **Precedence**: where in `expr / expr1 / … / expr7` does new op fit?
- **Non-exhaustive patterns** in eval → QuickCheck finds it
- **Scoping** for new binders (let, lambda, for): extend env properly
- **Whitespace handling**: use `token` / `symbol` for keywords

---

## SIGNATURES TO MEMORISE
```haskell
type Identifier = String
type Storage    = Identifier -> Integer

emptyStorage :: Storage
update       :: Identifier -> Integer -> Storage -> Storage
eval         :: Storage -> Expr -> Integer
run          :: Program -> Storage -> Storage

parseProgram :: Parser Program
parseExpr    :: Parser Expr
```

## See also
[Common Templates](common-templates.md) §20 · [Imperative Storage](interpreters/imperative-storage.md) · [Multi Effect Eval](interpreters/multi-effect-eval.md) · [Extend Interp](archetypes/19-extend-interp.md)
