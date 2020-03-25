module Grade where

import Prelude

import Data.Foldable (find)
import Data.Maybe (maybe)
import Data.Tuple (fst, snd)
import Data.Tuple.Nested ((/\))

newtype Grade = Grade String

instance showGrade :: Show Grade where
  show (Grade str) = str

type Mark = Int

grade :: Mark -> Grade
grade mark = maybe (Grade "F") fst <<< find ((_ <= mark) <<< snd) $ rules where
  rules =
    [ (Grade "A" /\ 91)
    , (Grade "B" /\ 81)
    , (Grade "C" /\ 71)
    , (Grade "D" /\ 61)
    ]
