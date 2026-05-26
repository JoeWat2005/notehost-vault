# Imperative Interpreter (Storage-as-function)

[← INDEX](../INDEX.md) · [↑ Interpreters](README.md) · [NAVIGATION](../NAVIGATION.md)

> **Mental model:** "memory" is just a function `String -> Integer` — variable name to value. Statements *transform* memory (`Storage -> Storage`); expressions *read* memory (`Storage -> Integer`). `update` returns a new memory with one variable rebound. No mutation, just pure functional plumbing.

Lecture pattern: Storage = `Identifier -> Integer`, programs are storage transformers.

## Types
```haskell
type Identifier = String
type Storage    = Identifier -> Integer

data OpName = Or | And | Eq | Leq | Less | Geq | Greater
            | Add | Sub | Mul | Div | Mod | Not

data Expr =
    Constant Integer
  | Var Identifier
  | Op OpName [Expr]

data Program =
    Identifier := Expr
  | Block [Program]
  | While Expr Program
  | If Expr Program
  | IfElse Expr Program Program
```

## Storage operations
```haskell
emptyStorage :: Storage
emptyStorage = \_ -> error "uninitialised"

update :: Identifier -> Integer -> Storage -> Storage
update i x m = \j -> if i == j then x else m j
```

## Evaluator
```haskell
eval :: Storage -> Expr -> Integer
eval m (Constant n) = n
eval m (Var x)      = m x
eval m (Op o es)    = opEval o (map (eval m) es)

opEval :: OpName -> [Integer] -> Integer
opEval Add [x, y] = x + y
opEval Sub [x, y] = x - y
opEval Mul [x, y] = x * y
opEval Div [x, y] = x `div` y
opEval Not [x]    = number (not (boolean x))
-- … etc.

number :: Bool -> Integer
number True  = 1
number False = 0

boolean :: Integer -> Bool
boolean 0 = False
boolean _ = True
```

## Runner (program → storage transformer)
```haskell
run :: Program -> Storage -> Storage
run (i := e) m = update i (eval m e) m
run (Block []) m = m
run (Block (p:ps)) m = run (Block ps) (run p m)

run (While e p) m
  | boolean (eval m e) = run (While e p) (run p m)
  | otherwise          = m

run (If e p) m
  | boolean (eval m e) = run p m
  | otherwise          = m

run (IfElse e p q) m
  | boolean (eval m e) = run p m
  | otherwise          = run q m
```

## Point-free combinator alternative
```haskell
assign :: Identifier -> Expr -> Storage -> Storage
assign i e m = update i (eval m e) m

block :: [Storage -> Storage] -> Storage -> Storage
block fs = foldr (.) id (reverse fs)

while :: (Storage -> Bool) -> (Storage -> Storage) -> (Storage -> Storage)
while cond body s = if cond s then while cond body (body s) else s
```

## ⚠ Pitfalls
- `emptyStorage` errors on lookup — initialise with `initialStorage`
- Block ordering — must apply programs left-to-right
- `While` recurses infinitely if condition never becomes 0
- Pattern `(Identifier :=)` — use `(x := e)` to match assignment

## See also
[Overview](overview.md) · [Extend Interp](../archetypes/19-extend-interp.md) · [State](../monads/state.md)
