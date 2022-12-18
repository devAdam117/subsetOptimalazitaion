# POMOCNE FUNCKIE STARTS (funkcie, ktore sa vyuzivaju v algoritme nizsie..)
# vyplatova fcia
# x - stav teraz (uz ma vsebe nascitane predch stavy)
# cards - vektor kariet s hodnotami
payoffAdv <- function(x,cards,z,valueWeight=1,quantityWeight=1){
  return((valueWeight*(2*x - sum(cards)))^2+((quantityWeight*(2*z-length(cards))))^2)
}

# buduci stav
# x - stav teraz (uz ma vsebe nascitane predch stavy)
# u - riadenie teraz (1/0)
# cardValue - hodnota aktualnej karty
nextState <- function(x,u,cardValue){
  return(x+u*cardValue)
}

# buduci stav
# z - stav poctu teraz (uz ma vsebe nascitane predch stavy)
# u - riadenie teraz (1/0)
# cardValue - hodnota aktualnej karty
nextStateZ <- function(z,u){
  return(z+u)
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

solveCardsSeparationByValueAndQuantity <- function(cards,valueWeight=1,quantityWeight=1,showMatrices=FALSE){
  


  # V komentoch oznacenie PZD: podla zadanie
  #funkcia ktora prijima ako argument karty, ktore pouzije do algoritmu
    # pocet rozhodnuti/kariet
    k <- length(cards) #PZD 12
    #ohranicenia pre stavovu a riadiaciu
    xMax <- sum(cards) # PZD 79
    xMin <- 0
    uMax <- 1
    uMin <- 0
    zMin <- 0
    zMax <- length(cards)
    #hodnotova funkcia  a optimalna spatna vazba
    V <- array(Inf,c(k+1,xMax+1,zMax+1))
    v <- array(Inf,c(k,xMax+1,zMax+1))
    #pripustny koncovy stav pre ulohu s volnym koncom
    V[k+1,,] <- 0
    #pre kazdu karticku
    for(cardIdx in k:1){
      #pre kazdu hodnotu x od 1 po xMax+1 lebo v r sa indexuje od 1
      for(xIdx in 1:(xMax+1)){
        for(zIdx in 1:(zMax+1)){
          # pre kazdu volbu ucka
          for(uIdx in 1:(uMax+1)){
            # prenastavenie hodnot aby sedeli od indexu = 0
            x <- xIdx - 1 # PZD: [0-79]
            u <- uIdx - 1 # PZD: [0-1]
            z <- zIdx -1 
            # hodnota dalsieho stavu pre hodnotu
            fi <- nextState(x,u,cards[cardIdx])
            # hodnota dalsieho stavu pre pocet
            fi2 <- nextStateZ(z,u)
            # celkovy rozdiel pre f0 pocitame iba v koncovom pridape pre cardIdx = k, inac je nulovy
            f0 <- 0
            if(cardIdx == k ){
              f0 <- payoffAdv(fi,cards,fi2,valueWeight,quantityWeight)
            }
            nextStateZ(z,u)
            #test pripustnotsti
            if(!isInInterval(xMin,xMax,fi)){
              #ak sa nenachadza ideme na dalsu iteraciu
              next
            }
            if(!isInInterval(zMin,zMax,fi2)){
              #ak sa nenachadza ideme na dalsu iteraciu
              next
            }
    
            #test optimalnosti
            if(f0 + V[cardIdx+1,fi + 1,fi2 +1] > V[cardIdx,xIdx, zIdx]){
              #ak nie je optimalne iterujeme dalej
              next
            }
            V[cardIdx,xIdx,zIdx] <- f0 + V[(cardIdx+1), (fi + 1),(fi2 +1)]
            v[cardIdx,xIdx,zIdx] <- u
          }
        }
      }
    }
    # Vypocet optimalnych krokov pre zadane karticky v premennej cards
    xOpt <- matrix(0,1,k+1)
    zOpt <- matrix(0,1,k+1)
    uOpt <- matrix(0,1,k)
    xOpt[1,1] <- 0
    zOpt[1,1] <- 0
    for(i in 1:k){
      uOpt[1,i] <- v[i,xOpt[1,i]+1,zOpt[1,i]+1]
      xOpt[1,i+1] <- xOpt[1,i] + cards[i] * uOpt[1,i]
      zOpt[1,i+1] <- zOpt[1,i] + uOpt[1,i]
    }
    # vypocet finalnych rozdielov v abs hodnote pre ucely porovnavanie s inym algoritmom
    sumDiff<-abs(sum(cards[uOpt==1])-sum(cards[uOpt==0]))
    countDiff<-abs(length(cards)-2*zOpt[length(zOpt)])
    ret <- list(v=v,V=V,xOpt=xOpt,uOpt=uOpt,zOpt=zOpt,diff=diff,sumDiff=sumDiff, countDiff=countDiff)
    if(!showMatrices){
      ret <- list(xOpt=xOpt,uOpt=uOpt,zOpt=zOpt,sumDiff=sumDiff, countDiff=countDiff)
    }
    return(ret)
}
    
    




