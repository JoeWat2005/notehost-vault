# State Monad — Complete Reference

[← INDEX](INDEX.md) · [NAVIGATION](NAVIGATION.md)

⭐⭐⭐⭐⭐ Tier-1 exam topic.

> **Mental model:** `State s a` is a fancy name for "a function `s -> (a, s)`" — give it a state, get back a result + new state. The monad just *hides the plumbing*: each `<-` step automatically threads the state forward. Inside a `do`-block it *feels* like you have a mutable variable.

## Import
```haskell
import Control.Monad.State
```

## Type (conceptual)
```haskell
newtype State s a = State { runState :: s -> (a, s) }
```
Read `State s a` as: "a computation with hidden state of type `s` that produces an `a`."

## PRIMITIVES
```haskell
get    :: State s s                  -- read current state
put    :: s -> State s ()            -- overwrite state
modify :: (s -> s) -> State s ()     -- get + put . f
gets   :: (s -> a) -> State s a      -- fmap f get (project)
state  :: (s -> (a, s)) -> State s a -- general constructor
```

## RUNNERS
```haskell
runState  :: State s a -> s -> (a, s)   -- full pair
evalState :: State s a -> s -> a        -- value only
execState :: State s a -> s -> s        -- final state only
```

---

## §1. FRESH COUNTER (gensym)
**Idea:** read the current counter, bump it, return the old value. Each call produces a new unique number.
```haskell
fresh :: State Int Int
fresh = do n <- get; put (n+1); return n

evalState (do { a <- fresh; b <- fresh; c <- fresh; return [a,b,c] }) 0
-- [0, 1, 2]
```

## §2. COUNTER VIA modify
```haskell
countFiles :: Dir -> State Int ()
countFiles (File _ _)    = modify (+1)
countFiles (SubDir _ cs) = mapM_ countFiles cs
```

## §3. TWIN STATE (pair)
```haskell
factHelper :: Integer -> State Integer ()
factHelper 0 = return ()
factHelper n = do
  modify (* n)
  factHelper (n-1)

factorial :: Integer -> Integer
factorial n = execState (factHelper n) 1
```

## §4. GAME MOVE WITH CLAMP (Nim — Mock Q3)
**Idea:** the state IS the game board (here `(Int, Int)` = two heaps). Each move = `get` the board, compute the new board, `put` it. `max 0 (x - n)` prevents negatives.
```haskell
type NimBoard = (Int, Int)
type NimGame a = State NimBoard a
data Heap = First | Second

gameOver :: NimGame Bool
gameOver = do
  (x, y) <- get
  return (x == 0 && y == 0)

takeTokens :: Int -> Heap -> NimGame ()
takeTokens n First = do
  (x, y) <- get
  put (max 0 (x - n), y)
takeTokens n Second = do
  (x, y) <- get
  put (x, max 0 (y - n))
```

## §5. COMMAND-SEQUENCE INTERPRETER
```haskell
data CalcCmd = EnterC | StoreC Int CalcCmd | AddC Int CalcCmd | …

runCmd :: CalcCmd -> State Int ()
runCmd EnterC          = return ()
runCmd (StoreC x next) = do put x; runCmd next
runCmd (AddC x next)   = do c <- get; put (c + x); runCmd next
```

## §6. STACK-CALCULATOR
```haskell
type StackCalc a = State [Int] a

push :: Int -> StackCalc ()
push x = modify (x :)

pop :: StackCalc (Maybe Int)
pop = do
  stk <- get
  case stk of
    []     -> return Nothing
    (x:xs) -> do put xs; return (Just x)
```

## §7. LABEL TREE (in-order)
**Idea:** use `fresh` at exactly one position in the recursion — that position determines the traversal order (pre/in/post). Below is in-order: label fires *between* left and right.
```haskell
labelTree :: BT a -> BT (Int, a)
labelTree t = evalState (go t) 0
  where
    go :: BT a -> State Int (BT (Int, a))
    go Empty        = return Empty
    go (Fork x l r) = do
      l' <- go l
      n  <- get; put (n+1)
      r' <- go r
      return (Fork (n, x) l' r')
```

## §8. STATE OVER LIST (frequency, dedup with seen)
```haskell
unique :: Eq a => [a] -> State [a] [a]
unique []     = return []
unique (x:xs) = do
  seen <- get
  if x `elem` seen
    then unique xs
    else do put (x : seen); rest <- unique xs; return (x : rest)
```

## §9. APPLY MOVES (with reset on win)
```haskell
applyMovesReset :: NimBoard -> [(Int, Heap)] -> NimGame ()
applyMovesReset _     []                = return ()
applyMovesReset start ((n, h):moves)  = do
  takeTokens n h
  over <- gameOver
  if over then put start else return ()
  applyMovesReset start moves
```

## §10. MULTI-EFFECT (State + Error)
```haskell
import Control.Monad.State
import Control.Monad.Error.Class

runCalc :: (MonadState Int m, MonadError String m) => CalcCmd -> m ()
runCalc (DivC x next) =
  if x == 0
    then throwError "Division by zero"
    else do c <- get; put (c `div` x); runCalc next
```

---

## SUMMARY OF do-PATTERNS

```haskell
-- Read state:
x <- get

-- Read + transform + write:
do x <- get; put (f x)
-- equivalent:
modify f

-- Read field of state:
x <- gets fst

-- Conditional on state:
b <- gets predicate
if b then return () else doSomething

-- Iterate with state:
mapM_ doMove moves
```

---

## TYPE-SIG QUICK LOOKUP
| Signature                                | What it is                      |
|------------------------------------------|--------------------------------|
| `State s s`                              | get                            |
| `s -> State s ()`                        | put                            |
| `(s -> s) -> State s ()`                 | modify                         |
| `State Int Int`                          | counter primitive / fresh      |
| `BT a -> BT (Int, a)`                    | label tree                     |
| `BT a -> State Int ()`                   | tree walker (counting)         |
| `[CalcCmd] -> State [Int] ()`            | stack interpreter              |
| `Int -> Heap -> State (Int, Int) ()`     | game move                      |
| `State (Int, Int) Bool`                  | game predicate                 |
| `(MonadState s m, MonadError e m) => …`  | mtl multi-effect               |

## ⚠ Pitfalls
- **`State s a` — `s` is FIRST type param.** Don't write `State a s`.
- Forgetting `import Control.Monad.State` → auto-marker fails
- Confusing `runState` (gives pair) vs `evalState` (value only) vs `execState` (state only)
- **Clamp underflow** in subtractive moves: `max 0 (x - n)`
- Use `modify f` instead of `do { x <- get; put (f x) }` (cleaner)
- `get >>= put . f` is a one-liner equivalent of `modify f`

## See also
[Common Templates](common-templates.md) §8 · [Mock Q3 Nim](examples/mock-q3-nim.md) · [Label Tree](examples/label-tree.md) · [Nim Game](examples/nim-game.md) · [Interpreter Extension](interpreter-extension.md)
