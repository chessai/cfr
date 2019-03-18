{-# language BangPatterns #-}

module Cfr.PopCount
  ( popcount
  ) where

import Data.Primitive.PrimArray

zeroes :: PrimMonad m => Int -> m (MutablePrimArray (PrimState m) Int)
zeroes !sz = do
  marr <- newPrimArray sz
  setPrimArray marr 0 sz 0
  pure marr

_POPCOUNT_TABLE16 :: PrimArray Int
_POPCOUNT_TABLE16 = runST $ do
  let tableSize = 2 ^ (16 :: Int)
  marr <- zeroes tableSize
  let go !ix = if ix < tableSize
        then do
          let ix' = ix `unsafeShiftR` 1
          atIx' <- readPrimArray marr ix'
          let val = (ix .&. 1) + atIx'
          writePrimArray marr ix val
        else pure ()
  go 0
  unsafeFreezePrimArray marr          

-- http://www.valuedlessons.com/2009/01/popcount-in-python-with-benchmarks.html
popcount :: Int -> Int
popcount !v = indexPrimArray _POPCOUNT_TABLE16 (v .&. 0xffff)
  + indexPrimArray _POPCOUNT_TABLE16 ((v `unsafeShiftR` 16) .&. 0xffff)
