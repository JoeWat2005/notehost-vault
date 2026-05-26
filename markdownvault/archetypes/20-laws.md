# Archetype 20 — Isomorphism / Retract / Laws (Theory)

[← INDEX](../INDEX.md) · [↑ Archetypes](README.md) · [NAVIGATION](../NAVIGATION.md)

⭐ W12 rigour, W5 retracts; possible theory exam question.

## Concept
Verify that two functions are mutually inverse (iso) or partially inverse (retract); prove typeclass laws.

**Intuition:** an *isomorphism* means lossless round-tripping in both directions. A *retract* is one-way lossless: you can encode and decode losslessly, but not every value in the bigger type comes from an encode. Proofs use structural induction.

## Shapes

### Isomorphism
`f . g = id` AND `g . f = id`

### Retract
`f . g = id` (one direction only)

### Functor laws
```
fmap id = id
fmap (g . f) = fmap g . fmap f
```

### Monad laws
```
return x >>= f       = f x                  -- left identity
m >>= return         = m                    -- right identity
(m >>= f) >>= g      = m >>= (\x -> f x >>= g)   -- associativity
```

## How to "verify" / "prove"
- Induction over ADT structure (base case + inductive step)
- Case analysis on Maybe/Either constructors
- Equational reasoning using definitions

## Typical questions
- "Show that `decodeText t (encodeText t s) = s`"
- "Is `tabulate ∘ ramify` the identity?" (answer: NO — only `ramify ∘ tabulate = id`)
- "Prove the Functor laws for your BT instance"
- "WorkingDay is a retract of WeekDay — give the functions"

## Examples

### WorkingDay retract of WeekDay (W5)
```haskell
toWeekDay :: WorkingDay -> WeekDay
toWeekDay Mon' = Mon ; ... ; toWeekDay Fri' = Fri

toWorkingDay :: WeekDay -> WorkingDay
toWorkingDay Mon = Mon'   ; toWorkingDay Tue = Tue'
toWorkingDay Wed = Wed'   ; toWorkingDay Thu = Thu'
toWorkingDay Fri = Fri'
toWorkingDay Sat = Fri'   -- fallback
toWorkingDay Sun = Mon'   -- fallback

-- toWorkingDay . toWeekDay = id   (one direction)
-- toWeekDay . toWorkingDay ≠ id   (because of weekend fallbacks)
```

## ⚠ Traps
- One direction doesn't imply the other
- Empty / boundary cases must be covered explicitly
- Course uses Agda-flavoured notation in `rigour.md` (∀, Σ, ≡, ¬)

## Combines with
[#07 Codec](07-codec.md) · [#12 Rep conv](12-rep-conv.md) · [#06 Instance](06-functor-instance.md)

## Seen
W12 rigour lecture, W5 type retracts, scattered theory questions

## See also
[Codec Pair](../patterns/codec-pair.md) · [Functor](../typeclasses/functor.md)
