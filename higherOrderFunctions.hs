-- Higher Order Functions
---------------------------------------

-- functions with function arguments
-- create functions on the fly
-- * partial function application
-- * lambda expressions
-- * function composition

-- Functions as Values
---------------------------------------
pass3 f = f 3 -- `f` is a function that is passed 3

add1 x = x + 1

-- GHCi:
-- pass3 add1
-- Result: 4 -- add1 3 = 3 + 1 = 4

compose f g x = f (g x) -- `f` and `g` are functions, passes `g x` to `f`

-- add1 x = x + 1
mult2 x = 2 * x

-- GHCi:
-- compose add1 mult2 4
-- result: 9 -- (mult2 4) = (2 * 4) + 1 = 9

-- always returns 7, no matter what the argument is
always7 x = 7
always7alt = const 7

-- `const` can be passed directly, without defining the function:
-- GHCi:
-- (const 7) 5
-- result: 7

-- Partial Application
---------------------------------------

-- Haskell can take partial parameters in a function
-- Java:
-- int foo(int x, int y, int z) {
--   return x + y + z;
-- }
-- error:
-- foo_1_2 = foo(1,2)

foo x y z = x + y + z
foo_1_2 = foo 1 2
-- foo_1_2 now takes 1 argument: `z`
-- GHCi:
-- foo_1_2 3
-- Result: 6 -- 1 + 2 + 3

pass x f = f x -- takes a value `x` and function `f`
-- pass3alt can then be built by partially applying `pass` function
pass3alt = pass 3

-- Arguments must be given in Order

-- Operators
---------------------------------------

-- +, *, :, ++ are all functions
-- parens around operator to use as a function: (+), (*), (:), (++)

-- GHCi:
-- (+) 5 3
-- result: 8

-- pass function `f` with arguments 3 and 4
pass_3_4 f = f 3 4

-- GHCi:
-- pass_3_4 (+)
-- result: 7 -- 3 + 4

-- Operator Definitions
-- defining a new operator:
-- adding together a pair of numbers like 2d vectors
-- .+ is a new operator
-- args are pairs (a,b) and (c,d)
(a,b) .+ (c,d) = (a + c, b + d)

-- Partially applying operators
-- partial application of the + operator returns a new function accepting 1 argument
-- which is the missing 2nd argument of the plus function
plus1 = (+) 1

plus1alt = (1+) -- passed parameter will be on the right side of the plus
plus1alt2 = (+1) -- passed parameter will be on the left side of the plus

-- Turn functions into operators
-- GHCi:
-- mod 10 2
-- 10 `mod` 2
-- results: 0

-- Map
---------------------------------------
-- Applies a function to every element in a list

-- GHCi:
-- map length ["hello", "abc", "1234"]
-- result: [5,3,4]

-- It's helpful to use partially applied functions with map:
-- GHCi:
-- map (1+) [1,3,5,7]
-- result: [2,4,6,8]

-- Alternative approach to double function using map:
-- creates a new function accepting the second argument in map (a list)
-- Production:
double = map (2*)

-- Filter
---------------------------------------
-- Tests each element, keeps those that pass
notNull xs = not (null xs)

-- GHCi:
-- filter notNull ["", "abc", "", "hello", ""]
-- result: ["abc", "hello"]

-- remove even numbers from a list using `filter`
isEven x = x `mod` 2 == 0
-- removeOdd partially applies `filter` to `isEven`, taking the list as a second argument
removeOdd = filter isEven

-- Combining map and filter
-- `filter` checks for the boolean value, and `map snd` provides the second argument
-- `filter` runs first, followed by `map`
-- GHCi:
-- map snd (filter fst
--           [(True,1), (False, 7), (True, 11)])
-- result: [1,11]

-- Fold
---------------------------------------
-- combines all values in a list
-- two versions:
-- * foldl
-- * foldr

-- foldl
-- first argument is a function (+)
-- second argument is the accumulator value/intial value, appended to the beginning of the list
-- third argument is a list

-- GHCi:
-- foldl (+) 0 [1,2,3,4]
-- result: 10 -- 0 + 1 + 2 + 3 + 4 = 10

showPlus s x = "(" ++ s ++ "+" ++ (show x) ++ ")" -- show changes number to string
-- GHCi:
-- showPlus "(1 + 2)" 3
-- result: "((1 + 2) + 3)"
--
-- foldl showPlus "0" [1,2,3,4]
-- result: ((((0 + 1) + 2) + 3) + 4)

