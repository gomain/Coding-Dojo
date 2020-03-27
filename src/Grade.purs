module Grade where

import Prelude

import Data.Foldable (any)
import Data.Generic.Rep (class Generic)
import Data.Generic.Rep.Eq (genericEq)
import Data.Generic.Rep.Ord (genericCompare)
import Data.Generic.Rep.Show (genericShow)
import Data.Map (Map)
import Data.Map (fromFoldable, lookup) as M
import Data.Maybe (fromMaybe)
import Data.Newtype (class Newtype, un)
import Data.Tuple.Nested ((/\))

newtype Grade = Grade String

instance showGrade :: Show Grade where
  show (Grade str) = str

newtype Mark = Mark Int

derive instance newtypeMark :: Newtype Mark _

derive instance genericMark :: Generic Mark _

instance showMark :: Show Mark where
  show = genericShow

instance eqMark :: Eq Mark where
  eq = genericEq

instance ordMark :: Ord Mark where
  compare = genericCompare

newtype Range = Range { min :: Mark, max :: Mark }

derive instance newtypeRange :: Newtype Range _

derive instance genericRange :: Generic Range _

instance showRange :: Show Range where
  show = genericShow

instance eqRange :: Eq Range where
  eq r1 r2 | Range { min: min1 ,max: max1 } <- r1
           , Range { min: min2, max: max2 } <- r2 = any (between min1 max1) [ min2, max2 ]
                                                 || any (between min2 max2) [ min1, max1 ]
instance ordRange :: Ord Range where
  compare r1 r2 | r1 == r2 = EQ
                | Range { min: min1 } <- r1
                , Range { min: min2 } <- r2 = compare min1 min2 

newtype Rules = Rules (Map Range Grade)

derive instance newtypeRules :: Newtype Rules _

grade' :: Rules -> Mark -> Grade
grade' rules mark = fromMaybe (Grade "F") $ M.lookup (Range { min: mark, max: mark }) (un Rules rules)

grade :: Int -> Grade
grade i = grade' rules (Mark i) where
  rules = Rules <<< M.fromFoldable $
          [ Range { min: Mark 61, max: Mark 70 } /\ Grade "D"
          , Range { min: Mark 71, max: Mark 80 } /\ Grade "C"
          , Range { min: Mark 81, max: Mark 90 } /\ Grade "B"
          , Range { min: Mark 91, max: Mark 100} /\ Grade "A"
          ]
