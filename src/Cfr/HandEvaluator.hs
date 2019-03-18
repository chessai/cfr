{-# language BangPatterns #-}
{-# language GeneralizedNewtypeDeriving #-}
{-# language DerivingStrategies #-}

module Cfr.HandEvaluator
  (
  ) where

import Cfr.Card
import qualified Cfr.LookupTables as Lookup
import qualified Cfr.PopCount as PopCount
import qualified Data.List as List
import qualified Data.Set as Set
import qualified Data.IntMap as IntMap
import Data.Monoid (Product(..))
import qualified Data.Maybe as Maybe

combinations :: Ord a => Int -> [a] -> [[a]]
combinations !n xs =
  [ x | x <- mapM (const xs) [1..n], List.head x < List.head (List.tail x) ]

evaluatePercentile2 :: [Card] -> Double
evaluatePercentile2 [Card r0 s0, Card r1 s1] = if s0 == s1
  then if fromEnum r0 < fromEnum r1
    then (Lookup.suited_ranks_to_percentile List.!! fromEnum r0) List.!! fromEnum r1
    else (Lookup.suited_ranks_to_percentile List.!! fromEnum r1) List.!! fromEnum r0
  else (Lookup.unsuited_ranks_to_percentile List.!! fromEnum r0) List.!! fromEnum r1
evaluatePercentile2 _ = 0

-- Cactus Kev
--
-- Bits marked x are not used.
-- xxxbbbbb bbbbbbbb cdhsrrrr xxpppppp
--
-- b is one bit flipped for A-2
-- c,d,h,s are flipped if you have a club,diamond,heart,spade
-- r is just the numerical rank is binary, with deuce=0
-- p is the prime from Lookup.primes corresponding to the rank, in binary

cardToBinaryFive :: Card -> Int
cardToBinaryFive (Card r s) =
  let b_mask = 1 `unsafeShiftL` (14 + fromEnum r)
      cdhs_mask = 1 `unsafeShiftL` (11 + fromEnum s)
      r_mask = (fromEnum r - 2) `unsafeShiftL` 8
      p_mask = Lookup.primes List.!! (fromEnum r - 2)
  in b_mask .&. r_mask .&. p_mask .&. cdhs_mask

cardToBinaryLookup :: Card -> Int
cardToBinaryLookup (Card r s) = (Lookup.card_to_binary_Five List.!! fromEnum r) List.!! fromEnum s

evaluateRank :: [Card] -> Double
evaluateRank hand =
  let binaryHand = List.map cardToBinaryLookup hand
      hasFlush = foldl (.&.) 0xF0000 binaryHand
      q = (foldl (.|.) 0 binaryHand) `unsafeShiftR` 16
  in if hasFlush == 1
       then Lookup.flushes List.!! q
       else let possibleRank = Lookup.unique5 List.!! q
            in if possibleRank /= 0
                 then fromIntegral possibleRank
                 else let q' = getProduct $ foldMap (Product . (.&. 0xFF)) binaryHand
                      in fromIntegral . Maybe.fromJust $ IntMap.lookup q' Lookup.pairs
                 

