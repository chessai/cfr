module Prelude
  ( module P
  ) where

import Data.Int as P (Int,Int8,Int16,Int32,Int64)
import Data.Word as P (Word,Word8,Word16,Word32,Word64)
import Data.String as P (String)
import GHC.Show as P (Show(..))
import Data.Function as P (($),(.),id)
import GHC.IO as P (IO)
import Control.Applicative as P (Applicative(..))
import Control.Monad as P (Monad(..))
import Data.Functor as P (Functor(..))
import Data.Eq as P (Eq(..))
import Data.Ord as P (Ord(..))
import Data.Bool as P (Bool(..))
import GHC.Read as P (Read(..))
import Data.Maybe as P (Maybe(..),maybe)
import Data.Either as P (Either(..),either)
import Text.Read as P (readMaybe)