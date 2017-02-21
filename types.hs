-- Types
---------------------------------------
-- Haskell uses an inferred static stype system
-- Statically typed
-- * LOTS of compile-time errors
-- * few runtime errors
-- Types are inferred
-- * don't have to write out explicit Types
-- * explicit types communicate with PEOPLE, checked by compiler
-- Same code can work for many different types

-- Exploring types in GHCi
---------------------------------------
-- `:t` - Print the type of an expression (only works in the repl)
-- `a -> b` - Function taking type `a` as a parameter, returning type `b`
-- `a -> b -> c` Function taking two parameters, `a` and `b` and returning type `c`
-- * a -> b -> c = a -> (b -> c) - one argument function that returns another one argument function

-- GHCi:
-- let x = 3
-- :t x
-- result: x :: Num t => t
--
-- let str = "hello"
-- :t str
-- result: str :: [Char] -- list of `Char` types
--
-- :t length str
-- result: length str :: Int -- type Int
--
-- :t lines
-- result: lines :: String -> [String]
--
-- let greet a b = a ++ " says hello to " ++ b
-- :t greet
-- result: greet :: [Char] -> [Char] -> [Char]

-- Explicit Types
---------------------------------------
-- define variable `str`
-- double colon (::) means type is being defined instead of value
-- `str` is a list of characters (string)
-- completely option to define the type
str :: [Char]
str = "hello"

-- Explicit function type
-- define a function that accepts an integer as an argument, and returns an integer
-- read as `foo` is (::) a function (->) that takes `Int` and returns `Int`
foo :: Int -> Int
foo x = 2 * x + 1

add3Int :: Int -> Int -> Int -> Int
add3Int x y z = x + y + z

-- Type annotation
x = 3 :: Int
-- example of overzealous type annotation, cannot add Int to a Double
-- will error:
-- y = (3 :: Int) + (2.1 :: Double)

-- Type Inference
---------------------------------------
-- not a dynamically typed language, but infers type based on usage
-- x must be a numerical type because of the * operator
square x = x * x
-- also OK
squareTwice x = square (square x)

-- broken because `square x` returns numerical, but `++` is a string operator
-- brokenShowSquare x = "The square is: " ++ square x


-- When to use Explicit Types
---------------------------------------

-- commmunicating with people
-- * pseudo class diagram

-- This function takes a string, and returns an Int
mystery :: [Char] -> Int

-- Tracking down compiler errors:
whats_wrong = x + y
  where x = length "Hello"
        y = 6/2

whats_wrong' = x + y
  where x :: Int
        x = length "Hello"
          y :: Int
          y = 6/2 -- 6/2 can't be an Int because / is not defined for Int's in Haskell

-- Helping the compiler (occasionally)
-- Helping compiler understand `read "123"` needs to be an Int
y = show (read "123" :: Int)

-- Optimizing Performance (only when necessary)
-- computer defaults to Integer, but Int would be faster
-- adding `bar :: Int` is slightly faster
bar :: Int
bar = x * y + z
  where x = 32
        y = 42
        z = -5

-- Polymorphism
---------------------------------------
-- (not the same as OOP)

length_ints :: [Int] -> Int
length_ints [] = 0
length_ints (x:xs) = length_ints xs + 1

length_chars :: [Char] -> Int
length_chars [] = 0
length_chars (x:xs) = length_chars xs + 1

-- GHCi:
-- :t length
-- result: [a] -> Int

-- `a` is a placeholder for any type
-- "type placeholder"

length :: [a] -> Int
length [] = 0
length (x:xs) = length xs + 1

-- `length` is a polymorphic function - A function with `a` type variable
-- * Not object-oriented polymorphism
-- Similar to C#/Java generics or C++ templates

-- Type variables - start lower case:
-- * `a`, `b`, `x`, `foo`, `hello_123`
-- Concrete Types - start with Upper case:
-- `Int`, `Integer`, `Char`, `Double`

-- `empty_list :: [a]` means it will accept a list of any type
empty_list :: [a]
empty_list = []

list_double = 3.2 : empty_list
list_char = 'a' : empty_list

-- second occurance `a` means it returns the same type
-- repeated type vars always represent the same type
head :: [a] -> a
head (x:xs) = x

-- compiler will reject this:
-- badHead :: [a] -> b
-- badHead (x:xs) = x
-- -- different type variables can represent different types
-- bad = (badHead [1.3,2,4]) : "foo"


-- won't work because of the second `a`
-- badSum :: [a] -> a
-- badSum [] = 0
-- badSum (x:xs) = x + sum xs


-- Type Constraints
---------------------------------------

-- Prelude> :t sum
-- GHCi:
-- sum :: Num a => [a] -> a

-- => (double arrow) is a type constraint: `a` must be a `Num` type
-- `a` must support `0` and a `+` operator in this case
-- Num is a type class - all types that can do numeric options
sum :: Num a => [a] -> a
sum [] = 0
sum (x:xs) = x + sum xs

-- Show function (Haskell's toString)
-- any type that can accept `Show` will return a list of `Char`
-- can't pass a function to `Show`
show :: Show a => a -> [Char]

-- function can have multiple type class constraints:
-- `a` must be in Num and Show class
showSum :: (Num a, Show a) => [a] -> [Char]
showSum xs = show (sum xs)

-- GHCi:
-- Prelude> :t 3
-- 3 :: Num t => t
-- Prelude> :t 3.1
-- 3.1 :: Fractional t => t
-- Prelude> :t map
-- map :: (a -> b) -> [a] -> [b]
-- Prelude> :t filter
-- filter :: (a -> Bool) -> [a] -> [a]
-- Prelude> :t length
-- length :: Foldable t => t a -> Int
