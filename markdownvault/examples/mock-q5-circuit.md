# Mock Q5 — Expr → Circuit (Nand-only)

[← INDEX](../INDEX.md) · [↑ Examples](README.md) · [NAVIGATION](../NAVIGATION.md)

10 marks: ADT-to-ADT translation using algebraic identities.

> **Technique:** one equation per source ctor. Where the target is more primitive (NAND-only), use algebraic identities to express each logical op as a NAND tree. `let`/`where` share subtrees to avoid recomputation.

## Spec
```haskell
data Expr =
    Var Char
  | Not Expr
  | And Expr Expr
  | Or  Expr Expr
  | Implies Expr Expr

data Circuit =
    Input Char
  | Nand Circuit Circuit

circuit :: Expr -> Circuit
```

Translate logical expression to NAND-only circuit.

## Algebraic identities
- `¬p ≡ p ⊼ p`
- `p ∧ q ≡ ¬(p ⊼ q) ≡ (p ⊼ q) ⊼ (p ⊼ q)`
- `p ∨ q ≡ ¬p ⊼ ¬q`  (de Morgan)
- `p → q ≡ ¬p ∨ q`

## Canonical solution
```haskell
circuit :: Expr -> Circuit
circuit (Var x)       = Input x
circuit (Not p)       = Nand (circuit p) (circuit p)
circuit (And p q)     = Nand pq pq
  where pq = Nand (circuit p) (circuit q)
circuit (Or p q)      = Nand np nq
  where np = Nand (circuit p) (circuit p)
        nq = Nand (circuit q) (circuit q)    -- ← careful! 'q' not 'p'
circuit (Implies p q) = circuit (Or (Not p) q)
```

## Pattern
[#05](../archetypes/05-adt-translation.md) — ADT-to-ADT translation.

## ⚠ Critical trap (student bug in `final10.hs`)
```haskell
-- WRONG copy-paste:
circuit (Or p q) = Nand np nq
  where np = Nand (circuit p) (circuit p)
        nq = Nand (circuit p) (circuit p)    -- BUG! should be q

-- RIGHT:
        nq = Nand (circuit q) (circuit q)
```

## Other traps
- Code blow-up: `let`/`where` to share `circuit p` (don't recompute)
- Forget Implies → keep all 5 ctors covered
- Implies via `Or` saves repeating the algebra (reuse other cases)

## See also
[ADT To ADT Translation](../patterns/adt-to-adt-translation.md) · [ADT Translation](../archetypes/05-adt-translation.md)
