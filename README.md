# subsetOptimalazitaion
## Dynamical programming
### hlavneZadanie.r
- split one set (K) into two subsets (K1,K2) where the sum differences of two sets are minimized. 
- informally split K into K1 and K2 such that (sum(K1)- sum(K2)) is minimal
- eg: solveCardsSeparation (c(1:100))
- args for solveCardsSeparation(cards,showmatrices=FALSE)
  - cards: vector of card values
  - showmatrices: whether to show the value of v,V matrices by which is optimal way constructed (they are 2-dimensional)
- return 
  - xOpt: cumulative sum of first subset after every card iteration
  - uOpt: indicates which cards are going to the first subset after each card iteration
  - diff: show final sum difference in absolute value between first and second subset
### nadstavbaOptimalizaciaPoctuKarticiek.R
- split one set (K) into two subsets (K1,K2) where the sum differences and length differences of two sets are minimized.
- informally split K into K1 and K2 such that (sum(K1) - sum(K2) + length(K1)- length(K2)) is minimal
- possibility to add weights whether to focus more on sum differences or length differences 
- egs: 
  - solveCardsSeparationByValueAndQuantity(c(1:20))
  - solveCardsSeparationByValueAndQuantity(c(1:20),1,2) quantity difference is 2 times more weighted than sum difference 
  - solveCardsSeparationByValueAndQuantity(c(1:20),2,1) sum difference is 2 times more weighted than quantity difference 
- args for solveCardsSeparation(cards,valueWeight=1,quantityWeight=1,showMatrices=FALSE)
  - cards: vector of card values
  - valueWeight: weight to apply for sum differences between two subsets in minimalization
  - quantityWeight: weight to apply for quantity differences between two subsents in minimalization
  - showmatrices: whether to show the value of v,V matrices by which is optimal way constructed (they are 3-dimensional)
- return
  - xOpt: cumulative sum of first subset after every card iteration
  - uOpt: indicates which cards are going to the first subset after each card iteration
  - zOpt: cumulative count of first subset after every card iteration
  - sumDiff: show final sum difference in absolute value between first and second subset 
  - countDiff: show final count difference in absolute value between first and second subset

## Custom programming algorithm
### algoritmusOndruskovec3000.r
- split one set (K) into two subsets (K1,K2) where the sum differences of two sets are minimized.
- informally split K into K1 and K2 such that (sum(K1)- sum(K2)) is minimal 
- It is faster then dynamical programming in case of many cards on input. It is not 100% accurrate (as showed in plots and simulation), that means that result of dynamical programing algorithm is  better or equal to the algoritmusOndruskovec3000. In small quantity of cards, results of ondruskovec3000 tends to be wrong in comparision to dynamical programing algorithm (dpa). In case of great cards quantity  the results are convenient and very fast in comparision to  dpa. 
- To see how often and in what card values are ondruskovec3000 wrong for visit plot: https://github.com/devAdam117/subsetOptimalazitaion/blob/main/plots/3000pocetNespravnychVysledkovPlot.pdf , where x is quantity of cards and y is how many times was ondruskovec3000 wrong for each quantity out of 100 simulation
- To see how result of ondruskovec3000 and dpa differs in case of wrong resul of ondruskovec visit: https://github.com/devAdam117/subsetOptimalazitaion/blob/main/plots/diffVysledkovOndruskovcaADapPlot.pdf , where x is the difference value of dpa and ondruskovec3000 in absolute value and y is the quantity of such records. (when odruskovec3000 is wrong it usualy differs from dpa result +-2)
- arguments 
  - cards: vector of card values
- return 
  - cards1$cardsValues: what card values are on first subset
  - cards1$cardsSum: sum of card values on first subset
  - cards2$cardsValues: what card values are on second subset
  - cards2$cardsSum: sum of card values on second subset


## nadstavboveSimulacie.r
- For comparision purposes of all algorithms, plot are in own folder.
- how many times was sum of two subsets equal out of 100 for card quantities 2-100: https://github.com/devAdam117/subsetOptimalazitaion/blob/main/plots/spravodlivyPodielPlot.pdf
- speed comparision of dpa (red) and ondruskovec3000 (blue) by the quantities of the cards 2-100 on x and total time in second on y: https://github.com/devAdam117/subsetOptimalazitaion/blob/main/plots/porovnanieRychlostiPlot.pdf
- same speed comparision but in larger card quantities (100,200,300,...,1500): https://github.com/devAdam117/subsetOptimalazitaion/blob/main/plots/porovanieExtremnychPoctovPlot.pdf

  
