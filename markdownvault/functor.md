# Functor — Complete Reference

[← INDEX](INDEX.md) · [NAVIGATION](NAVIGATION.md)

> **Mental model:** a Functor is "a container with a hole you can swap the contents of, without disturbing the shape." `fmap` takes a function `a -> b` and rewires every `a` inside the container to a `b`.

## Class
```haskell
class Functor f where
  fmap :: (a -> b) -> f a -> f b

(<$>) :: Functor f => (a -> b) -> f a -> f b   -- infix alias
```

## Laws
| Law          | Statement                        | Why it matters                       |
|--------------|----------------------------------|--------------------------------------|
| identity     | `fmap id = id`                   | mapping nothing-changes is nothing   |
| composition  | `fmap (g . f) = fmap g . fmap f` | one pass with `g . f` = two passes   |

If your `fmap` *changes the shape* (e.g. drops elements, reorders), it breaks the identity law — not a valid Functor.

## RULE for writing your own
> 1. Walk every constructor.
> 2. Apply `f` to `a`-typed slots only.
> 3. Recurse with `fmap` on slots that themselves hold `a` (subtrees, lists of `a`-shaped things).
> 4. Preserve shape — same ctor, same arity, same children positions.

---

## STANDARD INSTANCES

### Maybe
```haskell
instance Functor Maybe where
  fmap _ Nothing  = Nothing
  fmap f (Just x) = Just (f x)
```

### List
```haskell
instance Functor [] where
  fmap = map
```

### Either (right-biased)
```haskell
instance Functor (Either e) where
  fmap _ (Left e)  = Left e
  fmap f (Right x) = Right (f x)
```

### Tuple (right-biased)
```haskell
instance Functor ((,) a) where
  fmap f (a, x) = (a, f x)
```

### IO
```haskell
instance Functor IO where
  fmap f m = m >>= return . f
```

---

## TREE INSTANCES

### Binary tree
```haskell
data BT a = Empty | Fork a (BT a) (BT a)

instance Functor BT where
  fmap _ Empty        = Empty
  fmap f (Fork x l r) = Fork (f x) (fmap f l) (fmap f r)
```

### Rose tree
```haskell
data Rose a = Leaf a | Branch [Rose a]

instance Functor Rose where
  fmap f (Leaf x)    = Leaf (f x)
  fmap f (Branch xs) = Branch (map (fmap f) xs)
```

### Bin (variant — ewan31-40.hs)
```haskell
data Bin a = Lf | Nd a (Bin a) (Bin a)

instance Functor Bin where
  fmap _ Lf         = Lf
  fmap f (Nd x l r) = Nd (f x) (fmap f l) (fmap f r)
```

### Tree with list of children (Node a [Tree a])
```haskell
data Tree a = Node a [Tree a]

instance Functor Tree where
  fmap f (Node x ts) = Node (f x) (map (fmap f) ts)
```

---

## FUNCTION INSTANCE

### Reader (no newtype)
```haskell
instance Functor ((->) r) where
  fmap = (.)
-- fmap g f = g . f
```

### Reader (with newtype)
```haskell
newtype Reader r a = Reader { runReader :: r -> a }

instance Functor (Reader r) where
  fmap g (Reader r) = Reader (g . r)
```

---

## COMPOUND INSTANCES

### Functor sum (FSum)
```haskell
data FSum f g a = FLeft (f a) | FRight (g a)

instance (Functor f, Functor g) => Functor (FSum f g) where
  fmap h (FLeft  fa) = FLeft  (fmap h fa)
  fmap h (FRight ga) = FRight (fmap h ga)
```

### Functor product
```haskell
data FProd f g a = FProd (f a) (g a)

instance (Functor f, Functor g) => Functor (FProd f g) where
  fmap h (FProd fa ga) = FProd (fmap h fa) (fmap h ga)
```

### Functor composition
```haskell
newtype Compose f g a = Compose (f (g a))

instance (Functor f, Functor g) => Functor (Compose f g) where
  fmap h (Compose fga) = Compose (fmap (fmap h) fga)
```

---

## CUSTOM CTOR (Free monad — A3)
```haskell
data Free f a = Pure a | Free (f (Free f a))

instance Functor f => Functor (Free f) where
  fmap g (Pure a) = Pure (g a)
  fmap g (Free fa) = Free (fmap (fmap g) fa)
```

---

## TYPED VALUE — Functor on heterogeneous (NOT a Functor)
`data BinLN a b` is bi-functor — `Functor` is single-param. You'd need `Bifunctor` class (not in course) OR write `mapBoth :: (a -> c) -> (b -> d) -> BinLN a b -> BinLN c d`.

---

## COMMON COMBINATORS (derive from fmap)
```haskell
(<$) :: Functor f => a -> f b -> f a
x <$ fb = fmap (const x) fb

($>) :: Functor f => f a -> b -> f b
fa $> y = fmap (const y) fa

void :: Functor f => f a -> f ()
void = fmap (const ())
```

## ⚠ Pitfalls
- **fmap changing SHAPE** — only allowed to transform values, not restructure
- Forget compound constraints: `instance (Functor f, Functor g) => Functor (FSum f g)`
- Confuse `f` (your type parameter) with `f` (the transforming function) — alpha-rename
- `instance Functor (Either e)` — `e` is fixed; can only fmap over `b`
- Tuple `(,)` is right-biased — `fmap f (1, 2) = (1, f 2)`
- For heterogeneous types (2+ type params), Functor only acts on LAST param

## See also
[Common Templates](common-templates.md) §15 · [mapM](mapm.md) · [Applicative](typeclasses/applicative.md) · [Monad](typeclasses/monad.md)
