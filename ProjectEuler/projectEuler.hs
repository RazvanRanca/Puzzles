import Data.Char
import Data.List
import Data.Array
import System.IO
import Data.IntSet (toList, fromList)
import Bits (xor)
import Ratio

preFac 0 = 1
preFac 1 = 1
preFac 2 = 2
preFac 3 = 6
preFac 4 = 24
preFac 5 = 120
preFac 6 = 720
preFac 7 = 5040
preFac 8 = 40320
preFac 9 = 362880


numPerm :: [Integer] -> Integer
numPerm xs = facI(lenn xs) `div` (product(map (facI) (helpPerm xs 1)))
            where
              helpPerm [] c = [c]
              helpPerm (x:[]) c = [c]
              helpPerm (x:y:zs) c
                       | x == y = helpPerm (y:zs) (c+1)
                       | otherwise = c : (helpPerm (y:zs) 1)

qsort1 :: Ord a => [a] -> [a]
qsort1 [] = []
qsort1 (a:bs) = qsort1[x | x<-bs, x>=a] ++ [a] ++ qsort1[x | x<-bs, x<a]

pow :: Integer -> Integer -> Integer
pow a x = helpPow 1 a x
            where
              helpPow :: Integer -> Integer -> Integer -> Integer
              helpPow s a 1 = a*s
              helpPow s a x
                      | x`mod`2==0 = helpPow s (a*a) (x`div`2)
                      | otherwise = helpPow (s*a) (a*a) ((x-1)`div`2)

nub' = toList.fromList

isSquare :: Integer -> Bool
isSquare x = (truncate (sqrt(fromIntegral x)))^2 == x

base2 :: Int -> [Int]
base2 0 = [0]
base2 1 = [1]
base2 x = x `mod` 2 : base2 (x`div`2) 

-- turns 31415 in [5,1,4,1,3] only for positive values
unravel :: Integer -> [Integer]
unravel x
        | x<10 = [x]
        | otherwise = x`mod`10 : unravel (x`div`10) 

-- innitiate w/ 0
ravel :: Integer -> [Integer] -> Integer
ravel c [] = c
ravel c (x:xs) = ravel (c*10+x) xs


primeList :: [Integer] -> [Integer]
primeList (x:xs) 
          | xs==[] = [x]
          | x^2 > (last xs) = (x:xs)
          | otherwise = x : primeList (filter ((/=0).(`mod` x)) xs)   

primes :: [Integer]
primes = 2 : primeHelp [3,5 ..]

primeHelp :: [Integer] -> [Integer]
primeHelp (x:xs) =   x : primeHelp (filter ((/=0).(`mod` x)) xs) 

lenn ::Ord a => [a] -> Integer
lenn [] = 0
lenn (x:xs) = 1 + lenn xs

summ :: [Integer] -> Integer
summ [] = 0
summ (x:xs) = x + summ xs

facList :: Integer -> [(Integer,Integer)]
facList x = help x ( primeList [2 .. x])
            where
              help :: Integer -> [Integer] -> [(Integer,Integer)]
              help 1 _ = []
             
              help x (y:ys) 
                   | x `mod` y == 0 = (y, nr) : help new ys
                   | otherwise = help x ys
                                 where
                                   q = (gigel x y 0)
                                   nr = fst q
                                   new = snd q
                                   gigel :: Integer -> Integer -> Integer -> (Integer,Integer)
                                   gigel x y z
                                         | x `mod` y /=0 = (z , x)
                                         | otherwise = gigel (x`div`y) y (z+1)
-- number to factorize, primes till number
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


divList :: Integer -> [Integer]
divList x =[1]++ (help x 2 []) ++ [x]
            where
              help :: Integer -> Integer -> [Integer] -> [Integer]
              help x d ls 
                   | d^2>x = ls
                   | x`mod`d==0 && (x`div`d /= d) = help x (d+1) (ls ++ [d] ++ [x`div`d])
                   | x`mod`d==0 = help x (d+1) (ls ++ [d])
                   | otherwise = help x (d+1) ls

divListInt :: Int -> [Int]
divListInt x =[1]++ (help x 2 []) ++ [x]
            where
              help :: Int -> Int -> [Int] -> [Int]
              help x d ls 
                   | d^2>x = ls
                   | x`mod`d==0 && (x`div`d /= d) = help x (d+1) (ls ++ [d] ++ [x`div`d])
                   | x`mod`d==0 = help x (d+1) (ls ++ [d] ++ [x`div`d])
                   | otherwise = help x (d+1) ls

fac :: Int -> Int
fac 0 = 1
fac x = x*fac(x-1)

facI :: Integer -> Integer
facI 0 = 1
facI x = x*facI(x-1)

fact :: Double -> Double
fact 0 = 1
fact x = x*fact (x-1)


replace :: Eq a => [a] -> [a] -> [a] -> [a]
replace [] _ _ = []
replace orig [] _ = orig
replace (o:orig) find rep
        | take (len) (o:orig) == find = rep ++ replace (drop len (o:orig)) find rep
        | otherwise = [o] ++  replace orig find rep 
                   where
                     len = length find

isPrimeE :: Integer -> Bool
isPrimeE x = (x>2 && x`mod`2==1 && isPrime x 3) || x == 2


-- a is between 1 and 9
isPanDig :: Integer -> Integer -> Bool
isPanDig a x = sort (show x) == sort (show (ravel 0 [1 .. a]))

-- second parameter = 3
isPrime :: Integer -> Integer -> Bool
isPrime x d 
       | (d*d)> x = True
       | x `mod` d == 0 = False
       | otherwise = isPrime x (d+2)          
pb1 :: Integer
pb1 = sum([x | x<- [1 .. 999], (x `mod` 3 == 0 || x `mod` 5 == 0)])

pb2 :: Integer
pb2 = pb2Help 1 2 4000000
      where
        pb2Help :: Integer -> Integer -> Integer -> Integer
        pb2Help y x m
                | x>m = 0
                | otherwise = x + pb2Help (2*x + y) (3*x + 2*y) m

pb6 :: Integer
pb6 = sum([1 .. 100])*sum([1 .. 100]) - sum([x*x | x<- [1 .. 100]])

pb5 :: Integer
pb5 = pb5Help 2 20 1
      where
        pb5Help :: Integer -> Integer -> Integer -> Integer
        pb5Help x m r
                | x<=m = pb5Help (x+1) m (r* x `div` gcd x r)
                | otherwise = r

pb3 :: Integer
pb3 = pb3Help 2 600851475143
      where
        pb3Help :: Integer -> Integer -> Integer
        pb3Help x m
                | x > m `div` 2 = m
                | m `mod` x == 0 = pb3Help x (m`div`x)
                | otherwise = pb3Help (x+1) m

pb4 :: Integer
pb4 = pb4Help 999 999
      where
        isPal :: Integer -> Integer -> Integer
        isPal x y
              | x == 0 = y
              | otherwise = isPal (x `div` 10) (y*10 + x`mod` 10)

        isProd :: Integer -> Integer -> Bool
        isProd n x
               | n `div` x > x = False
               | n `mod` x == 0 = True
               | otherwise = isProd n (x-1)

        pb4Help :: Integer -> Integer -> Integer
        pb4Help p z
                | isProd (isPal p p) z = isPal p p
                | otherwise = pb4Help (p-1) z
               
pb7 :: Integer
pb7 = pb7Help 3 10001 1
      where
        isPrime :: Integer -> Integer -> Bool
        isPrime x d 
                | (d*d)> x = True
                | x `mod` d == 0 = False
                | otherwise = isPrime x (d+2)
        
        pb7Help :: Integer -> Integer -> Integer -> Integer
        pb7Help x m c
                | isPrime x 3 == False = pb7Help (x+2) m c
                | isPrime x 3 && c<m-1 = pb7Help (x+2) m (c+1)
                | otherwise = x

pb7' :: Integer
pb7' = pmeList [2..] !! 10001

pmeList (x:xs) = x : pmeList(filter ((/=0).(`mod` x)) xs)

big = 7316717653133062491922511967442657474235534919493496983520312774506326239578318016984801869478851843858615607891129494954595017379583319528532088055111254069874715852386305071569329096329522744304355766896648950445244523161731856403098711121722383113622298934233803081353362766142828064444866452387493035890729629049156044077239071381051585930796086670172427121883998797908792274921901699720888093776657273330010533678812202354218097512545405947522435258490771167055601360483958644670632441572215539753697817977846174064955149290862569321978468622482839722413756570560574902614079729686524145351004748216637048440319989000889524345065854122758866688116427171479924442928230863465674813919123162824586178664583591245665294765456828489128831426076900422421902267105562632111110937054421750694165896040807198403850962455444362981230987879927244284909188845801561660979191338754992005240636899125607176060588611646710940507754100225698315520005593572972571636269561882670428252483600823257530420752963450

pb8 :: Integer
pb8 = pb8Help (big `div` 10) (reverse(lastFive big 0))
      where
        lastFive :: Integer -> Integer -> [Integer]
        lastFive b c
                 | c == 5 = []
                 | otherwise = b `mod` 10 : lastFive (b `div` 10) (c+1)

        pb8Help :: Integer -> [Integer] -> Integer
        pb8Help b ls
                | b == 0 = product ls
                | product ls >product(lastFive b 0) = pb8Help (b`div`10) ls
                | otherwise = pb8Help (b `div` 10) (lastFive b 0)

