# Template — Common ADT declarations

[← INDEX](../INDEX.md) · [↑ Templates](README.md) · [NAVIGATION](../NAVIGATION.md)

> **What this pattern is doing:** an *algebraic data type* enumerates the shapes a value can take. Each `|` is a constructor (a tag); each constructor carries some fields. Recursive ADTs reference themselves in those fields, giving you trees, lists, ASTs, etc.

## Standard library shapes
```haskell
data Maybe a    = Nothing | Just a
data Either a b = Left a  | Right b
data Bool       = False   | True
data Ordering   = LT | EQ | GT
```

## Recursive lists / trees
```haskell
data List a   = Nil | Cons a (List a)
data BT a     = Empty | Fork a (BT a) (BT a)
data Rose a   = Leaf a | Branch [Rose a]
data Tree a   = Node a [Tree a]           -- variant
data Bin a    = Lf | Nd a (Bin a) (Bin a) -- variant
```

## Lookup / trie
```haskell
data Tree = Empty | Branch (Maybe Char) Tree Tree    -- Morse (monomorphic)
```

## Expression / interpreter ASTs
```haskell
data Expr =
    Val Int
  | Var String
  | Add Expr Expr
  | Mul Expr Expr
  | Neg Expr

data BoolExpr = BoolVal Bool | And BoolExpr BoolExpr | Or BoolExpr BoolExpr

data Value = BVal Bool | IVal Int

data Logic =
    LVar Char
  | LNot Logic
  | LAnd Logic Logic
  | LOr Logic Logic
  | LImplies Logic Logic

data Circuit = Input Char | Nand Circuit Circuit

data Program =
    Identifier := Expr
  | Block [Program]
  | While Expr Program
  | If Expr Program
  | IfElse Expr Program Program
```

## Course-specific
```haskell
-- TTT
data Player = O | B | X    deriving (Eq, Ord, Show)
type Grid   = [[Player]]

-- Navigation
data Direction = L | R
type Address   = [Direction]
type Route     = [Direction]

-- Lazy Peano
data Nat = Zero | Succ Nat   deriving (Eq, Ord)

-- Bifunctor tree (W5)
data BinLN a b = LeafLN b | NodeLN (BinLN a b) a (BinLN a b)

-- Functor sum (A3)
data FSum f g a = FLeft (f a) | FRight (g a)

-- Free monad (A3)
data Free f a = Pure a | Free (f (Free f a))

-- Heap / game (Mock)
data Heap = First | Second
type NimGame a = State (Int, Int) a

-- Morse
data Atom = Beep | Silence   deriving (Eq, Show)
type Code = [Atom]
type Table = [(Char, Code)]
```

## Zipper (A1)
```haskell
newtype Grid a = Grid { grid :: [[a]] }   deriving Eq
newtype GridWithAPointer a =
  GridWithAPointer (Grid a, [a], a, [a], Grid a)
-- (gridAbove, leftRowReversed, focus, rightRow, gridBelow)
```

## Conventions
- `Empty` / `Nothing` / `Nil` for base case ctor
- `Fork` / `Just` / `Cons` / `Node` / `Branch` for recursive
- Always derive `Eq, Show` unless told otherwise

## See also
[INDEX](../INDEX.md) · [Tree Recursion](../patterns/tree-recursion.md) · [Functor](../typeclasses/functor.md)
