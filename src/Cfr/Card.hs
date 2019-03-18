{-# language DerivingStrategies #-}
{-# language LambdaCase #-}
{-# language ViewPatterns #-}

module Cfr.Card
  ( Card(..)
  , Rank(..)
  , Suit(..)
  , cardValue
  , rankValue
  , showRank
  , showSuit
  ) where

data Card = Card Rank Suit

data Rank
  = One
  | Two
  | Three
  | Four
  | Five
  | Six
  | Seven
  | Eight
  | Nine
  | Ten
  | Jack
  | Queen
  | King
  | Ace
  deriving stock (Eq,Show,Read)

data Suit
  = Spades
  | Hearts
  | Diamonds
  | Clubs
  deriving stock (Eq,Show,Read)

rankValue :: Rank -> Int
rankValue = \case
  One -> 1
  Two -> 2
  Three -> 3
  Four -> 4
  Five -> 5
  Six -> 6
  Seven -> 7
  Eight -> 8
  Nine -> 9
  Ten -> 10
  Jack -> 11
  Queen -> 12
  King -> 13
  Ace -> 14

cardValue :: Card -> Int
cardValue (Card r _) = rankValue r

showRank :: Rank -> String
showRank = show . rankValue
  
showSuit :: Suit -> String
showSuit = \case
  Spades -> "s"
  Hearts -> "h"
  Diamonds -> "d"
  Clubs -> "c"

{-
stringToSuit :: String -> Maybe Suit
stringToSuit s@(readMaybe -> ms) = case ms of
  Nothing -> case s of
    "s" -> Just Spades
    "h" -> Just Hearts
    "d" -> Just Diamonds
    "c" -> Just Clubs
    _   -> Nothing
  x -> x
-}
