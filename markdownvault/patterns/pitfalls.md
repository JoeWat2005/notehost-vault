# Pitfalls — bugs that kill your QuickCheck score

[← INDEX](../INDEX.md) · [↑ Patterns](README.md) · [NAVIGATION](../NAVIGATION.md)

> See the newer, more complete [common-pitfalls](../common-pitfalls.md) for the master version.

## HIGH severity (instant fail)

### Wrong type signature
- Auto-marker matches **exactly**. Copy verbatim from template.
- Don't change variance or argument order.

### Importing non-allowed modules
- Only Prelude + provided `Types.hs`.
- Adding `import Data.Map` etc. breaks marking even if compile succeeds.

### Modifying template / Types.hs
- Don't change top of template (module declaration, language pragma).
- Don't redefine types from `Types.hs`.

### Non-exhaustive patterns
- QuickCheck WILL find `Empty` / `[]` / `Nothing` cases.
- Compile with `-fwarn-incomplete-patterns`.

### Empty-list edge case
- `head [] = ⊥`, `last [] = ⊥`, `maximum [] = ⊥`
- Always handle: `f [] = base ...`

## MEDIUM severity

### Off-by-one
- `take` / `drop` count
- Matrix anti-diagonal (`reverse grid` or `[n-1, n-2 ..]`)
- BST insert at equal key

### isBST Empty = False  ← WRONG
- Should be `True`. Student `githubinitial.hs` got this wrong.

### Shallow tree check
```haskell
-- WRONG: shallow, doesn't recurse
isNBranching n (Branch xs) = length xs == n
-- RIGHT: also checks children
isNBranching n (Branch xs) = length xs == n && all (isNBranching n) xs
```

### Copy-paste between near-identical cases
- `circuit (Or p q)` in `final10.hs`: `nq = Nand (circuit p) (circuit p)` — should be `q`
- Re-derive each case from spec, don't copy-modify.

### Confusing rows with cols
- `cols = transpose rows`, not `rows = transpose cols`
- TTT winner: check `rows ++ cols ++ diags`

### Swapping l/r when not intended
- `mirror`: yes, swap
- `mapBT`, `size`, `flatten`: no, keep order

### Forgetting one of the diagonals
- Matrix predicates need BOTH main and anti-diagonal

### Off-the-rails BST delete
- 4-case dispatch must be consistent
- "rightmost-of-left" must really return the rightmost

### `n <= 0` not just `n == 0`
- `myTake (-1) [...]` should return `[]`, not infinite loop

### Pattern-bind in do (typed Value)
```haskell
do IVal x <- eval env e1   -- triggers Monad-fail (gives Nothing) on type mismatch
```
This is INTENTIONAL in typed evaluators. Don't "fix" it.

## LOW severity (cosmetic)

- `get >>= put . f` when `modify f` would do
- Explicit recursion when `foldr` is cleaner
- Multi-line `where` when `let` is local enough
- `[x | x <- xs, p x]` vs `filter p xs` (both fine)

## Imports gotchas
- `Data.Sequence` exports `Empty` — conflicts with your `Tree` ctor
- `Data.Tree` exports `flatten` — conflicts with your own
- `System.Win32 (COORD(xPos))` — auto-import artifact, REMOVE before testing

## Exam-day checklist
1. Copy type sig verbatim from template
2. Cover all constructors / list cases (`Empty/Fork`, `[]/(x:xs)`)
3. Test edge case mentally: `[]`, `Empty`, `0`, `Nothing`, single-element
4. Run `presubmit.sh AssignmentN` before submitting
5. Don't import anything

## See also
[Triggers](triggers.md) · [Priority](../archetypes/00-priority.md) · [INDEX](../INDEX.md)
