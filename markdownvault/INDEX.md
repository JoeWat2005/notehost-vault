# Haskell Exam Vault — INDEX

> 🆕 **First time here?** → Read [HOW-TO-USE](HOW-TO-USE.md) (the user manual)
> 🚨 **Panicking with 5 min left?** → [ONE-PAGE](ONE-PAGE.md)
> 🗺  **Just need a file?** → [NAVIGATION](NAVIGATION.md) (alphabetical jump-table)

Birmingham FP 2025/26. Mock-test style exam reference. **112 files.**

> **Mental model:** every Haskell exam question is "recognise the shape → pull the template → adapt". This vault is organised exactly along that workflow.

## VS Code preview hotkeys
| Action | Shortcut |
|--------|----------|
| Open preview (side-by-side) | `Ctrl+K V` |
| Open preview (replace tab) | `Ctrl+Shift+V` |
| Jump to file by name | `Ctrl+P` |
| Search across vault | `Ctrl+Shift+F` |
| Follow link | `Ctrl+Click` |
| **Go BACK** to prior file | `Ctrl+Alt+-` |
| Go forward | `Ctrl+Alt+=` |
| Pin tab | `Ctrl+K Shift+Enter` |

Every file has a breadcrumb header: `[← INDEX] · [↑ Category] · [NAVIGATION]`.

---

## ⭐ TOP-PRIORITY FILES (open these first)

### Meta / how-to
1. [HOW-TO-USE](HOW-TO-USE.md) — user manual, workflow, FAQ
2. [ONE-PAGE](ONE-PAGE.md) — single-screen panic reference
3. [exam-day-plan](exam-day-plan.md) — 2-hour time budget + checklist

### Lookup (use when reading a question)
4. [if-you-see-x](if-you-see-x.md) — phrase → pattern tables
5. [type-signature-decoder](type-signature-decoder.md) — sig shape → template
6. [common-templates](common-templates.md) — 20 reusable skeletons in one file
7. [common-pitfalls](common-pitfalls.md) — exact-marker bugs to avoid

### Hot topics (Tier-1 lecture material)
8. [tree-recursion](tree-recursion.md) — #1 archetype, every variant
9. [mapM](mapm.md) — monadic traversal
10. [functor](functor.md) — every Functor instance + rule + laws
11. [state-monad](state-monad.md) — get / put / modify / run / Nim / label
12. [list-comprehensions](list-comprehensions.md) — Tier-1 lecture topic
13. [higher-order-functions](higher-order-functions.md) — Tier-1 lecture topic
14. [interpreter-extension](interpreter-extension.md) — 3-layer AST+parser+eval

### Reference (when you forget something)
15. [prelude-cheatsheet](prelude-cheatsheet.md) — every Prelude / Data.List / Data.Char / Control.Monad function
16. [data-list-char-cheatsheet](data-list-char-cheatsheet.md) — focused with idioms
17. [ghci-tips](ghci-tips.md) — :t, :i, debugging, common errors

---

## Exam meta
- **2h, 5 Q × 10 = 50.** 35+ = 1st class.
- **Open book**: notes / book / Hoogle. NO Google / SO / AI / collaboration.
- **vLab + `presubmit.sh`**. Auto-marked by **QuickCheck — exact type sigs required.**
- No extra imports beyond Prelude + provided `Types.hs`.
- Mock test = single best practice. Do cold, mark with `MockTestSolutions.hs`.
- **Likely Q composition**: Q1 tree-rec · Q2 generic Monad · Q3 State game · Q4 matrix or env-eval · Q5 ADT-translation or Functor instance

See [exam-day-plan](exam-day-plan.md) for full strategy.

---

## Categorised file index

Each subdirectory has a `README.md` listing its files. Use `[↑ Category]` link in any file header to reach it.

### 📂 [patterns/](patterns/README.md) (12 files)
Cross-cutting code shapes: cons-recursion, accumulator, fold recipes, traversals, codec, ADT translation, lazy memoisation.

### 📂 [typeclasses/](typeclasses/README.md) (6 files)
Functor, Applicative, Monad, Alternative, Eq/Ord/Num, custom instances.

### 📂 [monads/](monads/README.md) (11 files)
Maybe, Either, State, Writer, IO, Reader, List monad, MonadError, Multi-effect, Free.

