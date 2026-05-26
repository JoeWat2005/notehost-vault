# mapM / mapM_ / sequence / forM / traverse

[← INDEX](INDEX.md) · [NAVIGATION](NAVIGATION.md)

> **Mental model:** `mapM` is just `map` but every step has a *monadic side-effect*. The effects are sequenced left-to-right, and all the individual results are collected back into the same container shape. If your effect is `IO`, you do IO at each element. If it's `State`, the state threads through every step. If it's `Maybe`, any `Nothing` short-circuits the whole thing.

Run a monadic effect for each element of a container, preserving structure.

## Core operations

| Function       | Type                                                | What it does                          |
|----------------|-----------------------------------------------------|---------------------------------------|
| `mapM`         | `Monad m => (a -> m b) -> [a] -> m [b]`             | apply m-fn to each, collect results   |
| `mapM_`        | `Monad m => (a -> m b) -> [a] -> m ()`              | apply m-fn to each, discard results   |
| `sequence`     | `Monad m => [m a] -> m [a]`                         | swap container with monad             |
| `sequence_`    | `Monad m => [m a] -> m ()`                          | run all, discard                      |
| `forM`         | `Monad m => [a] -> (a -> m b) -> m [b]`             | flipped mapM                          |
| `forM_`        | `Monad m => [a] -> (a -> m b) -> m ()`              | flipped mapM_                         |
| `replicateM`   | `Monad m => Int -> m a -> m [a]`                    | run n times, collect                  |
| `replicateM_`  | `Monad m => Int -> m a -> m ()`                     | run n times, discard                  |
| `when`         | `Applicative f => Bool -> f () -> f ()`             | conditional side-effect               |
| `unless`       | `Applicative f => Bool -> f () -> f ()`             | inverse `when`                        |
| `void`         | `Functor f => f a -> f ()`                          | discard result, keep effect           |

## Hand-implementations

### mapM
```haskell
mapM' :: Monad m => (a -> m b) -> [a] -> m [b]
mapM' _ []     = return []
mapM' f (x:xs) = do
  y  <- f x
  ys <- mapM' f xs
  return (y : ys)
```

### sequence
```haskell
sequence' :: Monad m => [m a] -> m [a]
sequence' []     = return []
sequence' (m:ms) = do
  x  <- m
  xs <- sequence' ms
  return (x : xs)
```

### mapM_
```haskell
mapM_' :: Monad m => (a -> m b) -> [a] -> m ()
mapM_' _ []     = return ()
mapM_' f (x:xs) = f x >> mapM_' f xs
```

### Tree versions

### mapMTree (preserve shape)
```haskell
mapMTree :: Monad m => (a -> m b) -> BT a -> m (BT b)
mapMTree _ Empty        = return Empty
mapMTree f (Fork x l r) = do
  v' <- f x
  l' <- mapMTree f l
  r' <- mapMTree f r
  return (Fork v' l' r')
```

### mapMRose
```haskell
mapMRose :: Monad m => (a -> m b) -> Rose a -> m (Rose b)
mapMRose f (Leaf x)    = Leaf <$> f x
mapMRose f (Branch xs) = Branch <$> mapM (mapMRose f) xs
```

### Side-effect-only tree walk
```haskell
walkTree :: Monad m => (a -> m ()) -> BT a -> m ()
walkTree _ Empty        = return ()
walkTree f (Fork x l r) = do
  walkTree f l
  f x
  walkTree f r
```

## Common use cases

### Read N numbers
```haskell
readN :: Int -> IO [Int]
readN n = replicateM n readLn
```

### Print every element
```haskell
printAll :: Show a => [a] -> IO ()
printAll = mapM_ print
```

### Log every step (Writer)
```haskell
import Control.Monad.Writer

logAll :: Show a => [a] -> Writer [String] ()
logAll = mapM_ (\x -> tell [show x])
```

### Apply stateful function to list
```haskell
import Control.Monad.State

labelList :: [a] -> State Int [(Int, a)]
labelList = mapM (\x -> do n <- get; put (n+1); return (n, x))
```

### Maybe-mapM (short-circuit)
```haskell
mapM (\x -> if x > 0 then Just (x*2) else Nothing) [1, 2, 3]
-- Just [2, 4, 6]
mapM (\x -> if x > 0 then Just (x*2) else Nothing) [1, -1, 3]
-- Nothing
```

## Choose which

| Goal                                  | Use            |
|---------------------------------------|----------------|
| Pure map                              | `map` / `fmap` |
| Monadic, collect                      | `mapM`         |
| Monadic, discard                      | `mapM_`        |
| Already have list of actions          | `sequence`     |
| Inline lambda (nicer to read)         | `forM`         |
| Run same action n times               | `replicateM`   |
| One-shot conditional                  | `when` / `unless` |

## ⚠ Pitfalls
- Use `map` (pure) vs `mapM` (monadic) — easy to confuse
- `mapM_ (\x -> ...)` over `for_ xs (\x -> ...)` — both fine
- `sequence []` returns `return []` (NOT `[]`) — preserves monad
- Order of effects = order of list (left-to-right)
- For Tree, order of `<-` bindings determines pre/in/post-order side effects

## See also
[Common Templates](common-templates.md) §16 · [State Monad](state-monad.md) · [Tree Recursion](tree-recursion.md) · [Functor](functor.md)
