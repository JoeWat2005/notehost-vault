# Archetype 05 — ADT-to-ADT Translation

[← INDEX](../INDEX.md) · [↑ Archetypes](README.md) · [NAVIGATION](../NAVIGATION.md)

⭐⭐⭐⭐ Mock Q5 (Expr → Circuit).

## Concept
Translate one syntax tree into another via per-constructor recursive rewrite. Possibly using algebraic identities to reduce to fewer primitives.

**Intuition:** for each source ctor, write the equivalent shape in the target ADT and recurse on children. When the target is more primitive (e.g. NAND-only), use algebraic identities (¬p ≡ p⊼p, p∧q ≡ ¬(p⊼q), etc.). `let`/`where` share repeated subtrees.

## Shape
```haskell
f (CtorA …)     = TargetA (f sub)
f (CtorB e1 e2) = TargetB (f e1) (f e2)
-- use let / where to share recursive subcomputation
```

## Typical sigs
```haskell
circuit :: Expr -> Circuit       -- Mock Q5
removeImplies :: Logic -> Logic
desugar :: SugarExpr -> CoreExpr
```

## Solution
[ADT To ADT Translation](../patterns/adt-to-adt-translation.md) · [Mock Q5 Circuit](../examples/mock-q5-circuit.md)

```haskell
circuit (Var x)       = Input x
circuit (Not p)       = Nand (circuit p) (circuit p)
circuit (And p q)     = Nand pq pq
  where pq = Nand (circuit p) (circuit q)
circuit (Or p q)      = Nand np nq
  where np = Nand (circuit p) (circuit p)
        nq = Nand (circuit q) (circuit q)    -- not p!
circuit (Implies p q) = circuit (Or (Not p) q)
```

## ⚠ Traps
- **Copy-paste bug**: `final10.hs` had `nq = Nand (circuit p) (circuit p)` — should be `q`
- Exponential code blow-up — let-bind shared subexpressions
- Missing a constructor (incomplete patterns)
- Wrong recursion depth (rewrite leaves only, missing subtrees)
- Typo in target constructor

## Combines with
[#01 Tree recursion](01-tree-recursion.md) · [#08 Eval](08-env-eval.md) · [#19 Extend interp](19-extend-interp.md)

## Seen
Mock Q5 (Expr → Nand-only Circuit), S15 #145, ewan20-31.hs (Logic removeImplies)

## See also
[Mock Q5 Circuit](../examples/mock-q5-circuit.md) · [ADT To ADT Translation](../patterns/adt-to-adt-translation.md)
