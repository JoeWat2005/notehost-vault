# Common Templates — One-File Reference

[← INDEX](INDEX.md) · [NAVIGATION](NAVIGATION.md)

Every reusable skeleton in one place. Search by section heading (e.g. `Ctrl+F "§8"` for State).

> **How to read each section**: the first code block is the canonical *shape* of the pattern. The blocks beneath are *fills* — same shape, different problem. Copy the shape, then customise.

## §1. LIST CONS RECURSION
**Idea:** peel one element off the front, recurse on the rest, combine. Most fundamental list pattern.
```haskell
f :: [a] -> r
f []     = base
f (x:xs) = combine x (f xs)
```
```haskell
myLength []     = 0;  myLength (_:xs) = 1 + myLength xs
mySum []     = 0;  mySum (x:xs) = x + mySum xs
myMap f [] = [];   myMap f (x:xs) = f x : myMap f xs
myFilter p [] = [];myFilter p (x:xs) | p x = x : myFilter p xs | otherwise = myFilter p xs
myElem y [] = False; myElem y (x:xs) = y == x || myElem y xs
myTake n _ | n <= 0 = []; myTake _ [] = []; myTake n (x:xs) = x : myTake (n-1) xs
myZip [] _ = []; myZip _ [] = []; myZip (x:xs)(y:ys) = (x,y) : myZip xs ys
```

## §2. ACCUMULATOR (fast / O(n))
**Idea:** carry running state in a `go` helper. Converts naive O(n²) into O(n).
```haskell
f :: [a] -> r
f xs = go xs init
  where go []     acc = acc
        go (x:xs) acc = go xs (step x acc)
```
```haskell
fastReverse xs = go xs [] where go [] acc = acc; go (x:xs) acc = go xs (x:acc)
fastFib n = go n (0,1) where go 0 (a,_) = a; go n (a,b) = go (n-1) (b, a+b)
```

## §3. LOOK-AHEAD (x:y:xs)
**Idea:** when you need to compare/process *adjacent* elements (pairs, alternations). Three base cases: `[]`, single-`[x]`, pair-`(x:y:xs)`.
```haskell
altMap :: (a -> b) -> (a -> b) -> [a] -> [b]
altMap _ _ []       = []
altMap f _ [x]      = [f x]
altMap f g (x:y:xs) = f x : g y : altMap f g xs
```

## §4. BINARY TREE
**Idea:** the tree's *shape* drives the recursion — one equation per constructor. `Empty` is the base; `Fork` recurses on both branches.
```haskell
data BT a = Empty | Fork a (BT a) (BT a)

f :: BT a -> r
f Empty        = base
f (Fork x l r) = combine x (f l) (f r)
```
```haskell
size Empty        = 0;          size (Fork _ l r)        = 1 + size l + size r
height Empty      = 0;          height (Fork _ l r)      = 1 + max (height l) (height r)
leaves Empty                = 0
leaves (Fork _ Empty Empty) = 1
leaves (Fork _ l r)         = leaves l + leaves r
mirror Empty        = Empty;    mirror (Fork x l r) = Fork x (mirror r) (mirror l)
mapBT f Empty        = Empty;   mapBT f (Fork x l r) = Fork (f x) (mapBT f l) (mapBT f r)
flatten Empty        = [];      flatten (Fork x l r) = flatten l ++ [x] ++ flatten r
```

## §5. ROSE TREE
**Idea:** like binary tree but with *unbounded children* (a `[Rose a]`). Use `map f` to recurse into all children, then combine.
```haskell
data Rose a = Leaf a | Branch [Rose a]

f :: Rose a -> r
f (Leaf x)    = base x
f (Branch xs) = combine (map f xs)
```
```haskell
sizeR (Leaf _) = 1;       sizeR (Branch xs) = 1 + sum (map sizeR xs)
flattenR (Leaf x) = [x];  flattenR (Branch xs) = concatMap flattenR xs
mapRose f (Leaf x) = Leaf (f x); mapRose f (Branch xs) = Branch (map (mapRose f) xs)

isNBranching _ (Leaf _)    = True
isNBranching n (Branch xs) = length xs == n && all (isNBranching n) xs

prune _ (Leaf x)    = Leaf x
prune n (Branch xs) = Branch (map (prune n) (take n xs))
```

