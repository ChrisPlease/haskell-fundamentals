
-- putStrLn is an io action
-- main :: IO ()
-- main = putStrLn "Hello World"

-- main - IO action executed by the program

-- Prelude> :t putStrLn
-- putStrLn :: String -> IO ()

-- () equivalent to void in C#

-- data Unit = Unit - placeholder with no data
-- data IO a

-- putStrLn takes a String and returns an IO Unit

-- IO Action - a code that could be run to interact with the outside World

-- Do blocks
------------------------
-- everything in a do block is an IO Action
-- do blocks end on the first line that isn't indented
-- main2 :: IO ()
-- main = do
--   putStrLn "Hello"
--   putStrLn "World"
-- x = 3 -- ends here

-- Output:
-- Hello
-- World

-- introduce :: String -> String -> IO ()
-- introduce name1 name2 = do
--   putStrLn (name1 ++ ", this is " ++ name2)
--   putStrLn (name2 ++ ", this is " ++ name1)

-- main :: IO ()
-- main = do
--   introduce "Alice" "Bob"
--   introduce "Alice" "Sally"

-- IO Values
---------------------------------------

-- main :: IO ()
-- main = do
--   line <- getLine
--   putStrLn ("You said: " ++ line)

-- Prelude> :t getLine
-- getLine :: IO String


-- getLine - IO Action
-- left arrow binds getLine to a variable
-- only inside a do block
-- bound variables can only be used later in the same do-block


greet :: IO ()
greet = do
  putStrLn "Who are you?"
  who <- getLine
  putStrLn ("Hello " ++ who)

greetForever :: IO ()
greetForever = do
  greet
  greetForever -- lazy loaded, infinite data structure


-- `main` is needed to run everything
-- main :: IO ()
-- main = greetForever

-- `return` Function
---------------------------------------
dummyGetLine :: IO String
dummyGetLine =
  return "I'm not really doing anything"

-- main :: IO ()
-- main = do
--   line <- dummyGetLine
--   putStrLn line

-- return :: a -> IO a
-- takes a value, produces an IO action

-- pass name and color into the return function for the IO Action
promptInfo :: IO (String, String)
promptInfo = do
  putStrLn "What is your name?"
  name <- getLine
  putStrLn "What is your favorite color?"
  color <- getLine
  return (name,color) -- left arrows turn them into strings

-- main :: IO ()
-- main = do
--   (name,color) <- promptInfo -- pattern match
--   putStrLn ("Hello " ++ name)
--   putStrLn ("I like " ++ color ++ " too!")


-- main :: IO ()
-- main = do
--   line1 <- getLine
--   line2 <- getLine
--   let lines = line1 ++ line2 -- special `let` case in the do block
--   putStrLn lines



-- Some Useful IO Actions

-- putStrLn :: String -> IO ()
-- -- print a string to the console, append a new line
-- getLine :: IO String
-- -- reads a line from the console
-- print :: (Show a) => a -> IO ()
-- -- print string representation of a value (must be a `Show` type class)
-- readFile :: FilePath -> IO String
-- -- reads an entire file as a (lazy) string
-- writeFile :: FilePath -> String -> IO ()
-- -- writes a string to a file
-- appendFile :: FilePath -> String IO ()
-- -- appends string to a file
-- interact :: (String -> String) -> IO ()
-- -- takes a parameter (a function from string to string) - used as output

-- function using interact:
  -- lines breaks up the input by line
  -- map to apply the reverse function
  -- reverse reverses the list of string
  -- unlines - function, concatenates all the lines together into a single string, with new lines in between
reverseLines :: String -> String
reverseLines input =
  unlines (map reverse (lines input))

-- main :: IO ()
-- main = interact reverseLines

-- type FilePath = String


-- Do as little IO as possible


-- basic encryption algorithm:
encrypt :: Char -> Char
encrypt c
  | 'A' <= c && c < 'Z' =
    toEnum (fromEnum 'A' + 1)
  | c == 'Z' = 'A'
  | otherwise = c

main :: IO ()
main = interact (map encrypt)
