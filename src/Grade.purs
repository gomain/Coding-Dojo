module Grade where

import Prelude

import Data.Foldable (find)
import Data.Maybe (maybe)
import Data.Newtype (class Newtype, un)
import Data.Tuple (fst, snd)
import Data.Tuple.Nested (type (/\), (/\))

newtype Grade = Grade String

instance showGrade :: Show Grade where
  show (Grade str) = str

type Mark = Int

newtype Rules = Rules (Array (Grade /\ Mark))

derive instance newtypeRules :: Newtype Rules _

grade :: Mark -> Grade
grade = grade' rules

rules :: Rules
rules = Rules
  [ (Grade "A" /\ 91)
  , (Grade "B" /\ 81)
  , (Grade "C" /\ 71)
  , (Grade "D" /\ 61)
  ]                  

grade' :: Rules -> Mark -> Grade
grade' rules' mark = maybe (Grade "F") fst <<< find ((_ <= mark) <<< snd) <<< un Rules $ rules'
  
  
  
  
  
  