## §6. FOLD RECIPES
**Idea:** `foldr op b` literally replaces `(:)` with `op` and `[]` with `b`. Any cons-recursion can be rewritten as a fold.
```haskell
sum    = foldr (+) 0;        product = foldr (*) 1
length = foldr (\_ n -> 1+n) 0
map f  = foldr (\x xs -> f x : xs) []
filter p = foldr (\x xs -> if p x then x:xs else xs) []
concat = foldr (++) [];      or = foldr (||) False;   and = foldr (&&) True
compose = foldr (.) id
reverse = foldl (flip (:)) []
```

## §7. BST (Ord)
**Idea:** at every `Fork`, compare with `Ord` and recurse only down ONE side. Insertions/deletions/membership all use the same 3-way split.
```haskell
insertBST :: Ord a => a -> BT a -> BT a
insertBST x Empty = Fork x Empty Empty
insertBST x t@(Fork v l r)
  | x < v = Fork v (insertBST x l) r
  | x > v = Fork v l (insertBST x r)
  | otherwise = t                                    -- idempotent

deleteBST _ Empty = Empty
deleteBST x (Fork v l r)
  | x < v = Fork v (deleteBST x l) r
  | x > v = Fork v l (deleteBST x r)
  | otherwise = case (l, r) of
      (Empty, Empty) -> Empty
      (l,     Empty) -> l
      (Empty, r    ) -> r
      _              -> Fork (largestOf l) (withoutLargest l) r
  where
    largestOf (Fork x _ Empty) = x
    largestOf (Fork _ _ r)     = largestOf r
    withoutLargest (Fork _ l Empty) = l
    withoutLargest (Fork x l r)     = Fork x l (withoutLargest r)
```

## §8. STATE MONAD
**Idea:** hide a mutable value inside a `do`-block. `get` reads, `put` writes, `modify` is both. Run with `runState/evalState/execState`.
```haskell
import Control.Monad.State
-- get    :: State s s              -- read
-- put    :: s -> State s ()        -- write
-- modify :: (s -> s) -> State s () -- read+write
-- runState  :: State s a -> s -> (a, s)
-- evalState :: State s a -> s -> a     -- just the value
-- execState :: State s a -> s -> s     -- just the final state

fresh :: State Int Int
fresh = do n <- get; put (n+1); return n

-- Nim
type NimGame a = State (Int, Int) a
data Heap = First | Second
gameOver :: NimGame Bool
gameOver = do (x,y) <- get; return (x == 0 && y == 0)
takeTokens n First  = do (x,y) <- get; put (max 0 (x-n), y)
takeTokens n Second = do (x,y) <- get; put (x, max 0 (y-n))

-- Label tree in-order
labelTree t = evalState (go t) 0
  where go Empty = return Empty
        go (Fork x l r) = do
          l' <- go l
          n  <- get; put (n+1)
          r' <- go r
          return (Fork (n, x) l' r')
```

## §9. WRITER MONAD
**Idea:** alongside the result, accumulate a `Monoid` (log lines, sum, counter). `tell` appends to that side channel.
```haskell
import Control.Monad.Writer
-- tell       :: Monoid w => w -> Writer w ()
-- runWriter  :: Writer w a -> (a, w)
-- execWriter :: Writer w a -> w

logTraverse (File n _)    = tell ["File: " ++ n]
logTraverse (SubDir n cs) = do
  tell ["Enter " ++ n]; mapM_ logTraverse cs; tell ["Leave " ++ n]
```

## §10. MAYBE / EITHER (case-on or do)
**Idea:** `do`-notation on `Maybe` auto-short-circuits — the moment any `<-` returns `Nothing`, the whole block becomes `Nothing`. Same for `Either e` with `Left`.
```haskell
-- case-on:
case rec xs of Nothing -> Nothing; Just rest -> Just (x : rest)
-- IDIOMATIC do:
do rest <- rec xs; return (x : rest)

-- Either:
zipEither :: [a] -> [b] -> Either String [(a,b)]
zipEither [] []         = Right []
zipEither [] _          = Left "first shorter"
zipEither _  []         = Left "second shorter"
zipEither (x:xs)(y:ys)  = do rest <- zipEither xs ys; return ((x,y):rest)
```

