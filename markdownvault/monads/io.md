# IO Monad

[← INDEX](../INDEX.md) · [↑ Monads](README.md) · [NAVIGATION](../NAVIGATION.md)

> **Mental model:** `IO a` is "a *recipe* that, when run by the Haskell runtime, performs real-world effects (reading input, printing, opening files…) and ultimately yields an `a`". You cannot extract the `a` purely — you can only sequence IO actions with other IO via `do`/`<-`. The entry point is `main :: IO ()`.

Real-world side effects. Type is opaque (no `runIO`).

## Type
```haskell
type IO a   -- conceptually: RealWorld -> (a, RealWorld)
```

## Entry point
```haskell
main :: IO ()
main = do
  putStrLn "Hello"
  ...
```

## Common operations
```haskell
putStr      :: String -> IO ()
putStrLn    :: String -> IO ()
putChar     :: Char -> IO ()
print       :: Show a => a -> IO ()      -- = putStrLn . show

getLine     :: IO String
getChar     :: IO Char
readLn      :: Read a => IO a            -- parse from stdin
getContents :: IO String                 -- LAZY whole-input stream

interact    :: (String -> String) -> IO ()
return      :: a -> IO a
```

## Terminal control (ANSI escapes)
```haskell
cls :: IO ()
cls = putStr "\ESC[2J"

goto :: (Int, Int) -> IO ()
goto (x, y) = putStr ("\ESC[" ++ show y ++ ";" ++ show x ++ "H")

-- Colour highlight (A1):
"\ESC[44m" ++ s ++ "\ESC[0m"
```

## Animation
```haskell
import Control.Concurrent (threadDelay)

life :: Grid -> IO ()
life g = do
  cls
  putGrid g
  threadDelay 100000     -- 0.1 sec
  life (step g)
```

## Interactive loop
```haskell
runGame :: Grid -> IO ()
runGame g
  | won g     = putStrLn "Done"
  | otherwise = do
      print g
      n <- readLn
      runGame (move g n)
```

## Patterns
```haskell
-- Read N values:
readNNumbers :: Int -> IO [Int]
readNNumbers n = replicateM n readLn

-- Print every element:
printAll :: Show a => [a] -> IO ()
printAll = mapM_ print
```

## ⚠ Pitfalls
- IO is OPAQUE — no `runIO :: IO a -> a`
- Use `<-` to extract from IO inside do
- `return x` in IO is pure (no side effect, just yields x)
- `getContents` is LAZY — combined with `interact`, works as stream filter

## See also
[State](state.md) · [TTT Winner](../examples/ttt-winner.md)
