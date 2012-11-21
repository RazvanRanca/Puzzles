import Data.Char
import Data.List
import Data.Array
import System.IO
import Data.IntSet (toList, fromList)
import Bits (xor)
import Ratio


divList :: Integer -> [Integer]
divList x =[1]++ (help x 2 []) ++ [x]
            where
              help :: Integer -> Integer -> [Integer] -> [Integer]
              help x d ls 
                   | d^2>x = ls
                   | x`mod`d==0 && (x`div`d /= d) = help x (d+1) (ls ++ [d] ++ [x`div`d])
                   | x`mod`d==0 = help x (d+1) (ls ++ [d])
                   | otherwise = help x (d+1) ls

main = putStrLn(show(foldl'(+) 0 (elems ar72)))

ar72 = listArray (1,1000000) ([0] ++ [f72 x ar72 | x <- [2 .. 1000000]])

ar73 = listArray (1,1000000) [1 .. 1000000]

f72 :: Integer -> Array Integer Integer -> Integer
f72 n ar = (n-1) - sum(map(\x -> ar!x) (init(divList n)))
