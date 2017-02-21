import Prelude hiding (elem)
-- Type Classes
---------------------------------------

-- Type Class Instances
---------------------------------------
-- Functions can't be tested with equality (==)

-- _ to be searched for, since we don't care what it is, use wildcard (_)
-- x (y:ys) - pattern match: first elem `y` and remaining els `ys`, `x` is our search
-- x == y - `x` is the first el, so true
-- otherwise - when x is not equal to y, then call elem recursively
-- Typeclass constraint `Eq`, `Int` or `String` automatically in `Eq` type class
elem :: Eq a => a -> [a] -> Bool
elem _ [] = False
elem x (y:ys)
  | x == y    = True
  | otherwise = elem x ys

-- creating a new type class `RGB`
-- create an instance of the Eq type class for the RGB type
-- `instance` - keyword
-- `Eq` - name of the type class we're defining an instance of
-- `RGB` - type we're defining the instance for
-- `where` keyword
-- definition of any function the Eq class would need to support (==),
  -- operators are just functions
  -- if all components are equal, it's a match
instance Eq RGB where
  (RGB r1 g1 b1) == (RGB r2 g2 b2) = (r1 == r2) && (g1 == g2) && (b1 == b2)

-- GHCi:
-- *Main> elem green colors
-- True

-- to display RGB as a string, we need the `show` class
-- implement any functions `show` class requires: `show` function
  -- (RGB r g b) - pattern matching to extract components
  -- string is concatenation of `RGB`, separated by spaces, `show [a]`
instance Show RGB where
  show (RGB r g b) = "RGB " ++ (show r) ++ " " ++ (show g) ++ " " ++ (show b)

-- GHCi:
-- *Main> show (RGB 255 0 255)
-- "RGB 255 0255"

data RGB = RGB Int Int Int

colors = [RGB 255 0 0, RGB 0 255 0, RGB 0 0 255]
green = RGB 0 255 0
greenInColors = elem green colors

-- parameterized is slightly different:
-- we need to constrain `a` to be an `Eq` type
-- (Eq a) => context of the type class instance
-- instance (Eq a) => Eq (Maybeʹ a) where
--   Nothingʹ == Nothingʹ = True
--   Nothingʹ == (Justʹ _) = False
--   (Justʹ _) == Nothingʹ = False
--   (Justʹ x) == (Justʹ y) x == y

-- data Maybeʹ a = Nothingʹ | Justʹ a


-- Derived Type Classes
---------------------------------------
-- writing out obvious instances become tedious
  -- `deriving` keyword then class `Eq`
  -- give `RGB` the obvious `Eq` operator
data Person = Person String Int Int
  deriving Eq
-- instance Eq Person where
--   (Person name1 age1 height1) ==
--     (Person name2 age2 height2) =
--       (name1 == name2) && (age1 == age2) && (height1 == height2)

-- Classes that can use `deriving`
-- Eq
  -- deriving - components wise equality
-- Ord
  -- <, >, <=, >=
  -- deriving - component-wise comparison
-- Show
  -- `show`
  -- deriving - `{Constructor-name} {arg1} {arg2} ...`
-- Read
  -- `read` parses string into value
  -- deriving - parse output of default show

-- No equality tests for functions, this will break:
-- data Foo = Foo (Int -> Int)
--   deriving Eq

-- Creating Type Classes
---------------------------------------

-- defining the `Eq` class:

-- class Eq a where
--   (==) :: a -> a -> Bool
--   (/=) :: a -> a -> Bool -- not equal operator
--
--   x /= y = not (x == y)
--   x == y = not (x /= y)

-- minimum complete definition: (==) or (/=)

data Point2 = Point2 Double Double
  deriving Show
data Point3 = Point3 Double Double Double
  deriving Show

distance2 :: Point2 -> Point2 -> Double
distance2 (Point2 x1 y1) (Point2 x2 y2) =
  sqrt (dx * dx + dy * dy)
  where dx = x1 - x2
        dy = y1 - y2

distance3 :: Point3 -> Point3 -> Double
distance3 (Point3 x1 y1 z1) (Point3 x2 y2 z2) =
  sqrt (dx * dx + dy * dy + dz * dz)
  where dx = x1 - x2
        dy = y1 - y2
        dz = z1 - z2

-- Create a new Type Class `Measurable`

class Measurable a where
  distance :: a -> a -> Double

instance Measurable Point2 where
  distance = distance2

instance Measurable Point3 where
  distance (Point3 x1 y1 z1) (Point3 x2 y2 z2) =
    sqrt (dx * dx + dy * dy + dz * dz)
    where dx = x1 - x2
          dy = y1 - y2
          dz = z1 - z2

instance Measurable Double where
  distance x y = abs (x - y)

-- Subclasses
---------------------------------------
-- Ord is a sublcass of the `Eq` class
  -- <, >, <=, >=
-- Eq is a superclass of Ord

-- Ord minimum completion definition: `compare` or (<=)

-- Sublcass Directions of `Measureable` class
class (Measurable a, Show a) => Directions a where
  getDirections :: a -> a -> String
  getDirections p1 p2 =
    "Go from " ++ (show p1) ++
    " towards " ++ (show p2) ++
    " and stop after " ++ (show (distance p1 p2))

instance Directions Point3 where
  getDirections p1 p2 =
    "Fly from " ++ (show p1) ++
    " towards " ++ (show p2) ++
    " and stop after " ++ (show (distance p1 p2))

-- nothing needed for this instance since using the default getDirections functions
instance Directions Point2 where