## §11. EVALUATOR (per-ctor case-fold)
**Idea:** an `Expr` AST is a tree; `eval` is just tree recursion that returns a value. Add Maybe/MonadError for failure, an `Env` for variables.
```haskell
eval :: Expr -> Int
eval (Val n)   = n
eval (Add a b) = eval a + eval b
eval (Mul a b) = eval a * eval b

-- With env + Maybe:
eval env (Var x)        = lookup x env
eval env (Add a b)      = do x <- eval env a; y <- eval env b; return (x + y)
eval env (Let x e body) = do v <- eval env e; eval ((x,v):env) body

-- With error:
eval (Div a b) = do x <- eval a; y <- eval b
                    if y == 0 then throwError "/0" else return (x `div` y)
```

## §12. ADT-TO-ADT TRANSLATION (Mock Q5)
**Idea:** rewrite each constructor of one ADT into the equivalent shape in another ADT, recursing on children. Use `let`/`where` to share subtrees.
```haskell
circuit :: Expr -> Circuit
circuit (Var x)       = Input x
circuit (Not p)       = Nand (circuit p) (circuit p)
circuit (And p q)     = Nand pq pq
  where pq = Nand (circuit p) (circuit q)
circuit (Or p q)      = Nand np nq
  where np = Nand (circuit p) (circuit p)
        nq = Nand (circuit q) (circuit q)    -- ← 'q' not 'p'
circuit (Implies p q) = circuit (Or (Not p) q)
```

## §13. MATRIX PREDICATE (Mock Q4)
**Idea:** rows are the original `[[Int]]`; columns = `transpose`; diagonals = `zipWith (!!) xss [0..]`. Combine with `all`.
```haskell
import Data.List (transpose)

isMagicSquare :: [[Int]] -> Bool
isMagicSquare [] = False
isMagicSquare xss =
  let target = sum (head xss)
      rows   = all (\r -> sum r == target) xss
      cols   = all (\c -> sum c == target) (transpose xss)
      diag   = sum (zipWith (!!) xss [0..]) == target
  in rows && cols && diag

winner grid = checkLines (rows ++ cols ++ diags)
  where rows = grid
        cols = transpose grid
        diags = [zipWith (!!) grid [0..], zipWith (!!) (reverse grid) [0..]]
        checkLines [] = Nothing
        checkLines ([Just p, Just q, Just r]:rest)
          | p == q && q == r = Just p
        checkLines (_:rest) = checkLines rest
```

## §14. GENERIC MONAD COMBINATOR (Mock Q2)
**Idea:** the recursion looks identical to list-cons, but each step uses `<-` to extract a monadic value. Works for ANY monad — the same code handles Maybe, State, IO, ….
```haskell
applyNTimes :: Monad m => m a -> (a -> m a) -> Int -> m [a]
applyNTimes mx _ 0 = do x <- mx; return [x]
applyNTimes mx f n = do
  x  <- mx
  xs <- applyNTimes (f x) f (n - 1)
  return (x : xs)
```

## §15. FUNCTOR / MONAD INSTANCE
**Idea (Functor):** walk every constructor; apply `f` to each `a`-typed slot; recurse with `fmap` on slots that hold `f a`-shaped data. Preserve shape exactly.
```haskell
instance Functor BT where
  fmap _ Empty = Empty
  fmap f (Fork x l r) = Fork (f x) (fmap f l) (fmap f r)

instance Functor Rose where
  fmap f (Leaf x) = Leaf (f x)
  fmap f (Branch xs) = Branch (map (fmap f) xs)

instance (Functor f, Functor g) => Functor (FSum f g) where
  fmap h (FLeft fa)  = FLeft  (fmap h fa)
  fmap h (FRight ga) = FRight (fmap h ga)

-- Maybe-shaped Monad
instance Monad MyMaybe where
  return = MyJust
  MyNothing >>= _ = MyNothing
  MyJust x  >>= f = f x

-- List-shaped Monad
instance Monad MyList where
  return x = Cons x Nil
  Nil       >>= _ = Nil
  Cons x xs >>= f = append (f x) (xs >>= f)
```

