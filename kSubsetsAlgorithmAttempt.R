# Pokus o vytvorenie kodu, ktory dokaze vytvorit algoritmus dynamickeho programovanie pre vseobecny pocet sestier = k 
# islo tu o to aby sa vytvorilo dynamicky tolko cyklov aky je pocet sestier a vsak z casoveho hladiska, sme sa radsej presunuli na nadstavby ineho charakteru

# POMOCNE FUNKCIE STARTS
# fcia ktora vytvori viac dimenzionalnu maticu pre viacej stavovych premennych
# cards - samotne karty
# xMax - vrchna hranica pre 
getInitMultiDimensionalMatrice <- function(numOfPeople,cards, sizeInc){
  numOfCards <- length(cards)
  sumOfCardsValue <- sum(cards)
  ret <- array(Inf,c(numOfCards+sizeInc,sumOfCardsValue+1,c(rep(sumOfCardsValue+1,numOfPeople-1))))
  #posledny riadok nastavime na nulu, uloha je s volnym koncom
  callable <- getIterableExpresion("ret",numOfPeople,1,numOfCards+sizeInc, " <- 0") 
  eval(callable)
  return(ret)
}
# fcia ktora ktora vrati vyplatu
# kombinacia - dana kombinacia 
# xMax - vrchna hranica pre 
vyplata <- function(kombinacia,cards){
  kombinacieSuctovKariet <- combn(kombinacia,2)
  totalSum <- 0
  for(i in 1:length(kombinacieSuctovKariet[1,])){
    totalSum <- totalSum + (2*sum(unlist(kombinacieSuctovKariet[i,])) - sum(cards))^2
  }
  return(totalSum)
}

getIterableExpresion<- function(variableName,num,indexes,iterableNames, customCommand=NULL){
  expString <- variableName
  expString<- paste(expString,"[", sep="", collapse=NULL)
  for(i in 1:(num)){
    if(sum(indexes==i)==1){
      index <- which(indexes==i)
      expString <- paste(expString,iterableNames[index],sep="",collapse=NULL)
    }
    expString <- paste(expString,",", sep="", collapse=NULL)
  }
  expString<- paste(expString,"]", sep="", collapse=NULL)
  if(!is.null(customCommand)){
    expString <- paste(expString,customCommand, sep="", collapse=NULL)
  }
  return(parse(text = expString))
}

createSelectionForMatrice <- function(matriceName ,position, customCommand,stringReturn=FALSE){
  expString <- matriceName
  expString<- paste(expString,"[", sep="", collapse=NULL)
  for(i in 1:length(position)){
      expString <- paste(expString,position[i],sep="",collapse=NULL)
      if(i == length(position)){
        break
      }
      expString <- paste(expString,",",sep="",collapse=NULL)
  }
  expString<- paste(expString,"]", sep="", collapse=NULL)
  if(!is.null(customCommand)){
    expString <- paste(expString,customCommand, sep="", collapse=NULL)
  }
  if(stringReturn == TRUE){
    return(expString)
  }
  return(parse(text = expString))
}

# POMOCNE FUNKCIE ENDS
cards <- c(1,2,3,4)
k <- length(cards)
maxVal <- sum(cards)
minVal <- 0 
n <- 2
V <- getInitMultiDimensionalMatrice(n,cards,1)
v <- getInitMultiDimensionalMatrice(n,cards,0)
for(cardIdx in k:1){
  #pre kazdu hodnotu x od 1 po xMax+1 lebo v r sa indexuje od 1
    x <- c(1:xMax)
    kombinacie <- expand.grid(rep(list(cards), n))
    for(i in 1:length(kombinacie[,1])){
        kombinacia <- kombinacie[i,]
        for(uIdx in 1:length(kombinacia)){
          u <- rep(0,length(kombinacia))
          u[uIdx] <- 1
          fi <- (kombinacia-1) + u*cards[cardIdx]
          f0 <- sum(rep(0,length(kombinacia)))
          
          if(cardIdx == k ){
            f0 <- vyplata(kombinacia,cards)
          }
          #test pripustnotsti
          if(!isInInterval(minVal,maxVal,fi[uIdx])){
            #ak sa nenachadza ideme na dalsu iteraciu
            next
          }
          #test optimalnosti
          
          if(f0 + eval(createSelectionForMatrice("V",c("cardIdx+1", fi+1), "")) >= eval(createSelectionForMatrice("V",c("cardIdx", kombinacia), ""))){
            #ak nie je optimalne iterujeme dalej
            next
          }
          stringRet <- "<- f0 + "
          stringRet <- paste(stringRet,createSelectionForMatrice("V",c("cardIdx+1", fi+1), "",TRUE), sep="", collapse=NULL)
          eval(createSelectionForMatrice("V",c("cardIdx", kombinacia), stringRet))
          eval(createSelectionForMatrice("v",c("cardIdx",kombinacia), "<- 1"))
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
ret <- list(v=v,V=V,xOpt=xOpt,uOpt=uOpt)

