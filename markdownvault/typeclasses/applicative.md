# Applicative

[← INDEX](../INDEX.md) · [↑ Typeclasses](README.md) · [NAVIGATION](../NAVIGATION.md)

> **Mental model:** Functor lets you map one pure function over one wrapped value. Applicative lets you do this with *multi-argument* functions and *multiple* wrapped values: `f <$> mx <*> my <*> mz` applies `f` to whatever is inside `mx, my, mz`. The "effect" of each is sequenced left-to-right; the result combines them all.

"Apply wrapped fn to wrapped value." Subclass of [Functor](functor.md).

## Class
```haskell
class Functor f => Applicative f where
  pure  :: a -> f a
  (<*>) :: f (a -> b) -> f a -> f b
```

## Laws
- `pure id <*> v = v`
- `pure (g . f) <*> u = u <*> pure f <*> pure g` (composition, see book)
- `pure f <*> pure x = pure (f x)` (homomorphism)
- `u <*> pure y = pure ($ y) <*> u` (interchange)

## Standard instances

### Maybe
```haskell
instance Applicative Maybe where
  pure          = Just
  Nothing <*> _ = Nothing
  Just f  <*> x = fmap f x
```

### List
```haskell
instance Applicative [] where
  pure x    = [x]
  fs <*> xs = [f x | f <- fs, x <- xs]
```

### Reader
```haskell
instance Applicative ((->) r) where
  pure      = const
  rf <*> rx = \e -> rf e (rx e)
```

### Parser
```haskell
instance Applicative Parser where
  pure x      = P (\s -> [(x, s)])
  P p <*> P q = P (\s -> [(f x, s'') | (f, s') <- p s, (x, s'') <- q s'])
```

## n-ary lifting
```haskell
liftA2 :: Applicative f => (a -> b -> c) -> f a -> f b -> f c
liftA2 f a b = pure f <*> a <*> b
-- or:        f <$> a <*> b
```

## Rule for custom Applicative
- `pure` = wrap in minimal effect
- `<*>` = thread effects left-to-right, combine the function with the value

## ⚠ Pitfalls
- Must declare even if you only use `Monad` (Applicative is required base)
- `pure f <*> a <*> b <*> c` is the n-ary lift idiom

## See also
[Functor](functor.md) · [Monad](monad.md) · [Alternative](alternative.md)