## §16. mapM ON TREE
**Idea:** like `fmap` but each transform produces an effect. Bind every result with `<-`, rebuild the tree with the same constructor. Order of `<-` controls pre/in/post traversal.
```haskell
mapMTree :: Monad m => (a -> m b) -> BT a -> m (BT b)
mapMTree _ Empty        = return Empty
mapMTree f (Fork x l r) = do
  v' <- f x
  l' <- mapMTree f l
  r' <- mapMTree f r
  return (Fork v' l' r')
```

## §17. PARSER COMBINATORS
**Idea:** a `Parser a` is "consume some prefix of the input, optionally produce an `a` and leave the rest". `<|>` tries alternatives; `do` sequences. Grammar mirrors the BNF.
```haskell
newtype Parser a = P (String -> [(a, String)])
parse :: Parser a -> String -> [(a, String)]
parse (P p) = p

item       = P (\s -> case s of [] -> []; (c:cs) -> [(c, cs)])
sat p      = do x <- item; if p x then return x else empty
char c     = sat (== c)
digit      = sat isDigit
many p     = some p <|> return []
some p     = do x <- p; xs <- many p; return (x:xs)
space      = do _ <- many (sat isSpace); return ()
token p    = do space; v <- p; space; return v
symbol s   = token (mapM char s)
nat        = do xs <- some digit; return (read xs)

expr = do t <- term
          (do symbol "+"; e <- expr; return (t + e)) <|> return t
term = do f <- factor
          (do symbol "*"; t <- term; return (f * t)) <|> return f
factor = (do symbol "("; e <- expr; symbol ")"; return e) <|> token nat
```

## §18. CODEC (encode/decode)
**Idea:** an encoder + decoder pair with `decode . encode = id`. Often a `Table` of pairs both ways. RLE is a tiny self-contained codec.
```haskell
encodeWord t = intercalate shortGap . map (lookupCode t)
  where lookupCode t c = case lookup c t of Just code -> code; _ -> []

decodeWord t = map (lookupChar (map swap t)) . split shortGap
  where swap (a, b) = (b, a)

rle [] = []
rle (x:xs) = (x, 1 + length same) : rle rest
  where same = takeWhile (== x) xs
        rest = dropWhile (== x) xs

rld = concatMap (\(x, n) -> replicate n x)
```

## §19. LAZY MEMOISATION
**Idea:** turn a self-referential definition into a recursion built from `fix`. Store results in a lazy infinite tree so each subproblem is computed once.
```haskell
fix :: (a -> a) -> a
fix f = let x = f x in x

fibstep rec n | n < 2 = n | otherwise = rec (n-1) + rec (n-2)

tstore f = Fork (f 0) (tstore (\n -> f (1+2*n))) (tstore (\n -> f (2+2*n)))
tfetch (Fork a _ _) 0 = a
tfetch (Fork _ l r) n | odd n = tfetch l ((n-1) `div` 2)
                      | otherwise = tfetch r ((n-2) `div` 2)
memoBT = tfetch . tstore

fibBT = fix (memoBT . fibstep)
```

## §20. IMPERATIVE INTERPRETER
**Idea:** `Storage` is a function `String -> Integer`. Statements transform storage; expressions read it. `update i x m` returns a new storage with `i` mapped to `x`.
```haskell
type Storage = String -> Integer
update :: String -> Integer -> Storage -> Storage
update i x m = \j -> if i == j then x else m j

run (i := e)       m = update i (eval m e) m
run (Block [])     m = m
run (Block (p:ps)) m = run (Block ps) (run p m)
run (While e p)    m | eval m e /= 0 = run (While e p) (run p m)
                     | otherwise     = m
run (IfElse e p q) m | eval m e /= 0 = run p m
                     | otherwise     = run q m
```

## See also
[If You See X](if-you-see-x.md) · [Type Signature Decoder](type-signature-decoder.md) · [Common Pitfalls](common-pitfalls.md) · [Tree Recursion](tree-recursion.md) · [State Monad](state-monad.md)
