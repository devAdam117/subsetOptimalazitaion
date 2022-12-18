# subsetOptimalazitaion
## Dynamical programming
### hlavneZadanie.r
- split one set (K) into two subsets (K1,K2) where the sum differences of two sets are minimized. 
- informally split K into K1 and K2 such that (sum(K1)- sum(K2)) is minimal
- eg: solveCardsSeparation (c(1:100))
- args for solveCardsSeparation(cards,showmatrices=FALSE)
  - cards: vector of card values
  - showmatrices: whether to show the value of v,V matrices by which is optimal way constructed
- return 
  - xOpt: cumulative sum of first subset after every card iteration
  - uOpt: indicates which cards are going to the first subset after each card iteration
  - diff: show final difference in absolute value between first and second subset
### nadstavbaOptimalizaciaPoctuKarticiek.R
- split one set (K) into two subsets (K1,K2) where the sum differences and length differences of two sets are minimized.
- informally split K into K1 and K2 such that (sum(K1) - sum(K2) + length(K1)- length(K2)) is minimal
- possibility to add weights whether to focus more on sum differences or length differences 
- egs: solveCardsSeparationByValueAndQuantity(c(1:20))
- args for solveCardsSeparation(cards,showmatrices=FALSE)
  - cards: vector of card values
  - showmatrices: whether to show the value of v,V matrices by which is optimal way constructed
