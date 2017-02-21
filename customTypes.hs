import Prelude hiding (String)
-- Custom Types
---------------------------------------
---------------------------------------

-- Type Synonyms
---------------------------------------
-- new name to refer to an existing
-- defines the `String`
-- `type` keyword
-- String = list of `Char`
type String = [Char]

-- Geometric computations:
type Point = (Double, Double)

-- midpoint :: (Double,Double) -> (Double,Double) -> (Double,Double)
midpoint :: Point -> Point -> Point
midpoint (x1,y1) (x2,y2) = ((x1 + x2) / 2, (y1 + y2) / 2)

-- can mix and match, but should be avoided:
p1 :: (Double, Double)
p1 = (1,2)

p2 :: Point
p2 = (3,4)

mid :: (Double, Double)
mid = midpoint p1 p2

-- * make code more readable
-- * semantic meaning
-- * completely ignored by the compiler

-- Newtype
---------------------------------------
-- creates a non-interchangeable synonym
-- `newtype` followed by the new name type
-- Constructor name `MakeCustomerId`
-- Representation type `Int`
-- Constructor name can match new type: `newtype CustomerId = CustomerId Int`
newtype CustomerId = CustomerId Int

-- Cannot create a customer directly from an `Int` type
-- badCustomer :: CustomerId
-- badCustomer = 13

-- customer :: CustomerId
-- customer = MakeCustomerId 13

-- Convert CustomerId to Int through pattern matching
customerToInt :: CustomerId -> Int
customerToInt (CustomerId i) = i

-- * create a new type represented by an existing type
-- * New type and representation cannot be mixed up
-- * add semantic meaning, checked by compiler


-- Records
---------------------------------------
-- allow you to define a type with several named fields
-- `Customer` Record
-- `MakeCustomer` constructor
-- `customerId` with a `CustomerId` type
-- `name` with a `String` synonym
-- `luckyNumber` with an `Int` type


-- data Customer = MakeCustomer
--   { customerId  :: CustomerId
--   , name        :: String
--   , luckyNumber :: Int
--   }

-- alice :: Customer
-- alice = MakeCustomer
--   { customerId  = MakeCustomerId 14
--   , name        = "Alice"
--   , luckyNumber = 42
--   }

-- Accessing record values:
-- GHCi:
-- *Main> name alice
-- "Alice"
-- *Main> luckyNumber alice
-- 42

-- Records can also be updated:
-- take record value `alice` and add updates
-- sally = alice { name = "Sally", luckyNumber = 84 }

-- asking for `alice` returns old information for alice
-- since functions are pure

-- * not extensible
-- data Person = Person { name :: String }
-- data Customer = Customer extends
--   Person { luckyNumber :: Int }

-- * no shared field names
-- error: both `Customer` and `Supplier` cannot both have `name` field
-- data Customer = Customer
--   { name       :: String
--   , customerId :: CustomerId
--   }

-- data Supplier = Supplier
--   { name       :: String
--   , supplierId :: SupplierId
--   }

-- ** Weakest point of the language, and should be avoided
-- almost always use an algebraic data type

-- Algebraic Data Types
---------------------------------------
-- Workhorse data type in Haskell
-- almost every type used will be an Algebraic Data Type
-- `data` keyword
-- name of type being defined `Customer`
-- `Customer` is the constructor
-- type of arguments:
-- `CustomerId` will be the customer id
-- `String` will be the name
-- `Int` will be luckyNumber
-- also highlights how useful newtypes and synonyms are important
-- Order matters!
-- constructor can also match type name

data Customer = Customer CustomerId String Int
alice :: Customer
alice = Customer (CustomerId 13) "Alice" 42

-- Pattern matching to extract data from algebraic data types:
getCustomerId :: Customer -> CustomerId
getCustomerId (Customer cust_id _ _) = cust_id

-- _ alone is a wildcard: any underscore will match anything, but
-- will not save matching value, since name and luckyNumber aren't needed

-- * like `newtype` but with more arguments
-- ** data Customer = Customer CustomerId String Int
-- ** newtype CustomerId = CustomerId Int
-- * Tuples, but with names:
x :: (Double, Double, Double)
-- ** easier to reconcile it's intention:
data RGB = RGB Double Double Double
x :: RGB

-- More complex data type:
-- represents a tree, where each node is labeled by a string (tree hierarchy)
data StringTree = StringTree String [StringTree]

hierarchy = StringTree "C:"
  [ StringTree "Program Files" []
  , StringTree "Users"
    [StringTree "Alice" []]
  , StringTree "Cats" []
  ]

-- * Package some values together
-- * Named container

-- Algebraic Data Type Constructors
---------------------------------------
-- Reconstructing Haskells Bool data type:
-- `data` keyword
-- `Bool` name
-- two values: False, True
data Bool = False | True

x :: Bool
x = False
y :: Bool
y = true

-- negate the current value
negate :: Bool -> Bool
negate True = False
negate False = True

-- several constructors with no arguments
-- anything with a small, fixed number of values
-- `enums` type
data DialogResponse = Yes | No | Help | Quit

-- Represents an Int value that may, or may not be present
-- NoInt is no value, JustInt is just the int
-- no built in notion of null
-- explicitly specify whether a value is missing
data MaybeInt = NoInt | JustInt Int


-- Int representing a default value if no val is present inside MaybeInt
-- returns value in MaybeInt, unless it has no value
defaultInt :: Int -> MaybeInt -> Int
-- first definition has a pattern that matches when the maybeInt value was created using the NoInt constructor
-- doesn't contain any value, in this case, defaultValue is returned
defaultInt defaultValue NoInt = defaultValue
-- has a pattern that matches when the maybeInt was created using the JustInt was created with x as the parameter
-- x is the value to return
-- using _ as defaultValue because we don't care what it is
defaultInt _ (JustInt x) = x

-- first constructor has no arguments and represents a non empty list
data StringList = EmptyStringList
  -- second constructor has 2 arguments and represents a non empty list
    -- String representing head of the list
    -- StringList representing the tail of the list
    -- corresponds to `cons` operator
  | ConsStringList String StringList

-- Other than the constructor, these two functions are identical:
lengthStringList :: StringList -> Int
lengthStringList EmptyStringList = 0
lengthStringList (ConsStringList _ xs) = 1 + lengthStringList xs

length :: [a] -> Int
length [] = 0
length (_ : xs) = 1 + length xs

-- * Constructors - different kinds of values for a type

-- Parameterized Types
---------------------------------------

-- from the standard Library:
-- represents a value that may be missing
-- Maybe has a type variable `a` following the type name `Maybe`
-- indicates Maybe is not itself a type, but if you supply some type for a, you can produce a type
data Maybe a = Just a | Nothing

x :: Maybe Int
x = Nothing

fromMaybe :: a -> Maybe a -> a
fromMaybe defaultValue Nothing = defaultValue
fromMaybe _ (Just x) = x

-- Standard List type in Haskell Standard:
data List a = Empty | Cons a (List a)

-- * parameterized types - hold values of any type