pb9 :: Integer
pb9 = pb9Help 2 499 499 1000
      where
        isPit :: Integer -> Integer -> Integer -> Bool
        isPit a b c = a*a + b*b == c*c

        pb9Help :: Integer -> Integer -> Integer -> Integer -> Integer
        pb9Help a b c z 
                | isPit a b c = a*b*c
                | c > b + 2 = pb9Help a (b+1) (c-1) z
                | otherwise = pb9Help (a+1) (z `div` 2 - a) (z `div` 2 - 1) z

-- Works now - 23s
pb10 :: Integer
pb10 = 2 + primeSum [3,5 .. 1999999]
       where
         primeSum :: [Integer] -> Integer
         primeSum [] = 0
         primeSum (x:xs)  
                  | x*x > last xs = sum(x:xs)
                  | otherwise = x + primeSum (filter ((/=0).(`mod`x)) xs) 

-- Grr 1:20 instead of 1:00
pb10' :: Integer
pb10' = sum ( primeList )
        where
          primeList :: [Integer]
          primeList = 2 : (filter isPrime [3,5 .. 1999999])
          
          isPrime :: Integer -> Bool
          isPrime x = isPrimeHelp x (primeList)

          isPrimeHelp :: Integer -> [Integer] -> Bool
          isPrimeHelp x (y:ys)
                      | y*y>x = True
                      | x `mod` y == 0 = False
                      | otherwise = isPrimeHelp x ys

-- Way too Slow .. Again
pb10'' :: Integer
pb10'' = 2 + sum( magic [] [3,5 .. 199999])
         where 
           magic :: [Integer] -> [Integer] -> [Integer]
           magic x [] = x
           magic ps (s:ss) = magic (s:ps)(filter ((/=0).(`mod` s)) ss)

pb16 :: Integer
pb16 = sum ([ (num `mod` (10^s))`div`(10^(s-1)) |s<-[1 ..(len num)]])
       where 
         num = fexp 1 2 1000
         len :: Integer -> Integer
         len 0 = 0
         len x = 1 + len (x`div`10)

fexp :: Integer -> Integer -> Integer -> Integer
fexp a b c
     | c == 0 = a
     | c `mod` 2 == 0 = fexp a (b*b) (c`div`2)
     | otherwise = fexp (a*b) b (c-1)

pb20 :: Int
pb20 = sum (map (digitToInt) (show(product[1..100])))

pb13 :: Integer
pb13 = foldr (+) (0::Integer) (splitEach50 big13)
       

splitEach50 :: Integer -> [Integer]
splitEach50 x 
            | x/=0 = x`mod`(10^50) : splitEach50 (x`div`(10^50))
            | otherwise = []


big13 :: Integer
big13 = 37107287533902102798797998220837590246510135740250463769376774900097126481248969700780504170182605387432498619952474105947423330951305812372661730962991942213363574161572522430563301811072406154908250230675882075393461711719803104210475137780632466768926167069662363382013637841838368417873436172675728112879812849979408065481931592621691275889832738442742289174325203219235894228767964876702721893184745144573600130643909116721685684458871160315327670386486105843025439939619828917593665686757934951621764571418565606295021572231965867550793241933316490635246274190492910143244581382266334794475817892575867718337217661963751590579239728245598838407582035653253593990084026335689488301894586282278288018119938482628201427819413994056758715117009439035398664372827112653829987240784473053190104293586865155060062958648615320752733719591914205172558297169388870771546649911559348760353292171497005693854370070576826684624621495650076471787294438377604532826541087568284431911906346940378552177792951453612327252500029607107508256381565671088525835072145876576172410976447339110607218265236877223636045174237069058518606604482076212098132878607339694128114266041808683061932846081119106155694051268969251934325451728388641918047049293215058642563049483624672216484350762017279180399446930047329563406911573244438690812579451408905770622942919710792820955037687525678773091862540744969844508330393682126183363848253301546861961243487676812975343759465158038628759287849020152168555482871720121925776695478182833757993103614740356856449095527097864797581167263201004368978425535399209318374414978068609844840309812907779179908821879532736447567559084803087086987551392711854517078544161852424320693150332599594068957565367821070749269665376763262354472106979395067965269474259770973916669376304263398708541052684708299085211399427365734116182760315001271653786073615010808570091499395125570281987460043753582903531743471732693212357815498262974255273730794953759765105305946966067683156574377167401875275889028025717332296191766687138199318110487701902712526768027607800301367868099252546340106163286652636270218540497705585629946580636237993140746255962240744869082311749777923654662572469233228109171419143028819710328859780666976089293863828502533340334413065578016127815921815005561868836468420090470230530811728164304876237919698424872550366387845831148769693215490281042402013833512446218144177347063783299490636259666498587618221225225512486764533677201869716985443124195724099139590089523100588229554825530026352078153229679624948164195386821877476085327132285723110424803456124867697064507995236377742425354112916842768655389262050249103265729672370191327572567528565324825826546309220705859652229798860272258331913126375147341994889534765745501184957014548792889848568277260777137214037988797153829820378303147352772158034814451349137322665138134829543829199918180278916522431027392251122869539409579530664052326325380441000596549391598795936352974615218550237130764225512118369380358038858490341698116222072977186158236678424689157993532961922624679571944012690438771072750481023908955235974572318970677254791506150550495392297953090112996751986188088225875314529584099251203829009407770775672113067397083047244838165338735023408456470580773088295917476714036319800818712901187549131054712658197623331044818386269515456334926366572897563400500428462801835170705278318394258821455212272512503275512160354698120058176216521282765275169129689778932238195734329339946437501907836945765883352399886755061649651847751807381688378610915273579297013376217784275219262340194239963916804498399317331273132924185707147349566916674687634660915035914677504995186714302352196288948901024233251169136196266227326746080059154747183079839286853520694694454072476841822524674417161514036427982273348055556214818971426179103425986472045168939894221798260880768528778364618279934631376775430780936333301898264209010848802521674670883215120185883543223812876952786713296124747824645386369930090493103636197638780396218407357239979422340623539380833965132740801111666627891981488087797941876876144230030984490851411606618262936828367647447792391803351109890697907148578694408955299065364044742557608365997664579509666024396409905389607120198219976047599490197230297649139826800329731560371200413779037855660850892521673093931987275027546890690370753941304265231501194809377245048795150954100921645863754710598436791786391670211874924319957006419179697775990283006991536871371193661495281130587638027841075444973307840789923115535562561142322423255033685442488917353448899115014406480203690680639606723221932041495354150312888033953605329934036800697771065056663195481234880673210146739058568557934581403627822703280826165707739483275922328459417065250945123252306082291880205877731971983945018088807242966198081119777158542502016545090413245809786882778948721859617721078384350691861554356628840622574736922845095162084960398013400172393067166682355524525280460972253503534226472524250874054075591789781264330331690

big11 :: [String]

big11 = ["08 02 22 97 38 15 00 40 00 75 04 05 07 78 52 12 50 77 91 08",
 "49 49 99 40 17 81 18 57 60 87 17 40 98 43 69 48 04 56 62 00",
 "81 49 31 73 55 79 14 29 93 71 40 67 53 88 30 03 49 13 36 65",
 "52 70 95 23 04 60 11 42 69 24 68 56 01 32 56 71 37 02 36 91",
 "22 31 16 71 51 67 63 89 41 92 36 54 22 40 40 28 66 33 13 80",
 "24 47 32 60 99 03 45 02 44 75 33 53 78 36 84 20 35 17 12 50",
 "32 98 81 28 64 23 67 10 26 38 40 67 59 54 70 66 18 38 64 70",
 "67 26 20 68 02 62 12 20 95 63 94 39 63 08 40 91 66 49 94 21",
 "24 55 58 05 66 73 99 26 97 17 78 78 96 83 14 88 34 89 63 72",
 "21 36 23 09 75 00 76 44 20 45 35 14 00 61 33 97 34 31 33 95",
 "78 17 53 28 22 75 31 67 15 94 03 80 04 62 16 14 09 53 56 92",
 "16 39 05 42 96 35 31 47 55 58 88 24 00 17 54 24 36 29 85 57",
 "86 56 00 48 35 71 89 07 05 44 44 37 44 60 21 58 51 54 17 58",
 "19 80 81 68 05 94 47 69 28 73 92 13 86 52 17 77 04 89 55 40",
 "04 52 08 83 97 35 99 16 07 97 57 32 16 26 26 79 33 27 98 66",
 "88 36 68 87 57 62 20 72 03 46 33 67 46 55 12 32 63 93 53 69",
 "04 42 16 73 38 25 39 11 24 94 72 18 08 46 29 32 40 62 76 36",
 "20 69 36 41 72 30 23 88 34 62 99 69 82 67 59 85 74 04 36 16",
 "20 73 35 29 78 31 90 01 74 31 49 71 48 86 81 16 23 57 05 54",
 "01 70 54 71 83 51 54 69 16 92 33 48 61 43 52 01 89 19 67 48"]

