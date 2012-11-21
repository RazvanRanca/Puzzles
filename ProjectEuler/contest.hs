import List

facList1 :: Integer -> [Integer] -> [Integer]
facList1 x ys = help x ys
            where
              help :: Integer -> [Integer] -> [Integer]
              help 1 _ = []
              help x [] = [x]
              help x (y:ys) 
                   | x `mod` y == 0 = y : help q ys
                   | y^2>x = [x]
                   | otherwise = help x ys
                                 where
                                   q = (gigel x y)
                                   
                                   gigel :: Integer -> Integer -> Integer
                                   gigel x y
                                         | x `mod` y /=0 = x
                                         | otherwise = gigel (x`div`y) y 

primeList :: [Integer] -> [Integer]
primeList (x:xs) 
          | xs==[] = [x]
          | x^2 > (last xs) = (x:xs)
          | otherwise = x : primeList (filter ((/=0).(`mod` x)) xs)

weight :: [Integer] -> Integer ->Integer
weight (x:[]) c = x^c
weight (x:xs) c = x^c + (weight xs (c+1) `mod` 1000000007)

pb1 :: Integer -> Integer -> Integer
pb1 lim c
	| c == lim = weight(facList1 c primes) 1
	| otherwise = weight(facList1 c primes) 1 + ((pb1 lim (c+1)) `mod` 1000000007)

primes :: [Integer]
primes = primeList[2 .. 10000]

perfectPowers :: Integer -> Integer ->Integer ->[Integer]
perfectPowers power c limit
	| c<limit =  ((c^power)*power `mod` 1000000007) : (perfectPowers power (c+1) limit)
	| otherwise =[(c^power)*power]
		

rest :: [Integer] -> Integer
rest xs = head(foldl1 intersect [(perfectPowers 37 1 10000),(perfectPowers 31 1 10000)])
