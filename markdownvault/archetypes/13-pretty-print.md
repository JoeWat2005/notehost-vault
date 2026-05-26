# Archetype 13 — Custom Show / Pretty-Printer

[← INDEX](../INDEX.md) · [↑ Archetypes](README.md) · [NAVIGATION](../NAVIGATION.md)

⭐⭐ A1 (GridWithAPointer), S7 #64, Data2.

## Concept
Implement `instance Show T` to display custom type nicely (possibly with formatting / ANSI escapes).

**Intuition:** one `show` equation per constructor. Recursively `show` sub-values and concatenate with string literals for punctuation.

## Shape
```haskell
instance Show T where
  show (Ctor1 a)     = "C1 " ++ show a
  show (Ctor2 a b)   = "C2 (" ++ show a ++ ", " ++ show b ++ ")"
```

## Typical sigs
```haskell
instance Show MyType where show :: MyType -> String
```

## Solution

### Simple (Color hex)
```haskell
data Color = Red | Green | Blue | Custom Int Int Int

instance Show Color where
  show Red          = "#FF0000"
  show Green        = "#00FF00"
  show Blue         = "#0000FF"
  show (Custom r g b) = "#" ++ toHex r ++ toHex g ++ toHex b

toHex :: Int -> String
toHex n = [hexDigit (n `div` 16), hexDigit (n `mod` 16)]
  where hexDigit i = "0123456789ABCDEF" !! i
```

### ANSI-highlighted (A1)
```haskell
-- Wrap focus cell with background colour
hilight :: Show a => a -> String
hilight x = "\ESC[44m" ++ show x ++ "\ESC[0m"
```

### Precedence-stratified (Data2)
```haskell
instance Show a => Show (Expr a) where
  show e = show3 e
    where
      show3 (Add e f) = show2 e ++ " + " ++ show3 f
      show3 e         = show2 e
      show2 (Mul e f) = show1 e ++ " * " ++ show2 f
      show2 e         = show1 e
      show1 (Negate e) = "-" ++ show1 e
      show1 (Value v)  = show v
      show1 e          = "(" ++ show3 e ++ ")"
```

## ⚠ Traps
- Precedence (parens around `(a + b) * c`) — needs Int-arg `showsPrec`
- Reusing existing Show: use `show e` not just `e`
- Escape sequences need backslash-escape in Haskell strings (`"\ESC"`)
- Newlines / column padding for grid display
- Recursive structure → infinite loop if not bounded

## Combines with
ADTs · IO (rendering) · record syntax · [IO](../monads/io.md)

## Seen
A1 (whole pretty-print with ANSI), S7 #64 (Color hex), Data2 (precedence Expr)

## See also
[Custom Instances](../typeclasses/custom-instances.md) · [IO](../monads/io.md)