pb11 :: Int
pb11 = max4 (pb11Hor(trans11 big11)) (pb11Ver(trans11 big11)) (pb11Dg1(trans11 big11)) (pb11Dg2(trans11 big11))
       where
         max4 :: Int -> Int -> Int -> Int -> Int
         max4 a b c d = max (max a b)(max c d)

trans11 :: [String] -> [[Int]]
trans11 [] = []
trans11 xs = [[y | y<-transHelp z]| z<-xs]
             where 
               transHelp :: String -> [Int]
               transHelp [] = []
               transHelp xs = helpHelp((map digitToInt (take 2 xs))):  transHelp (drop 3 xs)

               helpHelp :: [Int] -> Int
               helpHelp (x:y:z) = x*10 + y

pb11Hor :: [[Int]] -> Int
pb11Hor xs = foldr max 0 [foldr max 0([(x!!a)*(x!!(a+1))*(x!!(a+2))*(x!!(a+3))|a<-[0 .. 16]])| x<- xs]

pb11Ver :: [[Int]] -> Int
pb11Ver xs = foldr max 0 [foldr max 0 ([((xs!!a)!!y)*((xs!!(a+1))!!y)*((xs!!(a+2))!!y)*((xs!!(a+3))!!y)| a<- [0 .. 16]])| y<- [0 .. 19]]

pb11Dg1 :: [[Int]] -> Int
pb11Dg1 xs = foldr max 0[foldr max 0([((xs!!a)!!y)*((xs!!(a+1))!!(y+1))*((xs!!(a+2))!!(y+2))*((xs!!(a+3))!!(y+3))| a<- [0 .. 16]])|y<-[0 .. 16]]

pb11Dg2 :: [[Int]] -> Int
pb11Dg2 xs = foldr max 0[foldr max 0([((xs!!a)!!y)*((xs!!(a+1))!!(y-1))*((xs!!(a+2))!!(y-2))*((xs!!(a+3))!!(y-3))| a<- [0 .. 16]])|y<-[19,18 .. 3]]


