# Tree Recursion — All Variants

[← INDEX](INDEX.md) · [NAVIGATION](NAVIGATION.md)

⭐⭐⭐⭐⭐ The #1 exam archetype. Master this file.

> **Mental model:** trees are *recursive ADTs* — they have a "stop" constructor (`Empty` / `Leaf`) and a "keep going" constructor (`Fork` / `Branch`). Your function gets *one equation per constructor*: the base case handles the stop, the recursive case handles "do something with the data here, then recurse on the children, then combine".

## Universal schema
```haskell
f :: T -> r
f (BaseCtor)                  = base                    -- "stop" case
f (RecursiveCtor x sub1 sub2) = combine x (f sub1) (f sub2)
--                              ^^^^^^^ ^^^^^^^ ^^^^^^^
--                              do work  recurse  recurse
```

## BINARY TREE — `data BT a = Empty | Fork a (BT a) (BT a)`

```haskell
f :: BT a -> r
f Empty        = base
f (Fork x l r) = combine x (f l) (f r)
```

### Standard ops
```haskell
size, height, leaves, sumBT :: BT a -> Int
mapBT                       :: (a -> b) -> BT a -> BT b
mirror                      :: BT a -> BT a
flatten, preOrder, postOrder :: BT a -> [a]

size Empty                  = 0
size (Fork _ l r)           = 1 + size l + size r

height Empty                = 0
height (Fork _ l r)         = 1 + max (height l) (height r)

leaves Empty                = 0
leaves (Fork _ Empty Empty) = 1
leaves (Fork _ l r)         = leaves l + leaves r

sumBT Empty                 = 0
sumBT (Fork x l r)          = x + sumBT l + sumBT r

mirror Empty                = Empty
mirror (Fork x l r)         = Fork x (mirror r) (mirror l)

mapBT _ Empty               = Empty
mapBT f (Fork x l r)        = Fork (f x) (mapBT f l) (mapBT f r)

flatten Empty               = []
flatten (Fork x l r)        = flatten l ++ [x] ++ flatten r     -- in-order

preOrder Empty              = []
preOrder (Fork x l r)       = [x] ++ preOrder l ++ preOrder r

postOrder Empty             = []
postOrder (Fork x l r)      = postOrder l ++ postOrder r ++ [x]

countBT _ Empty                          = 0
countBT y (Fork x l r) | y == x          = 1 + rec | otherwise = rec
  where rec = countBT y l + countBT y r
```

### BST (Ord)

**Intuition:** for a BST you need *every* node's value to lie between the bounds inherited from its ancestors. Thread `(lo, hi)` top-down using `Maybe` to mean "no bound yet".

```haskell
isBST :: Ord a => BT a -> Bool
isBST = go Nothing Nothing
  where
    go _  _  Empty        = True
    go lo hi (Fork x l r) = maybe True (< x) lo
                         && maybe True (> x) hi
                         && go lo (Just x) l
                         && go (Just x) hi r

insertBST x Empty = Fork x Empty Empty
insertBST x t@(Fork v l r)
  | x < v  = Fork v (insertBST x l) r
  | x > v  = Fork v l (insertBST x r)
  | otherwise = t

deleteBST _ Empty = Empty
deleteBST x (Fork v l r)
  | x < v = Fork v (deleteBST x l) r
  | x > v = Fork v l (deleteBST x r)
  | otherwise = case (l, r) of
      (Empty, Empty) -> Empty
      (l,     Empty) -> l
      (Empty, r)     -> r
      _              -> Fork (largestOf l) (withoutLargest l) r
  where
    largestOf (Fork x _ Empty) = x
    largestOf (Fork _ _ r)     = largestOf r
    withoutLargest (Fork _ l Empty) = l
    withoutLargest (Fork x l r)     = Fork x l (withoutLargest r)

memberBST _ Empty = False
memberBST y (Fork x l r)
  | y == x = True
  | y < x  = memberBST y l
  | otherwise = memberBST y r
```

### Address enumeration
```haskell
data Direction = L | R
type Address   = [Direction]

addresses Empty        = []
addresses (Fork _ l r) = [] : map (L:) (addresses l)
                            ++ map (R:) (addresses r)

subtree :: Address -> BT a -> Maybe (BT a)
subtree []     t                = Just t
subtree (L:ds) (Fork _ l _)     = subtree ds l
subtree (R:ds) (Fork _ _ r)     = subtree ds r
subtree _      Empty            = Nothing
```

