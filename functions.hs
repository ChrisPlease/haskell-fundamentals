-- Functions
---------------------------------------
-- simple squaring function
square x = x * x
-- no parens
-- no `return` keyword
-- ghci needs `let` keyword:
-- let square x = x * x

-- finds max of a or b then multiplies by x
multMax a b x = (max a b) * x

posOrNeg x =
  if x >= 0
  then "Positive"
  else "Negative"
-- No parens around condition
-- No return statement

-- All Haskell functions are pure:
-- * cannot modify state
-- * cannot depend on state
-- * given the same arguments, always return the same output

-- Recursion
---------------------------------------
-- pow2 n = 2 to the n power
pow2 n =
  if n == 0
  then 1 -- base case: needed by all recursive functions
  else 2 * (pow2 (n - 1))

-- Imperative equivalent of pow2
-- int pow2(int n) {
--   int x = 1;
--   for (int = 0; i<n; i++)
--     x *= 2;
--   return x;
-- }

repeatString str n =
  if n == 0
  then ""
  else str ++ (repeatString str (n - 1))

-- Imperative equivalent of repeatString
-- int repeatString(String str, int n) {
--   String result = "";
--   for (int = 0; i < n; i++)
--     result += str;
--   return result;
-- }

-- Replacing loops with Recursion
pow22 n = pow2loop n 1 0 -- pow2loop is a helper function for the loop
pow2loop n x i =
  if i<n
  then pow2loop n (x*2) (i+1)
  else x -- return x if i is not less than n

-- Lists
---------------------------------------
-- basic collection type in Haskell
list = [1,2,3]
emptyList = []
list2 = 0 : list -- [0,1,2,3]
-- colon is the `Cons` operator, always takes an element and a list, adds the element to the front
-- does not modify the list, creates a new list

-- Alternative, longhand syntax of the original `x` list:
list3 = 1 : (2 : (3 : []))
list4 = 1 : 2 : 3 : []

-- Strings are really lists of characters
str = "abcde" -- note double quotes
str2 = 'a' : 'b' : 'c' : 'd' : 'e' : []

-- Concatenation
-- ++ concatenation operator
-- GHCi:
-- [1,2,3] ++ [4,5]
-- Result: [1,2,3,4,5]
-- strings too!
-- "hello " ++ "world"
-- Result: "hello world"

-- Lists must be homogeneous:
-- error = [1, "hello", 2] -- invalid list

-- Accessing lists
-- GHCi:
-- head [1,2,3]
-- result: 1
-- tail [1,2,3]
-- result: [2,3]
-- `head` returns the first item in the list
-- `tail` returns everything but the first item in the list

-- head (tail ([1,2,3]))
-- result: 2

-- testing for empty lists:
-- null []
-- result: True
-- null [1,2]
-- result: False

-- List functions
-- creates a new list of doubled original list
double nums =
  if null nums
  then [] -- base case: return empty list if original list is empty
  else (2 * (head nums)) : (double (tail nums))

removeOdd nums =
  if null nums
  then []
  else
    if (mod (head nums) 2) == 0 -- `mod` modulus operator: is num / 2 === 0
    then (head nums) : (removeOdd (tail nums)) -- if num / 2 == 0, add num to head of list, then recursively check rest of list
    else removeOdd (tail nums) -- else go to next number

-- Tuples
--------------------------------------
-- tuples are wrapped in parens, can hold different types
-- can have more than 2 elements
tuple = (1, "hello")
tuple2 = ("pi", 3.14159, [1,2,3], "four")

-- Tuples vs Lists
----
-- Tuples
-- (...)
-- different types
-- fixed lengths

-- Lists
-- [...]
-- same type
-- abitrary lengths

-- Returning Tuples
-- returns a tuple with head and length of the list
headAndLength list = (head list, length list)

-- Accessing Tuple Elements
-- accessed through pattern matching
-- accessing pairs of tuples:
-- GHCi:
-- fst (1, "hello")
-- result: 1
-- snd (1, "hello")
-- result: "hello"

-- Tuple warnings
-- Avoid big tuples (4 max)
-- Avoid tuples spanning the application


-- Pattern Matching
---------------------------------------
fst2 (a,b) = a -- first prime so won't conflict with native `fst`
snd2 (a,b) = b -- second prime, returns second element

-- How null is handled
null2 [] = True
null2 (x : xs) = False -- Pattern matches any list that is formed by using the `cons` operator to add some value x to the front of some list xs

head2 (x : xs) = x
-- error:
-- head2 [] = error "head of empty list"
-- cannot define head in a robust way!

-- double function using pattern matching:
double2 [] = [] -- case for empty list
double2 (x : xs) = (2 * x) : (double2 xs) -- apply double recursively


-- Guards
---------------------------------------
-- pow2 using guards:
pow23 n
  | n == 0    = 1
  | otherwise = 2 * (pow23 (n - 1)) -- computed recursively

-- no `=` before guards
-- `|` before each guard
-- `otherwise` is a boolean exp which is always True
-- keyword for a catch all in a guarded function

-- removeOdd using guards:
removeOdd2 [] = [] -- handle empty lists
removeOdd2 (x : xs) -- non empty lists
  | mod x 2 == 0 = x : (removeOdd2 xs)
  | otherwise    = removeOdd2 xs


-- Case Expressions
---------------------------------------
-- double function using cases, identical to pattern matching:
-- `nums` after `case` can be any expression
double3 nums = case nums of
  []         -> [] -- case of empty list
  (x : xs)   -> (2 * x) : (double3 xs)

-- cannot be easily rewritten using pattern matching:
-- pattern matches on the result of `removeOdd` function
anyEven nums = case (removeOdd nums) of
  []        -> False
  (x : xs)  -> True

-- No guards in case expressions

-- Bindings
---------------------------------------
-- Let Binding
-- `let` bindings define a local variable, but local variables can't ever be changed
fancySeven =
  let a = 3 -- variable assignment
  in 2 * a + 1 -- `in` keyword marks subexpression where `a` can be used

fancyNine =
  let x = 4
      y = 5
  in x + y

numEven nums =
  let evenNums = removeOdd nums -- list of even nums
  in length evenNums -- count of even nums

-- Where Binding
-- `where` comes after the function which uses the vars
fancySeven2 = 2 * a + 1
  where a = 3

fancyNine2 = x + y
  where x = 4
        y = 5

-- Where vs Let
-- `where` goes with a function definition
-- fancyTen = 2 * (a + 1 where a = 4) -- ERROR
fancyTen = 2 * (let a = 4 in a + 1)

-- Where - top down
-- * presents the highest level first
-- Let - bottom up
-- shows individual bindings first, then builds up to the final result in the end

-- Whitespace
---------------------------------------
-- Do not use tabs. EVER.
-- Indent further when breaking expression onto another line
-- Line up variable bindings

-- Valid:
pairMax p = max (fst p)
              (snd p)

-- Not valid:
-- pairMax p = max (fst p)
--   (snd p)

-- Lazy Function Evaluation
---------------------------------------
-- no guarantee when functions are evaluated

-- Lazy infinite lists:
intsFrom n = n : (intsFrom (n+1))
ints = intsFrom 1

-- GHCi:
-- null ints
-- result: False
-- head ints
-- result: 1
-- take 10 ints -- takes the first 10 items from a list
-- result: [1,2,3,4,5,6,7,8,9,10]
-- length ints
-- result: -- runs infinitely
-- let evenInts = removeOdd ints
-- take 10 evenInts
-- result: [2,4,6,8,10,12,14,16,18,20]
