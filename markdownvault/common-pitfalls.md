# Common Pitfalls — Bugs that kill QuickCheck score

[← INDEX](INDEX.md) · [NAVIGATION](NAVIGATION.md)

The exam is auto-marked by QuickCheck: it runs your function against many random inputs and compares to a reference. A single wrong character in the type signature can score you 0. Skim this file before submitting.

> **Severity legend**: 🔴 = instant fail, 🟡 = partial credit lost, 🟢 = cosmetic / style.

## 🔴 HIGH severity (instant fail)

### Wrong type signature
- Auto-marker matches **exactly**. Copy verbatim from template.
- Don't reorder args, change variance, add constraints.

### Importing non-allowed modules
- Only Prelude + provided `Types.hs`.
- Adding `import Data.Map` etc. breaks marking.
- Even if it COMPILES on your machine, marking fails.

### Modifying template / Types.hs
- Don't change top of template (`module`, language pragmas).
- Don't redefine types from `Types.hs`.

### Non-exhaustive patterns
- QuickCheck WILL find `Empty` / `[]` / `Nothing` cases.
- Compile with `-fwarn-incomplete-patterns`.

### Empty-list edge case
```haskell
head []   = ⊥    -- crashes
last []   = ⊥
maximum [] = ⊥
```
Always handle: `f [] = base ...`

### Submission file naming
- Must be `AssignmentN.hs` exactly (not `assignment1.hs` etc.)
- Run `./presubmit.sh AssignmentN` before submitting

---

## 🟡 MEDIUM severity (partial credit)

### isBST Empty = False  ← WRONG
**Why:** an empty tree vacuously satisfies BST ordering — there are no nodes to be out-of-order. So it counts as `True`.
```haskell
-- WRONG (student bug in githubinitial.hs):
isBST Empty = False
-- RIGHT:
isBST Empty = True
```

### Shallow tree check
**Why:** the property must hold *everywhere* in the tree, not just at the root. Always recurse with `all rec children` (or `all . map rec`).
```haskell
-- WRONG: doesn't recurse
isNBranching n (Branch xs) = length xs == n
-- RIGHT:
isNBranching n (Branch xs) = length xs == n && all (isNBranching n) xs
```

### Copy-paste bug between near-identical cases
```haskell
-- WRONG (student bug in final10.hs):
circuit (Or p q) = Nand np nq
  where np = Nand (circuit p) (circuit p)
        nq = Nand (circuit p) (circuit p)   -- ← should be 'q'!
```
Re-derive each case from spec; don't copy-modify.

### Confusing rows with cols
```haskell
cols = transpose rows    -- ✓
rows = transpose cols    -- ✗ wrong direction
```

### Swapping l/r when not intended
- `mirror`: yes swap
- `mapBT`, `size`, `flatten`, `mapMTree`: NO swap

### Forgetting anti-diagonal
- Matrix predicates need BOTH main and anti-diagonal
```haskell
diag1 = zipWith (!!) xss [0..]
diag2 = zipWith (!!) (reverse xss) [0..]
```

### Off-by-one in take/drop
```haskell
-- WRONG: forgets n <= 0 case
myTake n (x:xs) = x : myTake (n-1) xs
-- RIGHT:
myTake n _ | n <= 0 = []
myTake _ []         = []
myTake n (x:xs)     = x : myTake (n-1) xs
```

### Underflow without clamp (State games)
```haskell
-- WRONG: can go negative
put (x - n, y)
-- RIGHT:
put (max 0 (x - n), y)
```

### Pattern-bind in do is INTENTIONAL (typed values)
```haskell
do IVal x <- eval env e1   -- triggers Monad-fail → Nothing on type mismatch
```
This is correct in typed evaluators. Don't "fix" it.

### O(n²) reverse
```haskell
-- WRONG: O(n²)
myReverse []     = []
myReverse (x:xs) = myReverse xs ++ [x]
-- RIGHT: O(n) via accumulator
fastReverse xs = go xs [] where go [] acc = acc; go (x:xs) acc = go xs (x:acc)
```

### BST delete inconsistency
- Pick one rule (rightmost-of-left OR leftmost-of-right) — stay consistent

### Forgetting `n <= 0` not just `n == 0`
- `myTake (-1) xs` should return `[]`, not infinite loop

### Local-only BST check (forgetting to thread bounds)
```haskell
-- WRONG: only checks local Fork property
isBST (Fork x l r) = lowestOf r > x && highestOf l < x && isBST l && isBST r
-- RIGHT: thread bounds top-down
isBST t = go Nothing Nothing t
```

---

## 🟢 LOW severity (cosmetic)

- `get >>= put . f` when `modify f` would do
- Explicit recursion when `foldr` is cleaner
- Multi-line `where` when `let` is local enough
- `[x | x <- xs, p x]` vs `filter p xs` (both fine)

---

## 🚫 IMPORTS GOTCHAS (auto-import artefacts)

Remove these before testing — student files often have them:
```haskell
import System.Win32 (COORD(xPos))     -- IDE auto-completed garbage
import Data.Sequence (Seq(Empty))     -- conflicts with your Tree ctor
import Data.Tree (flatten)            -- conflicts with your flatten
```

---

## 🧠 Recursion mistakes (intuition)

- **Missing base case** → infinite loop. Every recursive function needs `[] / Empty / 0 / Nothing` handled.
- **Recursion not progressing** → bug like `f xs = f xs` or forgetting to pass the *tail*. Make sure each call gets *smaller* input.
- **Wrong shape on rebuild** → for `fmap`/`mapBT` etc., the *constructor on the LHS* must match the *constructor on the RHS*. E.g. `fmap f (Fork x l r) = Fork (f x) (fmap f l) (fmap f r)` (NOT `Empty` or different arity).
- **Accidentally O(n²)** → `(++ [x])` or `reverse` inside recursion. Use [accumulator](patterns/accumulator.md) to make it O(n).
- **Forgetting `n <= 0` in count-decrement** → `take (-1) xs` should be `[]`, not an infinite loop.
- **Confusing `>>=` and `>>`** → use `<-` to bind, `>>` to sequence-and-discard.
- **Bound-threading vs local check** in BST validation — see "Local-only BST check" above.

## ✅ EXAM-DAY CHECKLIST

1. Copy type sig verbatim from template
2. Cover all cases: `Empty/Fork`, `[]/(x:xs)`, `Nothing/Just`
3. Mentally test: `[]`, `Empty`, `0`, single-element, negative N
4. Run `presubmit.sh AssignmentN` before submitting
5. Don't import anything extra
6. Re-read the question for what was actually asked — don't extrapolate

## See also
[If You See X](if-you-see-x.md) · [Common Templates](common-templates.md) · [Tree Recursion](tree-recursion.md)
