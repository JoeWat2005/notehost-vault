# Template — Monad (+ Applicative + Functor) instance

[← INDEX](../INDEX.md) · [↑ Templates](README.md) · [NAVIGATION](../NAVIGATION.md)

> **What this pattern is doing:** Haskell *requires* `Functor` and `Applicative` superclasses for every `Monad`. So writing a custom monad means writing all three instances together. `fmap` is "map a function over values", `pure`/`<*>` is "wrap and combine", `>>=` is "chain dependently".

You typically declare ALL THREE.

## Maybe-shaped (short-circuit)
```haskell
data MyMaybe a = MyNothing | MyJust a

instance Functor MyMaybe where
  fmap _ MyNothing  = MyNothing
  fmap f (MyJust x) = MyJust (f x)

instance Applicative MyMaybe where
  pure = MyJust
  MyNothing <*> _      = MyNothing
  MyJust f  <*> mx     = fmap f mx

instance Monad MyMaybe where
  return = pure
  MyNothing >>= _  = MyNothing
  MyJust x  >>= f  = f x
```

## List-shaped (non-determinism)
```haskell
data MyList a = Nil | Cons a (MyList a)

append Nil ys = ys
append (Cons x xs) ys = Cons x (append xs ys)

instance Functor MyList where
  fmap _ Nil         = Nil
  fmap f (Cons x xs) = Cons (f x) (fmap f xs)

instance Applicative MyList where
  pure x = Cons x Nil
  Nil         <*> _ = Nil
  Cons f fs   <*> xs = append (fmap f xs) (fs <*> xs)

instance Monad MyList where
  return = pure
  Nil         >>= _ = Nil
  Cons x xs   >>= f = append (f x) (xs >>= f)
```

## Reader (function-shaped)
```haskell
newtype Reader r a = Reader { runReader :: r -> a }

instance Functor (Reader r) where
  fmap g (Reader r) = Reader (g . r)

instance Applicative (Reader r) where
  pure x = Reader (const x)
  Reader rf <*> Reader rx = Reader (\e -> rf e (rx e))

instance Monad (Reader r) where
  return = pure
  Reader r >>= f = Reader (\e -> runReader (f (r e)) e)
```

## State (hand-rolled)
```haskell
newtype State s a = State { runState :: s -> (a, s) }

instance Functor (State s) where
  fmap g (State p) = State (\s -> let (x, s') = p s in (g x, s'))

instance Applicative (State s) where
  pure x = State (\s -> (x, s))
  State pf <*> State px = State $ \s ->
    let (f, s')  = pf s
        (x, s'') = px s'
    in (f x, s'')

instance Monad (State s) where
  return = pure
  State p >>= f = State $ \s ->
    let (x, s') = p s
        State q = f x
    in q s'
```

## ⚠ Pitfalls
- Haskell REQUIRES Functor + Applicative + Monad — declare all three even if `pure = return`
- `>>= ` for List must fan out (`concatMap`), NOT just first element
- For State, the inner function MUST match constructor unpacking

## See also
[Monad](../typeclasses/monad.md) · [Functor Instance](functor-instance.md) · [Functor Instance](../archetypes/06-functor-instance.md)