### 📂 [interpreters/](interpreters/README.md) (6 files)
Pure eval → Env eval → MonadError → Multi-effect → Imperative `:=`/While storage.

### 📂 [templates/](templates/README.md) (13 files)
Pure copy-paste-and-adapt skeletons.

### 📂 [archetypes/](archetypes/README.md) (21 files)
20 ranked exam-question shapes + [priority matrix](archetypes/00-priority.md).

### 📂 [examples/](examples/README.md) (17 files)
Worked Mock Q (5) + assignment solutions (3) + lecture-derived (4) + skill demos (5).

---

## Exam-archetype quick-jump

| Archetype | ⭐ | File |
|-----------|----|------|
| Tree recursion | ⭐⭐⭐⭐⭐ | [01](archetypes/01-tree-recursion.md) |
| State game | ⭐⭐⭐⭐⭐ | [02](archetypes/02-state-game.md) |
| Generic Monad | ⭐⭐⭐⭐ | [03](archetypes/03-generic-monad.md) |
| Matrix predicate | ⭐⭐⭐⭐ | [04](archetypes/04-matrix.md) |
| ADT translation | ⭐⭐⭐⭐ | [05](archetypes/05-adt-translation.md) |
| Functor instance | ⭐⭐⭐⭐ | [06](archetypes/06-functor-instance.md) |
| Env evaluator | ⭐⭐⭐⭐ | [08](archetypes/08-env-eval.md) |
| Codec pair | ⭐⭐⭐ | [07](archetypes/07-codec.md) |
| Reimpl Prelude | ⭐⭐⭐ | [09](archetypes/09-prelude-reimpl.md) |
| Fold reformulation | ⭐⭐⭐ | [10](archetypes/10-fold.md) |
| BST ops | ⭐⭐⭐ | [11](archetypes/11-bst.md) |
| Multi-effect interp | ⭐⭐⭐ | [14](archetypes/14-multi-effect.md) |
| Extend interpreter | ⭐⭐⭐ | [19](archetypes/19-extend-interp.md) |
| Rep conversion | ⭐⭐ | [12](archetypes/12-rep-conv.md) |
| Pretty print | ⭐⭐ | [13](archetypes/13-pretty-print.md) |
| Writer trace | ⭐⭐ | [15](archetypes/15-writer-trace.md) |
| Parser combinators | ⭐⭐ | [16](archetypes/16-parser.md) |
| Lazy memo | ⭐⭐ | [18](archetypes/18-memo.md) |
| Zipper | ⭐ | [17](archetypes/17-zipper.md) |
| Iso / laws | ⭐ | [20](archetypes/20-laws.md) |

## Mock-test worked solutions

- [Mock Q1 Rose](examples/mock-q1-rose.md) — Rose tree predicate + prune
- [Mock Q2 applyNTimes](examples/mock-q2-applyNTimes.md) — Generic Monad combinator
- [Mock Q3 Nim](examples/mock-q3-nim.md) — State monad game
- [Mock Q4 Magic Square](examples/mock-q4-magic-square.md) — Matrix predicate via transpose
- [Mock Q5 Circuit](examples/mock-q5-circuit.md) — Expr → Nand-only Circuit translation

## Core intuitions (memorise these one-liners)
- **Functor** = "preserve structure, transform values" — `fmap :: (a -> b) -> f a -> f b`
- **Applicative** = "apply wrapped fn to wrapped value" — `(<*>) :: f (a -> b) -> f a -> f b`
- **Monad** = "chain dependent contexted computations" — `(>>=) :: m a -> (a -> m b) -> m b`
- **State** = "hide an accumulator in a `do`-block"
- **Writer** = "side-channel log combined via Monoid"
- **`foldr`** = "replace `(:)` with `op`, `[]` with `b`"
- **`mapM`** = "`map` but each step is a monadic effect, collected"
- **Recursive ADTs** = one equation per constructor; recurse on children

## The bottom line

If you can recognise + look up + adapt a template in 5 minutes, you will pass. 35+ marks = 1st class. Trust the vault.

🎯 **Read [HOW-TO-USE](HOW-TO-USE.md) once before the exam. Pin [ONE-PAGE](ONE-PAGE.md) on exam day.**