### State-labelled traversal
```haskell
labelTree :: BT a -> BT (Int, a)
labelTree t = evalState (go t) 0
  where go Empty = return Empty
        go (Fork x l r) = do
          l' <- go l
          n  <- get; put (n+1)
          r' <- go r
          return (Fork (n, x) l' r')
```

### Monadic tree map (mapM-tree)
```haskell
mapMTree :: Monad m => (a -> m b) -> BT a -> m (BT b)
mapMTree _ Empty        = return Empty
mapMTree f (Fork x l r) = do
  v' <- f x
  l' <- mapMTree f l
  r' <- mapMTree f r
  return (Fork v' l' r')
```

---

## ROSE TREE — `data Rose a = Leaf a | Branch [Rose a]`

**Intuition:** like a binary tree, but `Branch` holds an *arbitrary number* of children in a list. Recurse with `map f xs` to apply `f` to every child, then combine.

```haskell
f :: Rose a -> r
f (Leaf x)    = base x
f (Branch xs) = combine (map f xs)
```

### Standard ops
```haskell
sizeR, heightR :: Rose a -> Int
flattenR       :: Rose a -> [a]
mapRose        :: (a -> b) -> Rose a -> Rose b

sizeR (Leaf _)    = 1
sizeR (Branch xs) = 1 + sum (map sizeR xs)

heightR (Leaf _)    = 0
heightR (Branch xs) = 1 + maximum (0 : map heightR xs)   -- 0 guards Branch []

flattenR (Leaf x)    = [x]
flattenR (Branch xs) = concatMap flattenR xs

mapRose f (Leaf x)    = Leaf (f x)
mapRose f (Branch xs) = Branch (map (mapRose f) xs)
```

### Mock Q1 (CANONICAL)

**Intuition:** `isNBranching` says "every `Branch` has exactly `n` children, recursively". Note the *double check* — count AND recurse. `prune` truncates to the first `n` children at every level.

```haskell
isNBranching :: Int -> Rose a -> Bool
isNBranching _ (Leaf _)    = True
isNBranching n (Branch xs) = length xs == n && all (isNBranching n) xs

prune :: Int -> Rose a -> Rose a
prune _ (Leaf x)    = Leaf x
prune n (Branch xs) = Branch (map (prune n) (take n xs))
```

---

## TRIE / LOOKUP TREE — `data Tree = Empty | Branch (Maybe Char) Tree Tree`

```haskell
-- Morse: descend by Beep/Silence consuming code, payload at decode point
decode :: Tree -> Code -> Maybe Char
decode (Branch p _ _) []           = p
decode (Branch _ _ r) (Beep:xs)    = decode r xs
decode (Branch _ l _) (Silence:xs) = decode l xs
decode Empty _ = Nothing
```

---

## EXPRESSION AST — `data Expr = Val Int | Add Expr Expr | …`

**Intuition:** an AST IS a tree; an `eval` IS tree recursion. Each ctor decides how to combine the values from its subtrees.

```haskell
eval :: Expr -> Int
eval (Val n)   = n
eval (Add a b) = eval a + eval b
eval (Mul a b) = eval a * eval b
eval (Neg a)   = - eval a

-- With Maybe (division):
evalM (Val n)   = Just n
evalM (Div a b) = do x <- evalM a; y <- evalM b
                     if y == 0 then Nothing else Just (x `div` y)

-- With env:
evalE env (Var x) = lookup x env
evalE env (Let x e b) = do v <- evalE env e; evalE ((x,v):env) b
```

---

## ⚠ TRAPS
- `isBST Empty = True` (NOT False — student bug)
- Shallow Rose check: forget `&& all rec xs` (Mock Q1 trap)
- Constructor names vary (BT/Fork vs EmptyTree/Node vs Bin/Lf/Nd) — read `Types.hs`
- Swap l/r ONLY when mirroring
- Non-exhaustive: cover every constructor (compiler warns; QuickCheck finds it)
- `maximum (0 : map …)` not `maximum (map …)` — Rose heightR crashes on `Branch []`

## See also
[Common Templates](common-templates.md) §4-5 · [mapM](mapm.md) · [State Monad](state-monad.md) · [Common Pitfalls](common-pitfalls.md)