-- foldr
-- GHCi:
-- foldr (+) 0 [1,2,3,4]
-- result: 10 -- 1 + 2 + 3 + 4 + 0 = 10

-- we need a new version of show plus because accumulator is now the right hand argument
showPlusAlt x s = "(" ++ (show x) ++ "+" ++ s ++ ")"
-- GHCi:
-- foldr showPlusAlt "0" [1,2,3,4]
-- result: (1 + (2 + (3 + (4+0))))

-- foldl vs foldr
-- addition does not matter, but any other operation does
-- foldl: slightly faster because it's tail recursive
-- cannot use foldl on infinite list, but can use foldr

-- GHCi:
-- foldl (-) 0 [1,2,3]
-- result: -6
-- ((0-1) - 2) - 3 = ((-1) - 2) - 3 = (-3) - 3 = -6
--
-- foldr (-) 0 [1,2,3]
-- result: 2
-- 1 - (2 - (3 - 0)) = 1 - (2 - 3) = 1 - (-1) = 1 + 1 = 2

-- Zip and ZipWith
---------------------------------------
-- takes two lists, and creates a list of pairs, first el is from first list, second el is from second list

-- GHCi:
-- zip [1,2,3] [4,5,6]
-- result: [(1,4), (2,5), (3,6)]

-- stops when either input list stops:
-- GHCi:
-- zip [1,2] [3,4,5,6]
-- result: [(1,3), (2,4)]

-- zipWith
-- performs a function on the lists
-- this example adds the elements from corresponding lists
-- GHCi:
-- zipWith (+) [1,2,3] [4,5,6]
-- result: [5,7,9]

-- zipWith can take multiples as well for multiple lists:
plus3 x y z = x + y + z

-- GHCi:
-- zipWith3 plus3 [1,2,3] [4,5,6] [7,8,9]
-- result: [12,15,18]


-- Lambda expressions
---------------------------------------
-- define functions where they are used
-- used for more complex applications where partial function application cannot easily be addressed
--
-- lambda expressions start with a backslash (\)
-- then function parameters ( x y z )
-- then arrow (->)
-- followed by function body (x + y + z)

-- GHCi:
-- zipWith3 (\ x y z -> x + y + z)
--            [1,2,3] [4,5,6] [7,8,9]
-- result: [12,15,18]

-- the following example can be done with partial application: map (2*) [1,2,3]
-- GHCi:
-- map (\x -> 2 * x) [1,2,3]
-- result: [2,4,6]

-- an example of an appropriate use of lambda expressions, where partial application is not enough
-- GHCi:
-- map (\x -> 2 * x + 1) [1,2,3]
-- result: [3,5,7]

-- When to use Lambda functions
-- * narrow range of use
-- * too simple: partial application
-- * too complex: named function


-- Function Operators
---------------------------------------

-- (.) - Function composition
-- - takes 2 functions, and combines them into a new function
-- ($) - Function appliation
-- - takes a function and a value and applies the function to the value

-- Composition:
-- composes the `show` function, which returns a string representation, with a length value
-- this will return the length of the string representation of a value
stringLength = length . show
-- stringLength x = length (show x)

-- GHCi:
-- stringLength 120
-- result: 3

-- Order is very important in function composition
-- composed functions are applied right to left, for example:
-- `show` is applied, followed by `length`
-- Composition only works when the function has one argument
-- cannot compose:
-- f a b = a + b
-- g x = 2 * x

-- takes the value, applies `null` then negates it with the `not` function
notNull2 = not . null

-- Function application ($)
f $ x = f x

-- common use to replace parens
-- puts parens around everything to the right:
f $ g $ h $ k x = f (g ( h (k x)))

-- Also useful in higher order functions:
-- GHCi:
-- map (\f -> f 3) [(+1), (\x -> 2*x + 3), (*2)]
-- result: [4,9,6]

-- Above example with partially applied $ operator:
-- GHCi:
-- map ($3) [(+1), (\x -> 2*x + 3), (*2)]
-- result: [4,9,6]

-- GHCi:
-- zipWith ($) [(+1), (\x -> 2 * x + 3), (*2)] [1,2,3]
-- result: [2,7,6]
