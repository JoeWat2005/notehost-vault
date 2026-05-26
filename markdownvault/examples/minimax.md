# Minimax / Game Trees / Alpha-Beta (W11)

[← INDEX](../INDEX.md) · [↑ Examples](README.md) · [NAVIGATION](../NAVIGATION.md)

Game-playing AI via lazy game tree.

> **Technique:** build an *infinite* tree of all possible game states (laziness makes this OK). Score each leaf with respect to a player; propagate scores up by `maximum` (X's turn) or `minimum` (O's turn).


## Types
```haskell
data Player = O | B | X    deriving (Eq, Ord, Show)
type Grid   = [[Player]]
type Move   = Int

data Tree a = Node a [Tree a]   deriving Show

-- B = Blank ; O < B < X lex order matters for minimax!
```

## Moves enumeration
```haskell
moves :: Grid -> Player -> [Grid]
moves g p
  | won g           = []
  | not (any (B `elem`) g) = []
  | otherwise = [move g i p | i <- [0..8], valid g i]

valid :: Grid -> Move -> Bool
valid g i = concat g !! i == B

move :: Grid -> Move -> Player -> Grid
move g i p = chop 3 (xs ++ [p] ++ ys)
  where (xs, B:ys) = splitAt i (concat g)

chop :: Int -> [a] -> [[a]]
chop _ [] = []
chop n xs = take n xs : chop n (drop n xs)
```

## Game tree (corecursive)
```haskell
gametree :: Grid -> Player -> Tree Grid
gametree g p = Node g [gametree g' (next p) | g' <- moves g p]

next :: Player -> Player
next O = X
next X = O
next B = B
```

## Prune depth
```haskell
prune :: Int -> Tree a -> Tree a
prune 0 (Node x _)  = Node x []
prune n (Node x ts) = Node x [prune (n-1) t | t <- ts]
```

## Minimax labelling
```haskell
minimax :: Tree Grid -> Tree (Grid, Player)
minimax (Node g [])
  | wins O g  = Node (g, O) []
  | wins X g  = Node (g, X) []
  | otherwise = Node (g, B) []
minimax (Node g ts)
  | turn g == O = Node (g, minimum ps) ts'
  | turn g == X = Node (g, maximum ps) ts'
  where ts' = map minimax ts
        ps  = [p | Node (_, p) _ <- ts']
```

## bestmove — pick child with best score
```haskell
bestmove :: Grid -> Player -> Grid
bestmove g p = head [g' | Node (g', p') _ <- ts, p' == best]
  where Node (_, best) ts = minimax (prune 9 (gametree g p))
```

## Alpha-beta via lazy Ord (W11 lecture trick)
The minimax above already gets alpha-beta pruning FOR FREE if you:
1. Define custom `Ord Player` so `minimum`/`maximum` short-circuit
2. Use lazy evaluation — once a winning leaf is found, rest of subtree isn't forced

```haskell
-- Custom Ord that short-circuits on extreme:
instance Ord Player where
  compare O O = EQ
  compare O _ = LT
  compare _ O = GT
  compare X X = EQ
  compare X _ = GT
  compare _ X = LT
  compare _ _ = EQ
```

## Explicit alpha-beta (with takeUntil)
```haskell
supremum :: [Player] -> Player
supremum []     = O
supremum (X:_)  = X    -- short-circuit: max is X, done
supremum (p:ps) = max p (supremum ps)

infimum :: [Player] -> Player
infimum []     = X
infimum (O:_)  = O    -- short-circuit
infimum (p:ps) = min p (infimum ps)

takeUntil :: (a -> Bool) -> [a] -> [a]
takeUntil _ []     = []
takeUntil p (x:xs)
  | p x       = [x]
  | otherwise = x : takeUntil p xs
```

## Won / wins
```haskell
won :: Grid -> Bool
won g = wins O g || wins X g

wins :: Player -> Grid -> Bool
wins p g = any line lines
  where line   = all (== p)
        rows   = g
        cols   = transpose g
        diags  = [diag g, diag (map reverse g)]
        lines  = rows ++ cols ++ diags

diag :: Grid -> [Player]
diag g = [g !! i !! i | i <- [0..2]]
```

## IO loop (interactive)
```haskell
play :: Grid -> Player -> IO ()
play g p = do
  cls
  putGrid g
  if won g then putStrLn (show (turn g) ++ " wins")
  else if not (any (B `elem`) g) then putStrLn "Draw"
  else if p == X then do
    n <- getNat "Your move (0-8): "
    if valid g n then play (move g n X) (next X)
                 else play g p
  else do
    putStrLn "Thinking..."
    play (bestmove g O) (next O)
```

## Pattern
[Archetype 17 Zipper](../archetypes/17-zipper.md)-ish (state in IO loop) + game tree. Tier-4 archetype — possible but lower probability.

## ⚠ Pitfalls
- **Custom Ord order matters**: `data Player = O | B | X` — derived Ord gives O<B<X, which fits minimax (O minimises, X maximises)
- prune depth 9 = max for 3×3 TTT (9 cells)
- `next B = B` is intentional for fixed-point in degenerate states
- alpha-beta "for free" relies on laziness — strict eval defeats it

## See also
[TTT Winner](ttt-winner.md) · [Archetype 17 Zipper](../archetypes/17-zipper.md) · [Lazy Memoization](../patterns/lazy-memoization.md)
