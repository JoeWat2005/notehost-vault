# Exam Day Plan

[← INDEX](INDEX.md) · [NAVIGATION](NAVIGATION.md)

> **The plan in one sentence:** scan all 5 questions, do the easiest first, never get stuck for more than 5 minutes on any one question, and leave 15 minutes at the end to re-check.

## Format
- **2 hours · 5 questions × 10 marks = 50 total**
- **35+ = 1st class**
- **vLab** with `presubmit.sh`. Auto-marked by **QuickCheck**.
- **Allowed**: own notes (this vault), course materials, official book, [Hoogle](https://hoogle.haskell.org/)
- **NOT allowed**: StackOverflow, Google, ChatGPT/AI, collaboration
- **NO extra imports** — only Prelude + provided `Types.hs`

## Time budget (suggested)
| Phase              | Time     | Activity                                             |
|--------------------|----------|------------------------------------------------------|
| Scan all 5 Qs      | 5 min    | Identify archetypes; pick easiest first              |
| Q (easiest)        | 15 min   | Quick win, builds confidence                         |
| Q (next)           | 20 min   | Stay flexible — switch if stuck                      |
| Q                  | 20 min   |                                                      |
| Q                  | 20 min   |                                                      |
| Q (hardest)        | 25 min   | Most thought                                         |
| Buffer / re-check  | 15 min   | Edge cases (Empty, [], 0), run `presubmit.sh`        |

## Order of attack
1. **Easiest first** — bank the marks. Don't tackle in order shown.
2. Skip & return: if stuck for 5 min, move on
3. Stub out unsolved Qs with `undefined` so the file compiles
4. **Final 15 min**: run `presubmit.sh` — fix compile errors, NOT logic

## Pre-coding ritual (per Q)
For each question, BEFORE typing code:
1. **Copy the type sig** from the spec verbatim
2. **Identify the archetype** (use [If You See X](if-you-see-x.md))
3. **Look up the template** ([Common Templates](common-templates.md))
4. **List edge cases** mentally: empty input, single elem, 0, negative
5. Now code

## Likely composition (from Mock Test pattern)
| Q | Likely archetype                                | First-look file |
|---|------------------------------------------------|-----------------|
| 1 | Tree recursion (Rose or BT, 2 sub-parts)        | [Tree Recursion](tree-recursion.md) |
| 2 | Generic `Monad m =>` combinator                 | [Archetype 03](archetypes/03-generic-monad.md) |
| 3 | State monad game/sim                            | [State Monad](state-monad.md) |
| 4 | Matrix predicate via transpose OR Env evaluator | [Archetype 04](archetypes/04-matrix.md) / [Archetype 08](archetypes/08-env-eval.md) |
| 5 | ADT-to-ADT translation OR Functor instance      | [Archetype 05](archetypes/05-adt-translation.md) / [Archetype 06](archetypes/06-functor-instance.md) |

## Defensive coding (avoid auto-marker fails)
- ✓ Copy type sig **exactly** from template (no extra constraints, no reordered args)
- ✓ Don't import anything new — `Types.hs` only
- ✓ Don't modify template top (module declaration, language pragma)
- ✓ Cover ALL constructors / list cases — QuickCheck WILL test Empty / [] / Nothing
- ✓ Mental edge-case sweep before submitting
- ✗ NEVER edit `Types.hs`

## Mental edge-case checklist (apply to every function)
- `f []` defined?
- `f Empty` / `f Nothing` defined?
- `f 0`, `f (-1)`, `f 1`?
- Single-element list?
- Two-element list (for look-ahead patterns)?
- Singleton tree?
- Empty subtree (Fork x Empty Empty)?

## When you panic
1. Read [If You See X](if-you-see-x.md) — find the phrase in the question
2. Read [Common Templates](common-templates.md) — copy a similar skeleton
3. Read [Common Pitfalls](common-pitfalls.md) — don't repeat known bugs
4. **Don't blank-page**: write the type sig + base case + recursive case stub. Fill in.

## Pre-submit checklist
- [ ] All 5 Qs have at least a stub (don't leave `error "TODO"` — use `undefined`)
- [ ] File compiles in `stack repl` or `ghci`
- [ ] `./presubmit.sh AssignmentN` passes
- [ ] Submitted on vLab (not just saved locally)

## See also
[INDEX](INDEX.md) · [If You See X](if-you-see-x.md) · [Common Pitfalls](common-pitfalls.md) · [Archetype 00 Priority](archetypes/00-priority.md)
