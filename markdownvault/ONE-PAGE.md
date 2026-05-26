# ONE-PAGE — The Panic Reference

→ [← INDEX](INDEX.md) · [HOW-TO-USE](HOW-TO-USE.md) · [NAVIGATION](NAVIGATION.md)

Single-screen reference for the moment you go blank. Everything below fits without scrolling.

> **Read this top-down once.** Then jump to the table that matches your question.

## 🎯 5 archetypes that cover ~80% of exam marks
| Q-likely | Archetype | Trigger | One-line mental model |
|----------|-----------|---------|------------------------|
| Q1 | **Tree recursion** | "binary/rose tree" | "Walk every ctor; recurse on children; combine." |
| Q2 | **Generic Monad** | `Monad m =>` in sig | "Same recursion, but each step is `<-` instead of `=`." |
| Q3 | **State game** | "Nim/move/score" | "Hide a counter/pair/board in a `do`-block." |
| Q4 | **Matrix predicate** | `[[Int]] -> Bool` | "Check rows + cols (`transpose`) + both diagonals." |
| Q5 | **ADT translation** | `Expr -> Circuit` | "Per-ctor rewrite; `let` to share subtrees." |

## ⚡ 10 essential templates (copy-paste-adapt)

Every template below follows the same idea: **base case + recursion combining children**.

```haskell
-- (1) List cons — peel one element, recurse on the rest
f :: [a] -> r
f []     = base
f (x:xs) = combine x (f xs)

-- (2) Binary tree — base on Empty, recurse on both branches
f :: BT a -> r
f Empty        = base
f (Fork x l r) = combine x (f l) (f r)

-- (3) Rose tree — base on Leaf, recurse over [Rose a]
f :: Rose a -> r
f (Leaf x)    = base x
f (Branch xs) = combine (map f xs)

-- (4) Accumulator (O(n)) — carry state alongside recursion
f :: [a] -> r
f xs = go xs init
  where go []     acc = acc
        go (x:xs) acc = go xs (step x acc)

-- (5) Maybe in do-notation — auto-shortcircuit on Nothing
f :: Maybe a -> Maybe a -> Maybe r
f mx my = do x <- mx; y <- my; return (combine x y)

-- (6) State fresh counter — read, bump, return the old value
fresh :: State Int Int
fresh = do n <- get; put (n+1); return n

-- (7) Writer trace — append to a log alongside the result
trace :: Show a => a -> Writer [String] a
trace x = do tell ["seen " ++ show x]; return x

-- (8) mapM on tree — transform every node with an effect, keep shape
mapMT :: Monad m => (a -> m b) -> BT a -> m (BT b)
mapMT _ Empty        = return Empty
mapMT f (Fork x l r) = do v' <- f x; l' <- mapMT f l; r' <- mapMT f r
                          return (Fork v' l' r')

-- (9) Functor instance for tree — apply f to a-slots, recurse on subtrees
instance Functor BT where
  fmap _ Empty        = Empty
  fmap f (Fork x l r) = Fork (f x) (fmap f l) (fmap f r)

-- (10) Per-ctor evaluator — pattern-match each ctor, recurse
eval :: Expr -> Int
eval (Val n)   = n
eval (Add a b) = eval a + eval b
```

## 🧠 Core intuitions (one-liners that unlock everything)
- **Functor** = "preserve structure, transform values" (`fmap`)
- **Applicative** = "apply a wrapped function to a wrapped value" (`<*>`)
- **Monad** = "chain dependent contexted computations" (`>>=` / `do`)
- **State** = "hide an accumulator in a `do`-block"
- **Writer** = "side-channel log, combined via Monoid"
- **`foldr`** = "replace `(:)` with `op` and `[]` with `b`"
- **`mapM`** = "`map` with effects, collect into one big effect"
- **Recursive ADTs** are processed *structurally* — one equation per constructor

## 🛑 5 traps that kill marks
1. **Type signature changed** → QuickCheck auto-fails. Copy from template VERBATIM.
2. **`isBST Empty = False`** → WRONG. An empty tree IS a valid BST → should be `True`.
3. **Shallow Rose check** → `length xs == n` MISSING `&& all (isNBranching n) xs`.
4. **Imported new module** → exam forbids extras. Only `Prelude` + provided `Types.hs`.
5. **Non-exhaustive patterns** → QuickCheck WILL test `Empty`, `[]`, `Nothing`.

## ⚙ Cant-go-wrong Prelude
| Need | Use | Type |
|------|-----|------|
| sum / length / reverse | `sum xs` `length xs` `reverse xs` | `Num a => [a] -> a`, etc. |
| Maybe value or default | `fromMaybe def m` | `a -> Maybe a -> a` |
| Lookup in pairs | `lookup k m` | `Eq a => a -> [(a,b)] -> Maybe b` |
| Sort | `sort xs` | `Ord a => [a] -> [a]` |
| Matrix cols | `transpose xss` | `[[a]] -> [[a]]` |
| Join with sep | `intercalate sep xss` | `[a] -> [[a]] -> [a]` |
| Run state | `runState m s` / `evalState` / `execState` | see [State](state-monad.md) |
| Log step | `tell ["..."]` (Writer) | `Monoid w => w -> Writer w ()` |
| Throw error | `throwError "msg"` (MonadError) | `MonadError e m => e -> m a` |

## ⏱ 2-hour time budget
| | |
|---|---|
| 5 min | Scan all 5 Qs, pick easiest |
| 15-25 min | Each Q (start easy) |
| 15 min | Re-check + `presubmit.sh` |

## 🆘 If totally stuck
1. Write the type sig + `undefined` stub so file compiles
2. Move on — return later
3. Even half-marks per Q beats blank

## 🔑 Final reminders
- 35+ marks = 1st class
- Use Hoogle for unknown library fns
- Test edge cases mentally: `[]`, `Empty`, `0`, `Nothing`
- Run `presubmit.sh AssignmentN` BEFORE submit

## See also
[HOW-TO-USE](HOW-TO-USE.md) · [if-you-see-x](if-you-see-x.md) · [common-templates](common-templates.md) · [common-pitfalls](common-pitfalls.md) · [exam-day-plan](exam-day-plan.md)
