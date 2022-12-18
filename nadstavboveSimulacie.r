source('hlavneZadanie.r')
source('calcTime.r')
source('algoritmusOndruskovec3000.r')
# simulacie, ktora sluzi na zaznam statistik pri inkremente poctu kariet pre povodny algoritmus dynamickeho programovania
simulationOfCardsIncrement <- function(n,min,max,simNum=NULL){
    if(is.null(simNum)){
      simNum <- 100
    }
    ret <- NULL
    ret$equalSubsets <- c()
    ret$timeRecords <- c()
    ret$diffs <- c()
  # pre kazdy rozny pocet karticiek
  for(i in 2:n){
    equalSubsets <- 0
    timesRecords <- c()
    diffs <- c()
    #sa 100krat sa vykona dana simulacia a zaznamenaju vysledky
    for(j in 1:simNum){
      equalSubset <- FALSE
      cards <- ceiling(runif(i,min-1,max))
      timeReturn <- calculateTime(solveCardsSeparation,cards)
      xOpt <-  timeReturn$output$xOpt[length(timeReturn$output$xOpt)]
      diff <- timeReturn$output$diff
      if(xOpt==sum(cards)/2){
        equalSubsets <- equalSubsets+1
      }
      timesRecords <- append(timesRecords,timeReturn$totalTime)
      diffs <- append(diffs,diff)
    }
    ret$equalSubsets <- append(ret$equalSubsets,equalSubsets)
    ret$timeRecords <- append(ret$timeRecords,mean(timesRecords))
    ret$diffs <- append(ret$diffs,mean(diffs))
    print(i)
  }
    return(ret)
}

# simulacia, ktora sluzi na vzajomne porovnanie algoritmu dynamickeho programovania a algoritmu odnruskovca3000
simulationOfAlgorithmComparision <- function(n,min,max){
  ret <- NULL
  ret$dap$timeRecords <- c()
  ret$dap$diffs <- c()
  
  ret$ondruskovec3000$timeRecords <- c()
  ret$ondruskovec3000$wrongResults$cardNum <- c()
  ret$ondruskovec3000$wrongResults$count <- 0
  ret$ondruskovec3000$wrongResults$dapDiffs <- c()
  ret$ondruskovec3000$wrongResults$actualDiffs <- c()
  for(i in 2:n){
    print(i)
    dapTimeRecords <- c()
    dapDiffs <- c()
    
    ondurskovec3000TimeRecords <- c()
    ondruskovec3000Diffs <- c()
    
    for(j in 1:100){
      cards <- ceiling(runif(i,min-1,max))
      timeReturn1 <- calculateTime(solveCardsSeparation,cards)
      timeReturn2 <- calculateTime(ondruskovec3000,cards)
      # ak nenaslo optimalne riesenie, zaznamenajme statistiky a skipnime iteraciu
      if(is.null(timeReturn2$output$cards1)){
        ret$ondruskovec3000$wrongResults$cardNum <-  append(ret$ondruskovec3000$wrongResults$cardNum ,i)
        ret$ondruskovec3000$wrongResults$count <-  ret$ondruskovec3000$wrongResults$count + 1
        ret$ondruskovec3000$wrongResults$dapDiffs <-  append(ret$ondruskovec3000$wrongResults$dapDiffs, timeReturn1$output$diff)
        ret$ondruskovec3000$wrongResults$actualDiffs <- append(ret$ondruskovec3000$wrongResults$actualDiffs,NULL)
        next
      }
      ondruskovec3000Diff <- abs(timeReturn2$output$cards2$cardsSum-timeReturn2$output$cards1$cardsSum)
      # v pripade ak diffy nie su identicke, tak ich zaznamename a pokracujme dalej bez skipnutia iteracie
      if(timeReturn1$output$diff != ondruskovec3000Diff){
        ret$ondruskovec3000$wrongResults$cardNum <-  append(ret$ondruskovec3000$wrongResults$cardNum ,i)
        ret$ondruskovec3000$wrongResults$count <-  ret$ondruskovec3000$wrongResults$count + 1
        ret$ondruskovec3000$wrongResults$dapDiffs <-  append(ret$ondruskovec3000$wrongResults$dapDiffs, timeReturn1$output$diff)
        ret$ondruskovec3000$wrongResults$actualDiffs <- append(ret$ondruskovec3000$wrongResults$actualDiffs,ondruskovec3000Diff)
      }
      # dalej zaznamenavame bezne statistiky ako v predoslom algoritme 
      dapTimeRecords <- append(dapTimeRecords,timeReturn1$totalTime)
      ondurskovec3000TimeRecords <- append(ondurskovec3000TimeRecords,timeReturn2$totalTime)
      
      
    }
    ret$dap$timeRecords<- append(ret$dap$timeRecords,mean(dapTimeRecords))
    ret$ondruskovec3000$timeRecords<- append(ret$ondruskovec3000$timeRecords,mean(ondurskovec3000TimeRecords))
  }
  return(ret)
  
}
# simulacie pre vypocet extremnych hodnot kariet
extremCardQuantitySimulation <- function(){
  ret <- NULL
  ret$ondruskovedTimeRecords <- c()
  ret$dapTimeRecords <- c()
  for(i in 1:10){
    cards <- ceiling(runif(i*100,1-1,30))
    timeReturn1 <- calculateTime(solveCardsSeparation,cards)
    timeReturn2 <- calculateTime(ondruskovec3000,cards)
    ret$dapTimeRecords <- append( ret$dapTimeRecords, timeReturn1$totalTime)
    ret$ondruskovedTimeRecords <- append(ret$ondruskovedTimeRecords, timeReturn2$totalTime)
    print(i)
  }
  for(i in 11:15){
    cards <- ceiling(runif(i*100,1-1,30))
    timeReturn2 <- calculateTime(ondruskovec3000,cards)
    ret$ondruskovedTimeRecords <- append(ret$ondruskovedTimeRecords, timeReturn2$totalTime)
    print(i)
  }
  
  return(ret)
  
}

