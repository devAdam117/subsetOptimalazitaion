# POMOCNE FUNCKIE STARTS (funkcie, ktore sa vyuzivaju v algoritme nizsie..)
# vyplatova fcia
# x - stav teraz (uz ma vsebe nascitane predch stavy)
# cards - vektor kariet s hodnotami
payoff <- function(x,cards){
  return((2*x - sum(cards))^2)
}

# buduci stav
# x - stav teraz (uz ma vsebe nascitane predch stavy)
# u - riadenie teraz (1/0)
# cardValue - hodnota aktualnej karty
nextState <- function(x,u,cardValue){
  return(x+u*cardValue)
}

# test na to ci sa hodnota nachadza v pozadovanom intervale
# minBoundry/maxBoundry - spodna vrchna hranica
# value - dana hodnota, ktoru testujeme
# includeBoundries - ci berieme do intervalu aj hranicne pridady hodnot
isInInterval <- function(minBoundry,maxBoundry,value,includeBoundries = TRUE){
  if(value < minBoundry || value > maxBoundry){
    return(FALSE)
  }
  if((value==minBoundry || value==maxBoundry) && includeBoundries==FALSE){
    return(FALSE)
  }
  return(TRUE)
}
#POMOCNE FUNKCIE ENDS

# V komentoch oznacenie PZD: podla zadanie
#funkcia ktora prijima ako argument karty, ktore pouzije do algoritmu
solveCardsSeparation <- function (cards,showMatrices=FALSE){
  # pocet rozhodnuti/kariet
  k <- length(cards) #PZD 12
  #ohranicenia pre stavovu a riadiaciu
  xMax <- sum(cards) # PZD 79
  xMin <- 0
  uMax <- 1
  uMin <- 0
  #hodnotova funkcia  a optimalna spatna vazba
  V <- matrix(Inf,k+1,xMax+1)
  v <- matrix(Inf,k,xMax+1)
  #pripustny koncovy stav pre ulohu s volnym koncom
  V[k+1,] <- 0
  #pre kazdu karticku
  for(cardIdx in k:1){
    #pre kazdu hodnotu x od 1 po xMax+1 lebo v r sa indexuje od 1
    for(xIdx in 1:(xMax+1)){
      # pre kazdu volbu ucka
      for(uIdx in 1:(uMax+1)){
        # prenastavenie hodnot aby sedeli od indexu = 0
        x <- xIdx - 1 # PZD: [0-79]
        u <- uIdx - 1 # PZD: [0-1]
        # hodnota dalsieho stavu
        fi <- nextState(x,u,cards[cardIdx])
        # celkovy rozdiel pre f0 pocitame iba v koncovom pridape pre cardIdx = k, inac je nulovy
        f0 <- 0
        if(cardIdx == k ){
          f0 <- payoff(fi,cards)
        }
        #test pripustnotsti
        if(!isInInterval(xMin,xMax,fi)){
          #ak sa nenachadza ideme na dalsu iteraciu
          next
        }
        #test optimalnosti
        if(f0 + V[cardIdx+1,fi + 1] > V[cardIdx,xIdx]){
          #ak nie je optimalne iterujeme dalej
          next
        }
        V[cardIdx,xIdx] <- f0 + V[(cardIdx+1), fi + 1]
        v[cardIdx,xIdx] <- u
      }
    }
  }
  # Vypocet optimalnych krokov pre zadane karticky v premennej cards
  xOpt <- matrix(0,1,k+1)
  uOpt <- matrix(0,1,k)
  xOpt[1,1] <- 0
  for(i in 1:k){
    uOpt[1,i] <- v[i,xOpt[1,i]+1]
    xOpt[1,i+1] <- xOpt[1,i] + cards[i] * uOpt[1,i]
  }
  # vypocet finalnych rozdielov v abs hodnote pre ucely porovnavanie s inym algoritmom
  diff=abs(sum(cards[uOpt==1])-sum(cards[uOpt==0]))
  ret <- list(v=v,V=V,xOpt=xOpt,uOpt=uOpt,diff=diff,fairDiffs=NULL)
  if(!showMatrices){
    ret <- list(xOpt=xOpt,uOpt=uOpt,diff=diff,fairDiffs=NULL)
  }
  if(sum(cards) %% 2 ==0){
    ret <- list(v=v,V=V,xOpt=xOpt,uOpt=uOpt,diff=diff,fairDiffs=diff)
  }
  return(ret)
}

