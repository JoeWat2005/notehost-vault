# ADT-to-ADT Translation

[← INDEX](../INDEX.md) · [↑ Patterns](README.md) · [NAVIGATION](../NAVIGATION.md)

> **Mental model:** you've got two trees — a "source" language (rich) and a "target" language (often more primitive). For each constructor in the source, you write the equivalent shape in the target, recursing on children. Algebraic identities (`¬p = p ⊼ p`) tell you how to express rich operators in terms of primitive ones.

Translate one syntax tree into another by per-constructor recursive rewrite (Mock Q5).

## Shape
```haskell
f :: Source -> Target
f (CtorA …)     = TargetA (f sub)
f (CtorB e1 e2) = … combine (f e1) (f e2) …
```
Use algebraic identities where target is more primitive than source. Share subtrees with `let`/`where` to avoid quadratic blow-up.

## Mock Q5: Expr → Nand-only Circuit
```haskell
data Expr    = Var Char | Not Expr | And Expr Expr
             | Or Expr Expr | Implies Expr Expr
data Circuit = Input Char | Nand Circuit Circuit

circuit :: Expr -> Circuit
circuit (Var x)       = Input x
circuit (Not p)       = Nand (circuit p) (circuit p)
circuit (And p q)     = Nand pq pq
  where pq = Nand (circuit p) (circuit q)
circuit (Or p q)      = Nand np nq
  where np = Nand (circuit p) (circuit p)
        nq = Nand (circuit q) (circuit q)
circuit (Implies p q) = circuit (Or (Not p) q)
```

Identities used:
- ¬p ≡ p ⊼ p
- p ∧ q ≡ ¬(p ⊼ q) ≡ (p⊼q) ⊼ (p⊼q)
- p ∨ q ≡ ¬¬p ⊼ ¬¬q  ≡  ¬p ⊼ ¬q via de Morgan negated
- p → q ≡ ¬p ∨ q

## Logic normalisation (removeImplies)
```haskell
removeImplies (LVar x)       = LVar x
removeImplies (LNot p)       = LNot (removeImplies p)
removeImplies (LAnd p q)     = LAnd (removeImplies p) (removeImplies q)
removeImplies (LOr p q)      = LOr (removeImplies p) (removeImplies q)
removeImplies (LImplies p q) = LOr (LNot (removeImplies p)) (removeImplies q)
```

## ⚠ Pitfalls
- **Copy-paste between cases**: e.g. `circuit (Or p q)` with `nq = Nand (circuit p) (circuit p)` — should be `circuit q`
- Code blow-up: `let` / `where` to share subexpressions
- Missing a constructor (incomplete patterns → exam-killer)
- Wrong recursion depth (apply rewrite to leaves only, missing subtrees)

## See also
[ADT Translation](../archetypes/05-adt-translation.md) · [Mock Q5 Circuit](../examples/mock-q5-circuit.md) · [Tree Recursion](tree-recursion.md)