----------------------------------------------------------------------------------------------------------------------------------
pb14 = ind
       where ind = fst (foldl' (mmax) (0,0) (assocs a14))

a14 = listArray (1,1000000) ( [0] ++ [(aFun a14 x x) | x<- [2 .. 1000000]])

aFun ::  Array Integer Integer -> Integer -> Integer -> Integer
aFun a x min
     | x< min = a!x
     | x`mod`2==0 = 1 + aFun a (x`div`2) min
     | otherwise = 1 + aFun a (3*x +1) min

mmax :: (Integer,Integer) -> (Integer,Integer) -> (Integer,Integer)
mmax (a,b) (c,d)
     | b>=d = (a,b)
     | otherwise = (c,d)
                  


---------------------------------------------------------------------------------------------------

pb12 :: Integer
pb12 = cal12 500 6 4

alfa = take 1500 (pmeList [2..]) 

cal12 :: Integer ->Integer -> Integer -> Integer
cal12 m cr ad
      | nDiv12 cr (alfa) 1 >m = cr
      | otherwise = cal12 m (cr+ad) (ad+1)

nrdiv12 :: Integer -> Integer -> Integer -> Integer
nrdiv12 x d c
        | d> x`div`2 = c
        | x`mod`d==0 = nrdiv12 x (d+1) (c+1)
        | otherwise = nrdiv12 x (d+1) c

-- s must be intialized with 1
nDiv12 :: Integer -> [Integer] -> Integer -> Integer
nDiv12 x (p:ps) s
       | p > x = s
       | x`mod`p/=0 = nDiv12 x ps s
       | otherwise = nDiv12 (x `div`(p^(nP x p 0))) ps (s+(s*(nP x p 0)))

nP :: Integer -> Integer ->Integer -> Integer
nP x p c
  | x`mod`p/=0 = c
  | otherwise = nP (x`div`p) p (c+1)               

----------------------------------------------------------

pb25 :: Integer -> Integer -> Integer -> Integer
pb25 f1 f2 t
     | length(show f2)==1000 = t
     | otherwise = pb25 f2 (f1+f2) (t+1)

--------------------------------------------------------

-- Inffered target = Real target + 1
pb15 :: Integer
pb15 = smartRoutes [] [1] 1 21 

-- extremely slow
routes :: Integer -> Integer -> Integer
routes x y
       | x==1 = y+1
       | y==1 = x+1
       | otherwise = routes (x-1) y + routes x (y-1)

--- Better, still way too slow
botRoutes :: Integer -> Integer -> Integer -> Integer -> Integer -> Integer
botRoutes x y n1 n2 g
          | x==g && y==g = n1
          | x==y = botRoutes (x+1) y (n1 + n2) n2 g
          | otherwise = botRoutes x (y+1) (2*n1) (n1 + n2 + routes (x+1) (x-3)) g

--- Bingo - instantly
smartRoutes :: [Integer]-> [Integer] ->Integer -> Integer -> Integer
smartRoutes xs ys n g
            | n == g = last ys
            | otherwise = smartRoutes ys ((smartList ys 0) ++ [2*(summ ys)]) (n+1) g

smartList :: [Integer] -> Integer -> [Integer]
smartList [] _ = []
smartList (y:ys) z = (y+z):smartList ys (y+z)  

------------------------------------------------------------

pb48 :: Integer
pb48 = sumLastPow 1 1000 10 0

sumLastPow :: Integer -> Integer -> Int-> Integer -> Integer
sumLastPow x mx lst s 
    | x<=mx = sumLastPow (x+1) mx lst (s`mod`(10^lst)+((x^x) `mod`(10^lst)))
    | otherwise = s `mod`(10^lst)      

------------------------------------------------------------


pb21 :: Integer
pb21 = summ(amicPair 1 9999)

amicPair :: Integer -> Integer -> [Integer]
amicPair x mx
         | x>mx = []
         | dv <=x = amicPair (x+1) mx
         | x == (summ(divList dv)-dv) = x : dv : amicPair (x+1) mx
         | otherwise = amicPair (x+1) mx
         where
           dv = (summ(divList x) - x)
           

------------------------------------------------------------

type EngNum = (Int,Int)
dat :: [EngNum]
dat = [(1,3),(2,3),(3,5),(4,4),(5,4),(6,3),(7,5),(8,5),(9,4),(10,3),(11,6),(12,6),(13,8),(14,8),(15,7),(16,7),(17,9),(18,8),(19,8),(20,6),(30,6),(40,5),(50,5),(60,5),(70,7),(80,6),(90,6)]

pb17 :: Int
pb17 = sumEng dat 1 999 0 +11 

sumEng :: [EngNum] -> Int -> Int -> Int -> Int
sumEng xs a mx s
       | a>mx = s
       | a<21 || (a<100 && a`mod`10==0) = sumEng xs (a+1) mx (s+ head([y|(t,y)<-xs,t==a]))
       | a<100 = sumEng xs (a+1) mx (s+ sum[y|(t,y)<-xs,t==(a`mod`10)] + sum[y|(t,y)<-xs, t==(a`div`10 *10)])
       | a`mod`100==0 = sumEng xs (a+1) mx (s+ sum[y|(t,y)<-xs,t==(a`div`100)]+7)
       | a<1000 && (a`mod`100>19)= sumEng xs (a+1) mx (s+ sum[y|(t,y)<-xs,t==(a`div`100)]+sum[y|(t,y)<-xs,t==(a`mod`10)]+sum[y|(t,y)<-xs,t==((a`div`10 *10)`mod`100)]+ 10)
       | a<1000 && (a`mod`100>9) = sumEng xs (a+1) mx (s+  sum[y|(t,y)<-xs,t==(a`div`100)]+sum[y|(t,y)<-xs,t==(a`mod`100)] + 10)
       | otherwise = sumEng xs (a+1) mx (s+  sum[y|(t,y)<-xs,t==(a`div`100)]+sum[y|(t,y)<-xs, t==(a`mod`10)]+10)


-------------------------------------------------------------

pb19 :: Int
pb19 = sunMon 2 1 1 1901 31 12 2000

sunMon :: Int -> Int -> Int -> Int ->Int -> Int -> Int -> Int
sunMon dm di mi yi df mf yf
       | yi==yf && mi==mf && di==df = 0
       | dm>7 = sunMon 1 di mi yi df mf yf
       | mi>12 = sunMon dm di 1 (yi+1) df mf yf
       | dm == 7 && di==1 = 1 + sunMon 1 2 mi yi df mf yf
       | di<28 = sunMon (dm+1)(di+1) mi yi df mf yf
       | di<31 && (mi/=2) = sunMon (dm+1) (di+1) mi yi df mf yf
       | di==28 && mi==2 && (not (leap yi)) = sunMon (dm+1) 1 (mi+1) yi df mf yf
       | di==29 && mi==2 && (leap yi) = sunMon (dm+1) 1 (mi+1) yi df mf yf
       | di==30 && (mi==4 || mi==6 || mi==9 || mi==11) = sunMon (dm+1) 1 (mi+1) yi df mf yf
       | di==30 = sunMon (dm+1) (di+1) mi yi df mf yf
       | otherwise = sunMon (dm+1) 1 (mi+1) yi df mf yf
                     where
                       leap :: Int -> Bool
                       leap x 
                            | x`mod`4==0 && x`mod`100/=0 = True
                            | x`mod`4==0 && x`mod`100==0 && x`mod`400 ==0 = True
                            | otherwise = False

------------------------------------------------------------------

pb28 :: Integer
pb28 = summ(dgSpiral 501 1 2 0 1) 

dgSpiral :: Integer -> Integer -> Integer -> Integer ->  Integer -> [Integer]
dgSpiral sz cr ic nr csz
         | csz == sz = []
         | nr <4 = cr : dgSpiral sz (cr+ic) ic (nr+1) csz
         | otherwise = cr : dgSpiral sz (cr + ic + 2) (ic+2) 1 (csz+1)

---------------------------------------------------------------------

pb30 :: Int
pb30 = sumPow 5 2 300000

sumPow :: Int -> Int -> Int -> Int
sumPow p x m
       | x>m = 0
       | x == sum[y^p | y<-[((x`mod`(10^t))`div`(10^(t-1)))| t<-[1 .. length (show x)]]] = x + sumPow p (x+1) m
       | otherwise = sumPow p (x+1) m


--------------------------------------------------------------------------

pb24 :: [Int]
pb24 = nrPerm [0,1..9] 999999

nrPerm :: [Int] -> Int -> [Int]
nrPerm xs z
       | z==0 = xs
       | alfa<= z = nrPerm (swp xs (z`div`alfa)) (z-((z`div`alfa)*alfa))
       | otherwise = head(xs):nrPerm (tail(xs)) z
                     where
                       swp :: [Int] -> Int -> [Int]
                       swp xs y = xs !! y : (filter (/=(xs!!y)) xs)
                       alfa = fac(length xs -1)


---------------------------------------------------------------------------

pb29 :: Int
pb29 = length (nub([a^b|a<-[2 .. 100],b<-[2 .. 100]]))

---------------------------------------------------------------------------


pb34 :: Int
pb34 = sum [x | x<-[3 .. 2500000], (x== sum(map (\y -> preFac (digitToInt y)) (show x)))] 

------------------------------------------------------------------------------

rFile :: String
rFile = "pb18.txt"

pb18 :: IO()
pb18 = do
          s <- readFile rFile
          putStrLn (show (compute (map (\ss ->(read ("[" ++ replace ss " " "," ++ "]") :: [Int]) )(lines s)) (length(lines s)-1 ) ))

compute :: [[Int]] -> Int -> Int
compute xs c
        | c==0 = head (head xs)
        | otherwise = compute (take (c-1) xs ++ [(zipWith (+) (xs!!(c-1)) [max (line!!a) (line!!(a+1)) | a<-[0 .. (length line -2)]])]) (c-1)
                      where
                        line = xs!!c

------------------------------------------------------------------------------------

pb22 :: IO ()
pb22 = do
           s <- readFile "pb22.txt"
           putStrLn (show ( comp22 (sort (read ("[" ++ s ++ "]") :: [String])) 1 ))

comp22 :: [String] -> Integer -> Integer
comp22 [] _ = 0
comp22 (x:xs) n = (val x) * n + comp22 xs (n+1) 

val :: String -> Integer
val [] = 0
val (x:xs) = toInteger (fromEnum(toLower x) - fromEnum 'a' +1 ) + val xs

--------------------------------------------------------------------------------------


pb36 :: Int
pb36 = sum36 1000000

sum36 :: Int -> Int
sum36 0 = 0
sum36 x 
      | x`mod`10 /=0 && (unravel (toInteger x) == reverse (unravel (toInteger x))) && (base2 x == reverse (base2 x)) = x+sum36 (x-1)
      | otherwise = sum36 (x-1)                                                                                        
        
------------------------------------------------------------------------------------------

pb35 :: Int
pb35 = 2 + length (comp35 (primeList [2 .. 100]))

comp35 :: [Integer] -> [Integer]
comp35 [] = []
comp35 (x:xs) 
       | analyze35 x = x : comp35 xs
       | otherwise = comp35 xs

analyze35 :: Integer -> Bool
analyze35 x
          | or (map (\y -> elem y nr) [2,4,5,6,8,0]) = False
          | otherwise = and (map ( `isPrime` 3) (circ (rotate x) x))
                       where
                         nr = unravel (fromInteger x)

circ :: Integer -> Integer -> [Integer]
circ x xinit
     | x<10 = []
     | x == xinit = [x]
     | otherwise = x : circ rot xinit 
                   where
                     rot = rotate x

rotate :: Integer -> Integer
rotate x = x`mod`10 * (10 ^ len x) + x `div` 10
           where
             len :: Integer -> Integer
             len 0 = -1
             len x = 1 + len (x`div`10)

------------------------------------------------------------------------

pb97 :: Integer
pb97 = (28433* 2^7830457)`mod` (10^10) +1

-------------------------------------------------------------------------

isAbun :: Int -> Bool
isAbun x = sum (nub' (divListInt x)) > 2*x
         
         
n23 = 20163
pb23 = sum [1 .. n23] - sum (nub'[x+y | x <- list, y <- list,y>=x, x+y<=n23])
        where
          list = lst23 n23 1
       
lst23 :: Int -> Int -> [Int]
lst23 max c
      | c>max = []
      | isAbun c = c : lst23 max (c+1)
      | otherwise = lst23 max (c+1)

-----------------------------------------------------------------------------------------

pb40 :: Integer
pb40 = grr 1 * grr 10 * grr 100 * grr 1000 * grr 10000 * grr 100000 * grr 1000000

grr :: Integer -> Integer
grr x = getNum40 (x-1) 1 0 9

getNum40 :: Integer -> Integer -> Integer -> Integer -> Integer
getNum40 x b s sum
         | x <= sum = digit40 x b (10^s)
         | otherwise = getNum40 (x-((10^b-10^s)*b)) (b+1) (s+1) ((10^(b+1) - 10 ^ (s+1))*(b+1))

digit40 :: Integer -> Integer -> Integer -> Integer
digit40 s bexp c
        | skip > 0 = digit40 (s `mod` bexp) bexp (c+skip)
        | otherwise = (c `div` (10^(len - s))) `mod` 10 
                           where
                             skip = s `div` bexp
                             len = toInteger (length (show c) - 1)

----------------------------------------------------------------------------

pb52 = do52 [2 ..]

do52 :: [Integer] -> Integer
do52 (x:xs)
     | anal52 x = x
     | otherwise = do52 xs

anal52 :: Integer -> Bool
anal52 x = s1 == s2 && s1 == s3 && s1 == s4 && s1 == s5 && s1 == s6
           where
             s1 = sort (map digitToInt (show x))
             s2 = sort (map digitToInt (show (2*x)))
             s3 = sort (map digitToInt (show (3*x)))
             s4 = sort (map digitToInt (show (4*x)))
             s5 = sort (map digitToInt (show (5*x)))
             s6 = sort (map digitToInt (show (6*x)))     

-----------------------------------------------------------------------

pb42 :: IO ()
pb42 = do
          r <- readFile "pb42.txt"
          putStr(show(sum (map triangle (read("[" ++ r ++ "]") :: [String]))))

triangle :: String -> Int
triangle x 
         | h==0 = 1
         | otherwise = 0
    where
      gg :: Float
      gg = sqrt (1+ 8*(fromIntegral (sum (map letter x))))
      h = gg - fromIntegral (truncate gg)
      letter :: Char -> Int
      letter x = fromEnum x - 64

------------------------------------------------------------------

howManyPrimes :: Int -> Int -> Int -> Int
howManyPrimes a b c
              | nr>1 && (nr `mod` 2 == 1) && (isPrime nr 3) = 1 + howManyPrimes a b (c+1)
              | otherwise = 0
                            where
                              nr = toInteger (c^2 + a*c + b)

searFunc :: Int -> Int -> Int -> Int -> Int
searFunc a b max r
         | a == 1000 && b == len = r
         | b == len = searFunc (a+1) 0 max r
         | max1 >= max = searFunc a (b+1) max1 (a*(fromInteger(pr27!!b)))
         | otherwise = searFunc a (b+1) max r
                       where
                         max1 = howManyPrimes a (fromInteger(pr27 !! b)) 0
                         len = length pr27
pr27 = primeList [2 .. 1000]
                         

pb27 = searFunc (-1000) 0 0 0

----------------------------------------------------------------------------

isPent :: Integer -> Bool
isPent x = (h==0) && ((1 + (round gg))`mod`6 == 0 )
           where
              gg :: Double
              gg = sqrt (1 + 24*(fromIntegral x))
              h :: Double
              h = gg - fromIntegral (truncate gg)

genHex :: Integer -> Integer
genHex x = x*(2*x-1)

pb45 = help45 286
        where
          help45 :: Integer -> Integer
          help45 x
                 | isPent a = a 
                 | otherwise = help45 (x+1)
                               where
                                 a = genHex x

--------------------------------------------------------------


fractions :: Double -> Double -> Double -> (Double,Double)
fractions a b c
          | a == 10 = (1,1)
          | b== 10 = fractions (a+1) (a+2) 1
          | c == 10 = fractions a (b+1) 1
          | a/b == (c + a*10)/(b + c*10) = ((c + a*10) * fst ax,(b + c*10)* snd ax)
          | a/b == (a + c*10)/(c + b*10) = ((a + c*10) * fst ax,(c + b*10)* snd ax)
          | otherwise = ax
                        where
                          ax = fractions a b (c+1)

pb33 = (round (snd f))`div`gcd (round(fst f)) (round(snd f))
       where
         f = fractions 1 2 1

--------------------------------------------------------------------------
factorialList :: Array Integer Double
factorialList = listArray (0,100) (map fact [0 .. 100])
                           
choose :: Integer -> Integer -> Double
choose n r = (factorialList ! n) /((factorialList ! r) * (factorialList ! (n-r)))

nrBig :: Integer -> Integer -> Integer
nrBig n r
      | n == 101 = 0
      | r == (n+1) = nrBig (n+1) 0
      | choose n r > 1000000.0 = 1 + nrBig n (r+1)
      | otherwise = nrBig n (r+1)

pb53 = nrBig 1 0

-----------------------------------------------------------------------------

pb56 = maximum[sum (map digitToInt (show (a^b))) | a <- [1 .. 100], b <- [1 .. 100]]

-----------------------------------------------------------------------------


prevPermutation :: Int -> Int -> [Int] -> [Int]
prevPermutation a b l =reverse (sort ( take (a-1) l ++ [b] ++ (take (b-a) (drop a l))) ++ swap ((maximum(filter (<(l!!b)) (take (a+1) l))), l!!b))
                        where
                          swap :: (Int,Int) -> [Int]
                          swap (a,b) = drop (b+1) l ++ [a]


-------------------------------------------------------------------------------

pb55 = sum ( map (isLych 0) [1 .. 9999])

isLych :: Integer -> Integer -> Integer
isLych c x
       | c==50 = 1
       | c == 0 = isLych 1 (x + r)
       | x == r = 0
       | otherwise = isLych (c+1) (x+r)
         where
           r =  read (reverse (show x)) :: Integer

---------------------------------------------------------------------------------

recur :: Int -> [Int] -> Int
recur x (y:ys)
      | div1 == 0 = 0
      | elem div1 (y:ys) = count div1 1 (y:ys)
      | otherwise = recur x (div1: y : ys)
        where
          div1 = (y - (y`div`x)*x)*10
          len = length (y:ys)
          count :: Int -> Int -> [Int] -> Int
          count x c (y:ys)
                | x==y = c
                | otherwise = count x (c+1) ys

pb26 = snd(foldr (\(a,b) -> \(c,d) -> mx (a,b) (c,d)) (0,0) (map (\x -> (recur x [10],x)) [1 .. 1000]))
       where
         mx :: (Int,Int) -> (Int,Int) -> (Int,Int)
         mx (a,b) (c,d)
            | a>=c = (a,b)
            | otherwise = (c,d)

---------------------------------------------------------------------------------

pyt :: Int -> [(Int,Int,Int)]
pyt x = [(a,b,truncate (calc a b)) | a<- [1 .. x], b<-[a+1 .. x],round(calc a b) + a + b <=x, (calc a b)- fromIntegral (truncate (calc a b)) ==0]
             where
               calc :: Int -> Int -> Double
               calc a b= sqrt ((fromIntegral a)^2 + (fromIntegral b)^2)

pb39 = count 0 0 0 0 (sort (map (\(x,y,z) -> x+y+z) (pyt 1000)))

count :: Int -> Int -> Int -> Int -> [Int] -> Int
count xm cm xi ci [y] 
      | y == xi && ci+1>cm = xi
      | otherwise = xm
count xm cm xi ci (y1:y2:ys)
      | xi == 0 = count xm cm y1 1 (y1:y2:ys)
      | xi == y1 && xi/=y2 && ci>cm = count xi ci 0 0 (y2:ys)
      | xi == y1 && xi/=y2 = count xm cm 0 0 (y2:ys)
      | xi == y1 && xi==y2 = count xm cm xi (ci+1) (y2:ys)

-----------------------------------------------------------------------------------

pb31 :: Int -> Int
pb31 x = length (concat[concat[concat[concat[concat[concat[concat [ [h | h<- [0,200 .. (x-g-f-e-d-c-b-a)], a + b + c + d + e + f + g + h == x] | g<- [0,100 .. (x-f-e-d-c-b-a)]] | f<- [0,50 .. (x-e-d-c-b-a)]] | e<- [0,20 .. (x-d-c-b-a)]] | d<- [0,10 .. (x-c-b-a)]] | c<- [0,5 .. (x - b - a)]]| b<- [0,2 .. (x-a)]]|a<- [0 .. x]])

-----------------------------------------------------------------------------------

genRetPrimes :: [Integer] -> [Integer]
genRetPrimes (p:ps) 
             |and [(isPrimeE (read (take x (show p)))) && (isPrimeE (read(drop x (show p)))) | x<- [1 .. (length (show p)-1)]] = p : genRetPrimes ps  
             | otherwise = genRetPrimes ps

pb37 = sum(take 11 (genRetPrimes (drop 4 (primeList [2 .. 1000000]))))

------------------------------------------------------------------------------------

pb41 :: Integer
pb41 = findPrimePerm 9

findPrimePerm :: Integer -> Integer
findPrimePerm x 
              | x==0 = 0
              | lt  == [] = findPrimePerm (x-1)
              | otherwise = maximum lt
                            where
                              lt = filter (isPrimeE) (map (ravel 0) (permutations [1 .. x]))

--------------------------------------------------------------------------------------

pb32 :: Integer
pb32 = sum (nub (checkPan 9))

checkPan :: Integer -> [Integer]
checkPan x = map (\y -> (ravel 0 (drop 5 y))) (filter (checkHelp) (permutations [1 .. x]))
             
checkHelp :: [Integer] -> Bool
checkHelp x 
          | (ravel 0 (take 1 x))* (ravel 0 (take 4 (drop 1 x))) == (ravel 0 (drop 5 x)) = True
          | (ravel 0 (take 2 x))* (ravel 0 (take 3 (drop 2 x))) == (ravel 0 (drop 5 x)) = True 
          | otherwise = False

----------------------------------------------------------------------------------------

l79 :: IO ()
l79 = do
         x <- readFile "pb79.txt";
         putStr (show(tot79 (lines x)));

calc79 :: Int -> [String] -> ([Int],[Int])
calc79 a [] = ([],[])
calc79 a (x:xs) = pl79 (helpCalc a (map digitToInt x)) (calc79 a xs)

pl79 :: ([Int],[Int]) -> ([Int],[Int]) -> ([Int],[Int])
pl79 (a,b) (c,d) = (nub'(a ++ c), nub'(b ++ d))
                
helpCalc :: Int -> [Int] -> ([Int],[Int])
helpCalc a (x:y:z:q) 
         | x /= a && y/=a && z/=a = ([],[])
         | x==a = ([],[y,z])
         | y==a = ([x],[z])
         | otherwise = ([x,y],[])
 
tot79 :: [String] -> [([Int],[Int])]
tot79 xs = map (\z -> calc79 z xs) [0 .. 9]

------------------------------------------------------------------------------------------

-- f = 1, s = []
pb38 :: Integer 
pb38 = maximum ( filter (isPanDig 9) (map (\x -> oddProd x 1 []) ([1 .. 9] ++ [25 .. 33] ++ [100 .. 333] ++ [5000 .. 9999])))

oddProd :: Integer -> Integer -> String -> Integer
oddProd x f s
        | length s + length ( show (x*f))>9 = ravel 0 (map (toInteger.digitToInt) s)
        | otherwise = oddProd x (f+1) (s ++ (show (x*f)))

-------------------------------------------------------------------------------------------

pb47 =head(filter (all ((==4).snd)) (map (take 4) (tails (zip [10 ..150000] (map (\x -> length(facList1 x prim47)) [10 ..150000])))))
        where
          prim47 = (primeList [2 .. 150000])

--------------------------------------------------------------------------------------------


pr43 :: [Integer]
pr43 = [17,13,11,7,5,3,2]

-- give reverse of number we are testing and p543
subStr :: [Integer] -> [Integer] -> Bool
subStr _ [] = True
subStr (x:y:z:qs) (a:bs)
       | (z*100 + y*10 + x) `mod` a ==0 = subStr (y:z:qs) bs
       | otherwise = False

pb43 :: Integer
pb43 = sum (map (ravel 0) (filter (\x -> subStr (reverse x) pr43) (permutations [0 .. 9])))


-------------------------------------------------------------------------------------------

pb46 :: Integer
pb46 = checkComp 9

checkComp :: Integer -> Integer
checkComp x
          | isPrimeE x = checkComp (x+2)
          | or (map (\y -> isSquare((x-y)`div`2)) (drop 1(primeList [2 .. x]))) = checkComp (x+2)
          | otherwise = x

------------------------------------------------------------------------------------------

pb49 = foldr (++) "" (map (show) (checkSer (pr49 1000) (pr49 1000)))

pr49 :: Integer -> [Integer]
pr49 x = filter(>=x)(primeList [2 .. 9999])

checkSer :: [Integer] -> [Integer] -> [Integer]
checkSer [] _ = []
checkSer (x:xs) [] = checkSer xs (pr49 x)
checkSer (x:xs) (y:ys)
         | x/=1487 && x<y && isPrimeE z && (sort (unravel x) == sort (unravel y)) && (sort(unravel x) == sort(unravel z)) = [x,y,z]
         | otherwise = checkSer (x:xs) ys
           where z = x + 2*(y-x)

------------------------------------------------------------------------------------------

pb63 = checkPow 9 10 1
checkPow :: Integer -> Integer -> Integer ->Integer
checkPow 1 _ _ = 1
checkPow x y p
         | x^p>y = checkPow (x-1) 10 1
         | x^p<(y`div`10) = checkPow (x-1) 10 1
         | otherwise = 1 + checkPow x (y*10) (p+1)

-------------------------------------------------------------------------------------------

pb50 :: Integer
pb50 = findPrime (drop 1 (primeList [2 .. 1000000])) [2] [2] 2 1000000 2 1 1

-- primes>3;list of nr being considered; list of nr from best prime so far; sum of list 1; maximum bound; sum of list2; length of list 1; length of list 2
findPrime :: [Integer] -> [Integer] -> [Integer] -> Integer -> Integer -> Integer -> Integer -> Integer -> Integer
findPrime [] _ yp _ _ p ls lp = p
findPrime (x:xs) ys yp s max p ls lp
          | (s + sum (take (fromInteger(lp-ls)) (x:xs))) >= max = p
          | (isPrimeE s) && (ls>lp) = findPrime (x:xs) ys ys s max s ls ls
          | s+x >= max =( findPrime (x:xs) (drop 1 ys) yp (s-(head ys)) max p (ls-1) lp)
          | isPrimeE(s+x) && (ls>= lp)  = (findPrime xs (ys ++ [x]) (ys ++ [x]) (s+x) max (s+x) (ls+1) (ls+1))
          | otherwise = findPrime xs (ys++[x]) yp (s+x) max p (ls+1) lp

-------------------------------------------------------------------------------------------

pb44 :: Integer
pb44 = snd x - fst x
       where
         x = head(filter(\(a,b) -> (isPent (a+b)) && (isPent (b-a)))(map( \(a,b) -> ((a*(3*a-1)`div`2),(b*(3*b-1))`div`2)) [(y,x) | x<-[1 .. ],y<-[1 .. (x-1)]]))
------------------------------------------------------------------------------------------
              

exec59 :: [Int] -> [Int] -> Int -> [(Int,Int,Int)]-> [Int] -> [((Int,Int,Int),[Int])]
exec59 tx fs n [] s = []
exec59 [] fs n (k:ks) s = (k,s) : exec59 fs fs 1 ks []
exec59 (t:ts) fs n ((a,b,c):ks) s 
       | n==1 = exec59 ts fs 2 ((a,b,c):ks) (s ++ [(xor t a)])
       | n==2 = exec59 ts fs 3 ((a,b,c):ks) (s ++ [(xor t b)])
       | otherwise = exec59 ts fs 1 ((a,b,c):ks) (s ++ [(xor t c)])

separate :: Int -> [Int] -> [Int] -> [[Int]]
separate x c [] = []
separate x c (y:ys)
         | y/=x = separate x (c ++ [y]) ys
         | otherwise = c : (separate x [] ys)

pb59 :: IO()
pb59 = do
            s <- readFile ("pb59.txt")
            putStr(show (sum2(head(filter (\(a,b) -> ((filter (==[116,104,101]) (separate 32 [] b)) /=[])) (exec59 (read ("[" ++ s ++ "]")) (read ("[" ++ s ++ "]")) 1 (trip(permutations(map (xor 32) (com1 (read ("[" ++ s ++ "]") :: [Int]) [] )))) [])))))
                  where
                    trip:: [[Int]] -> [(Int,Int,Int)]
                    trip [] = []
                    trip ((x:y:z:qs):ps) = (x,y,z) : (trip ps)
                    sum2 :: (a,[Int]) -> Int
                    sum2 (a,b) = sum b

com1 :: [Int] -> [(Int,Int)] -> [Int]
com1 [] l =  map (fst) (take 3(sortBy (\(a,b) (c,d) -> (compare d b)) l))
com1 (x:xs) l = com1 (rem x xs) ((x,(length xs - length(rem x xs))) : l)
                                                where
                                                  rem x xs = filter (/=x) xs

-------------------------------------------------------------------------------------------------------------

pb92 :: Integer
pb92 = buildRest a92 (tail((map (ravel 0)([[a1,a2,a3,a4,a5,a6,a7] | a1<- [0 .. 9], a2<-[a1 .. 9], a3<-[a2 .. 9],a4<-[a3..9],a5<-[a4..9],a6<-[a5..9],a7<-[a6..9]])))) 0 0

a92 = listArray (0,600) ([0,0] ++ ([build92 a92 x x | x<-[2 .. 600]]))


build92 :: Array Integer Integer -> Integer -> Integer -> Integer
build92 a x m
        | x < m = a!x 
        | x == 89 = 1
        | otherwise = build92 a (func92 x) m 
                      
func92 :: Integer -> Integer
func92 0 = 0
func92 x = (x`mod`10)^2 + func92 (x`div`10)

buildRest :: Array Integer Integer -> [Integer] -> Integer -> Integer -> Integer
buildRest a [] s m = s
buildRest a (x:xs) s m 
        | m==0 = buildRest a (x:xs) s x
        | x < 600 && (a!x == 1) = buildRest a xs (s + (5040`div`((facI (toInteger (7 - length(show m))))*(calc92 (unravel m) 1)))) 0
        | x<600 = buildRest a xs s 0
        | otherwise = buildRest a ((func92 x):xs) s x

calc92 :: [Integer] -> Integer -> Integer
calc92 (x:[]) s = facI s
calc92 (x:y:zs) s
       | x == y = calc92 (y:zs) (s+1)
       | otherwise = facI s * calc92 (y:zs) 1

------------------------------------------------------------------------------------

pb57 = expans57 3 2 1
      
expans57 :: Integer -> Integer -> Integer -> Integer
expans57 a b c
         | c==1000 = 0
         | length(show (a`div` q)) > length(show (b`div`q)) = 1 + expans57 (a+2*b) (a+b) (c+1)
         | otherwise = expans57 (a+2*b) (a+b) (c+1)
                       where
                         q = gcd a b

------------------------------------------------------------------------------------

pb58 :: Integer
pb58 = cons58 1 2 3 1 2

cons58 :: Integer -> Integer -> Integer -> Integer -> Integer -> Integer
cons58 c a n p np
       | p*10 < np  && p/=0 = a-1
       | c == 3 && isPrimer (n+a+a+2) = cons58 1 (a+2) (n+a+a+2) (p+1) (np+2)
       | c == 3 = cons58 1 (a+2) (n+a+a+2) p (np+2)
       | isPrimer(n+a) = cons58 (c+1) a (n+a) (p+1) (np+1)
       | otherwise = cons58 (c+1) a (n+a) p (np+1)

pr58 = (drop 1 (primeList [2 .. 1000000]))

isPrimer :: Integer -> Bool
isPrimer x = (x>2 && x`mod`2==1 && isPr x pr58) || x == 2
             where
               isPr :: Integer -> [Integer] -> Bool
               isPr a [] = True
               isPr a (x:xs)
                    | a < x*x = True
                    | a`mod`x == 0 = False
                    | otherwise = isPr a xs

-------------------------------------------------------------------------------------

pb99 :: IO()
pb99 = do
        s <- readFile("pb99.txt")
        putStr(show(foldl' (\(z,(a,b)) (w,(c,d)) -> if ((fromInteger b)*(log (fromInteger a)))> ((fromInteger d)*(log (fromInteger c))) then (z,(a,b)) else (w,(c,d))) (0,(1,1))(zip [1..1000] (map (\w -> read w :: (Integer,Integer)) (map (\x -> "(" ++ x ++ ")") (lines s))))))

------------------------------------------------------------------------------------

pr69 = primeList [2 .. 1000]
pb69 = head (sortBy(\(a,b) (c,d) -> compare d b) (map (\(a,b) -> (a,product(map (\x -> ((fromInteger x)/ (fromInteger(x-1)))) (facList1 b pr69)))) (zip [1 .. 1000000] [1 .. 1000000])))

--------------------------------------------------------------------------------------

pb71 = snd(foldl' (\(x,a) (y,b) -> if(abs(x-(3/7)) < abs(y-(3/7))) then (x,a) else (y,b)) (0,0) (concat(map (\x -> map (\y -> (((fromInteger y)/(fromInteger x)),y) :: (Double,Integer)) (filter (\y -> (gcd x y) == 1) [(truncate((fromInteger x)*0.428571)+1) .. (truncate((fromInteger x)*0.428572))])) [10 .. 1000000])))
        
----------------------------------------------------------------------------------------

pb73 = length(concat(map (\x ->(filter (\y -> (gcd x y) == 1) [(truncate((fromInteger x)*(1/3))+1) .. (truncate((fromInteger x)*(1/2)))])) [1 .. 12000])) -1

----------------------------------------------------------------------------------------
-- size minus 1
size81 :: Int
size81 = 79

pb81 :: IO()
pb81 = do
         s <- readFile("pb81.txt")
         putStr(show(eval81 (map(\x -> read x :: [Integer]) (map (\x -> "[" ++ x ++ "]") (lines s))) [(-1,0)] [[0 | a<-[0..size81]]| b<-[0..size81]]))

eval81 :: [[Integer]] -> [(Int,Int)] -> [[Integer]] -> Integer
eval81 mat [] val = (val !! size81) !! size81
eval81 mat [(-1,0)] val = eval81 mat [(0,0)] ((((mat !! 0) !! 0) : (tail (head val))) : (tail val))
eval81 mat ((c1,c2):cur) val
       | good (c1+1,c2) && good (c1,c2+1) && big81 1 && big81 2= eval81 mat (cur ++ [(c1+1,c2),(c1,c2+1)]) a3
       | good (c1+1,c2) && big81 1 = eval81 mat (cur ++ [(c1+1,c2)]) a1
       | good (c1,c2+1) && big81 2 = eval81 mat (cur ++ [(c1,c2+1)]) a2
       | otherwise = eval81 mat cur val
                                                                                                                               where
                                                                                                                               a1 = (take (c1+1) val) ++ [(take (c2) (head(drop (c1+1) val)) ++ [try + mat1] ++ drop (c2+1) (head(drop (c1+1) val)))] ++ (drop (c1+2) val)  
                                                                                                                               a2 = (take (c1) val) ++ [(take (c2+1) (head(drop (c1) val)) ++ [try + mat2] ++ drop (c2+2) (head(drop (c1) val)))] ++ (drop (c1+1) val)  
                                                                                                                               a3 = (take (c1) a1) ++ [(take (c2+1) (head(drop (c1) a1)) ++ [try + mat2] ++ drop (c2+2) (head(drop (c1) a1)))] ++ (drop (c1+1) a1)  
                                                                                                                               curent1 = ((val !! (c1+1))!!c2)
                                                                                                                               curent2 = ((val !! c1) !! (c2+1))
                                                                                                                               try = ((val !! c1) !! c2)
                                                                                                                               mat1 = ((mat !!(c1+1))!!c2)
                                                                                                                               mat2 = ((mat !!c1)!!(c2+1))
                                                                                                                               good (z,w) = z>=0 && w>=0 && z<=size81 && w<=size81
                                                                                                                               big81 1 = curent1 == 0 || (curent1 > mat1 + try)
                                                                                                                               big81 2 = curent2 == 0 || (curent2 > mat2 + try)

see81 :: IO()
see81 = do
         s <- readFile("test81.txt")
         putStr(show(map(\x -> read x :: [Integer]) (map (\x -> "[" ++ x ++ "]") (lines s))))

-------------------------------------------------------

pb112 :: Integer
pb112 = bouncy [0,0,1] 100 0

bouncy :: [Integer] -> Integer -> Integer -> Integer
bouncy (c1:c2:c) cur  bnc
          | 99*(cur-1) <= 100*bnc = cur-1
          | c1 <= c2 && (c1:c2:c) == sort(c1:c2:c) = bouncy (nt112(c1:c2:c)) (cur+1) bnc
          | c1 >= c2 && (c1:c2:c) ==reverse(sort (c1:c2:c)) = bouncy (nt112(c1:c2:c)) (cur+1) bnc
          | otherwise =bouncy (nt112(c1:c2:c)) (cur+1) (bnc+1)
                

nt112:: [Integer] -> [Integer]
nt112 [] = [1]
nt112 (x:xs)
      | x<9 = ((x+1):xs)
      | otherwise = 0 : nt112 xs

-----------------------------------------------------------------

pb54 :: IO()
pb54 = do
         s <- readFile ("pb54.txt");
         putStr(show(sum(map (\(x,y) ->if(x>y) then 1 else 0) (map (\x -> (findHand(convertHand(concat(words(take 14 x))) [] [] ), findHand(convertHand(concat(words(init(drop 15 x)))) [] []))) (lines s)))))

convertHand :: String -> [Int] -> String -> ([Int],String)
convertHand [] x y = (x,y)
convertHand (a:[]) x y = (x,y)
convertHand (a:b:xs) x y 
            | a>='2' && a<='9' = convertHand xs (x ++ [digitToInt a]) (b:y)
            | a=='A' = convertHand xs (x ++ [14]) (b:y)
            | a=='J' = convertHand xs (x ++ [11]) (b:y)
            | a=='Q' = convertHand xs (x ++ [12]) (b:y)
            | a=='K' = convertHand xs (x ++ [13]) (b:y)
            | otherwise = convertHand xs (x ++ [10]) (b:y)

findHand :: ([Int],String) -> (Int,[Int])
findHand (xs,s)
         | flush s && straight (sort xs) = (9,[(maximum xs)])
         | fst(fourKind xs) = (8,[snd(fourKind xs)])
         | fst(full xs) = (7,[snd(full xs)])
         | flush s = (6,[(maximum xs)])
         | straight (sort xs) = (5,[(maximum xs)])
         | fst(threeKind xs) = (4,[snd(threeKind xs)])
         | fst(twoPairs xs) = (3,snd(twoPairs xs))
         | fst(pair xs) = (2,snd(pair xs))
         | otherwise = (1,reverse(sort xs))

flush s = length(nub s) == 1; 

straight :: [Int] -> Bool
straight [x] = True
straight (x:y:zs)
         | x /= y-1 = False
         | otherwise = straight (y:zs)

howMany :: [Int] -> [Int] -> Int -> [Int] -> [(Int,Int)]
howMany [] cs c ns =  sort(zip ns cs)
howMany (x:[]) cs c ns  = howMany [] (x:cs) 1 (c:ns)
howMany (x:y:zs) cs c ns
         | x==y = howMany (y:zs) cs (c+1) ns 
         | otherwise = howMany (y:zs) (x:cs) 1 (c:ns) 

fourKind xs =(map fst list == [1,4] , snd(last list))
                         where
                           list = (howMany (sort xs) [] 1 [])

threeKind xs = (map fst list == [1,1,3] , snd(last list))
                    where
                           list = (howMany (sort xs) [] 1 [])

full xs = (map fst list == [2,3], snd(last list))
           where
                   list = (howMany (sort xs) [] 1 [])

twoPairs xs = (map fst list == [1,2,2], reverse(map snd list))
                   where
                     list = (howMany (sort xs) [] 1 [])

pair xs = (map fst list == [1,1,1,2] , reverse(map snd list))
           where
                     list = (howMany (sort xs) [] 1 [])

---------------------------------------------------------------------------------------

pb76 :: Integer
pb76 = din76 [] 0 0 []

din76 :: [[Integer]] -> Integer -> Integer -> [Integer] -> Integer
din76 a x y w
      | x == 100 = (a!!(fromInteger(x-1)))!!(fromInteger(x-1)) -1
      | x == 0 = din76 (a ++ [replicate 100 1]) (x+1) 0 [] 
      | y == 100 = din76 (a ++ [w]) (x+1) 0 []
      | y == 0 = din76 a x (y+1) [1]
      | x == y = din76 a x (y+1) (w ++ [last w + 1])
      | x < y = din76 a x (y+1) (w ++ [last w])
      | otherwise = din76 a x (y+1) (w ++ [last w + (a!!(fromInteger(x-y-1)))!!(fromInteger y)])

----------------------------------------------------------------------------------------

pb62 = head(filter (/=0) (map(\ls -> f62 (qsort1(map(\x ->(read (qsort1(show (x^3))) :: Integer, x)) ls)) 0 0) (map (\x -> [(truncate((10^x)**(1/3))) .. (truncate((10^(x+1))**(1/3))+1)]) [1 .. ])))^3

f62 :: [(Integer,Integer)] -> Integer -> Integer -> Integer
f62 [] cn s = s;
f62 (a:[]) cn s= s;
f62 ((a,b):(c,d):xs) cn s
    | a/= c && cn==4 = f62 ((c,d):xs) 0 b 
    | a/=c = f62 ((c,d):xs) 0 s
    | otherwise = f62 ((c,d):xs) (cn+1) s 

-------------------------------------------------------------------------------------------

pb85 = fst alf * snd alf
       where
         alf = (find85 53 53 0 (0,0))

find85 :: Integer -> Integer -> Integer -> (Integer,Integer) -> (Integer,Integer)
find85 x y pb cr
       | x==10 = cr
       | sol < 2000000 && abs(2000000 - sol) > pb = find85 x (y+1) pb cr
       | (abs(2000000 - sol) < pb) || pb==0 = find85 (x-1) y (abs(2000000 - sol)) (x,y)
       | otherwise = find85 (x-1) y pb cr
                     where
                       sol = f85 x y 0 1 1

f85 :: Integer -> Integer -> Integer -> Integer -> Integer -> Integer
f85 x y s cx cy
    | cy > x && cy > y = s
    | cx > x = f85 x y s 1 (cy+1)
    | cx == cy = f85 x y (s+(x-(cx-1))*(y-(cy-1))) 1 (cy+1)
    | otherwise =f85 x y (s+(v(x-(cx-1)))*(v(y-(cy-1)))+(v(x-(cy-1)))*(v(y-(cx-1)))) (cx+1) cy
                  where
                    v x
                      | x>0 = x
                      | otherwise = 0

--------------------------------------------------------

pb65 = sum(unravel(fst(calc65 efrac 0 1)))

efrac = concat[[1,2*k,1] | k<-[33,32 .. 1]] ++ [2]

-- efrac, 0, 1
calc65 :: [Integer] -> Integer -> Integer ->(Integer,Integer)
calc65 (x:[]) a b = (a+x*b,b)
calc65 (x:xs) a b= calc65 xs b (a+x*b)

-----------------------------------------------------------------

f74 x = sum(map preFac (unravel x))

len74 :: [Integer] -> Integer -> Integer
len74 xs y
      | filter(==y) xs == [] = 1 + len74 (y:xs) (f74 y)
      | otherwise = 0

s74 :: [Integer] -> Integer 
s74 [] = 0
s74 (x:xs) 
    | len74 [] x < 60 = s74 xs
    | otherwise =pp x +( s74 xs)
                  where
                    pp x
                       | x`mod`10 /=0 = numPerm (unravel x)
                       | otherwise = numPerm (unravel x) - numPerm (unravel (x`div`10))
                   

c74 :: [Integer]
c74 = concat(map (\x -> cor74 x) (map (ravel 0) [[a,b,c,d,e,f] | a<-[0 .. 9],b<-[a .. 9],c<-[b .. 9],d<-[c..9],e<-[d..9],f<-[e..9]]))

cor74 :: Integer -> [Integer]
cor74 0 = [0]
cor74 x
      | x >99999 = [x]
      | otherwise = x : (cor74 (x*10))

-----------------------------------------------------------

pb102 :: IO()
pb102 = do
          s <- readFile("pb102.txt")
          putStr(show(length (filter(==True) (map(help102) (map (\x -> read ("[" ++ x ++ "]") :: [Double]) (lines s))))))

help102 :: [Double] -> Bool
help102 (x1:y1:x2:y2:x3:y3:zs) = abs(area1 - (area2 + area3 + area4)) <0.1 
                                 where
                                   l1=sqrt((x2-x3)^2 + (y2-y3)^2)
                                   l2=sqrt((x1-x3)^2 + (y1-y3)^2)
                                   l3=sqrt((x2-x1)^2 + (y2-y1)^2)
                                   p1 = (l1+l2+l3)/2
                                   area1 = sqrt(p1*(p1-l1)*(p1-l2)*(p1-l3))
                                   t1=sqrt(x1^2 + y1^2)
                                   t2=sqrt(x2^2 + y2^2)
                                   t3=sqrt(x3^2 + y3^2)
                                   p2 = (t1+t2+l3)/2
                                   p3 = (t2+t3+l1)/2
                                   p4 = (t3+t1+l2)/2
                                   area2 = sqrt(p2*(p2-t1)*(p2-t2)*(p2-l3))
                                   area3 = sqrt(p3*(p3-t2)*(p3-t3)*(p3-l1))
                                   area4 = sqrt(p4*(p4-t1)*(p4-t3)*(p4-l2))

------------------------------------------------------------------
-- number to check, number of digits in nr, 0
kosher206 :: Integer -> Integer -> Integer -> Bool
kosher206 x c n
          | n== -1 = kosher206 x c 9
          | c <= 0 = True
          | x `mod` 10 /= n = False
          | otherwise = kosher206 (x`div`100) (c-2) (n-1) 

try206 :: [Integer] -> Integer -> Integer -> [Integer]
try206 sols n x
       | x == n = sols
       | otherwise = try206 (filter (\y -> kosher206 ((y^2)`mod`(10^(x+1))) (x+1)  0) (concat(map (\s -> map (\t -> t*(10^(x)) + s) [0 .. 9]) sols))) n (x+1)

pb206 :: [Integer]
pb206 = filter (\x -> (kosher206 (x^2) 19 0) && length (show (x^2)) == 19) (try206 [0] 10 0)

--------------------------------------------------------------------

pb87 = brute87 2 2 2 p87 p87 p87 p87 0

p87 = tail (primeList [2 .. 7100])

brute87 :: Integer -> Integer -> Integer -> [Integer] -> [Integer] -> [Integer] -> [Integer] -> Integer -> Integer
brute87 a b c (ap:aprimes) (bp:bprimes) (cp:cprimes) xprimes sol
        | a^2 + b^3 + c^4 >= 5000000 && b==2 && c==2 = sol
        | a^2 + b^3 + c^4 >= 5000000 && c==2 = brute87 (ap) 2 2 aprimes xprimes xprimes xprimes sol
        | a^2 + b^3 + c^4 >= 5000000 = brute87 a (b+1) 2 (ap:aprimes) bprimes xprimes xprimes sol
        | otherwise = brute87 a b (c+1) (ap:aprimes) (bp:bprimes) cprimes xprimes (sol+1)

---------------------------------------------------------------------

p51 = primeList [2..1000000]

f51 :: [Integer] -> [(Integer,Integer)]
f51 [] = []
f51 (p:ps) 
    | fst q == 3 = sol : f51 ps
    | otherwise = f51 ps
                  where
                    q = (many51 (sort (unravel p)) 0 0 1)
                    sol = (snd q , p)

many51 :: [Integer] -> Integer -> Integer -> Integer -> (Integer,Integer)
many51 [] n q cn = (n,q)
many51 (x:[]) n q cn
       | cn>=n = (cn,x)
       | otherwise = (n,q)
many51 (x:y:zs) n q cn
       | x==y = many51 (y:zs) n q (cn+1)
       | x/=y && cn>=n = many51 (y:zs) cn x 1
       | otherwise = many51 (y:zs) n q 1

pb51 =  head(filter(\(a,b) -> a>7) (map (\(x,p) -> (length(filter (\y -> isPrimeE y && (length (show y) == length (show p))) (map (\n -> ravel 0 (reverse(map (\r -> if(r==x) then n else r) (unravel p)))) [0 .. 9])),p)) (f51 p51)))

---------------------------------------------------

gen4Oct = (map (\x -> (x*(3*x-2),8)) [19..58])

gen4Hep = (map (\x -> ((x*(5*x-3))`div`2,7)) [21..63])

gen4Hex = (map (\x -> (x*(2*x-1),6)) [23..70])

gen4Pen = (map (\x -> (((x*(3*x-1))`div`2),5)) [26..81])

gen4Sqr = (map (\x -> (x*x,4)) [32..99])

gen4Tri = (map (\x -> (((x*(x+1))`div`2),3)) [45..140])

f61 3 = gen4Tri
f61 4 = gen4Sqr
f61 5 = gen4Pen
f61 6 = gen4Hex
f61 7 = gen4Hep
f61 8 = gen4Oct

sBeg61 :: [Integer] -> Integer -> [(Integer,Integer)]
sBeg61 xs n
       | n <10 || n>99 = []
       | otherwise = filter (\(x,y) -> read(take 2 (show x)) == n) (concat (map f61 xs))

-- oct, oct, 0 , [[(oct,no)]],[oct],[no]
start61 :: Integer -> Integer -> Integer -> [[(Integer,Integer)]] -> [Integer] -> [Integer] -> [Integer]
start61 a b count sols csol cfs
        | sols == [[]] = [] 
        | b==0 && cur/=[] = start61 a (fst (head cur)) count sols (csol ++ [fst (head cur)]) (cfs ++ [snd (head cur)])
        | b==0 = start61 a 0 (count-1)  (init(init sols) ++ [tail(last(init sols))]) (init csol) (init cfs)
        | count == 5 && read(drop 2 (show(last csol))) == (read(take 2 (show a)) :: Integer) = csol
        | now /= [] = start61 a 0 (count+1) (sols ++ [now]) csol cfs
        | otherwise = start61 a 0 count ((init sols) ++ [(tail (last sols))]) (init csol) (init cfs)
          where
            now = sBeg61 (filter (\x -> not(elem x cfs)) [3 .. 8]) (read(drop 2 (show b)))
            cur = (sols!!(fromInteger count))

pb61 = sum(head(filter (/=[]) (map (\(oct,no) -> start61 oct oct 0 [[(oct,no)]] [oct] [no]) (f61 8))))

-------------------------------------------------------------------------

pb72 = foldl'(+) 0 (elems ar72)

ar72 = listArray (1,1000000) ([0] ++ [f72 x ar72 | x <- [2 .. 1000000]])

ar73 = listArray (1,1000000) [1 .. 1000000]

f72 :: Integer -> Array Integer Integer -> Integer
f72 n ar = (n-1) - sum(map(\x -> ar!x) (init(divList n)))