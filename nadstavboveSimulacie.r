source('hlavneZadanie.r')
source('calcTime.r')
source('algoritmusOndruskovec3000.r')
# simulacie, ktora sluzi na zaznam statistik pri inkremente poctu kariet pre povodny algoritmus dynamickeho programovania
# returnu type
#  equalSubsets - kolkokrat pre pocet karticiek od 2:100 sa zo 100 simulacii podarilo rozdelit karticky na dve identicky hodnotne kopky
#  timeRecords  - priemerna dlzka casu  pre pocet karticiek od 2:100 zo 100 simulacii
#  diffs -  pre kazdy pocet kariet od 2:100 zaznamy priemernych absolutnych rozdielov medzi dvoma kopkami zo 100 simulacii
#  fairDiffs -  pre kazdy pocet kariet od 2:100 zaznamy priemernych absolutnych rozdielov medzi dvoma kopkami zo 100 simulacii iba v pripade ak je sucet kariet delitelny dvojkou
#    
simulationOfCardsIncrement <- function(n,min,max,simNum=NULL){
    if(is.null(simNum)){
      simNum <- 100
    }
    ret <- NULL
    ret$equalSubsets <- c()
    ret$timeRecords <- c()
    ret$diffs <- c()
    ret$fairDiffs <-c()
  # pre kazdy rozny pocet karticiek
  for(i in 2:n){
    equalSubsets <- 0
    timesRecords <- c()
    diffs <- c()
    fairDiffs <-c()
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
      if(!is.null(timeReturn$output$fairDiff)){
        fairDiffs<- append(fairDiffs,timeReturn$output$fairDiff)
      }
      timesRecords <- append(timesRecords,timeReturn$totalTime)
      diffs <- append(diffs,diff)
    }
    ret$equalSubsets <- append(ret$equalSubsets,equalSubsets)
    ret$timeRecords <- append(ret$timeRecords,mean(timesRecords))
    ret$diffs <- append(ret$diffs,mean(diffs))
    ret$fairDiffs <- append(ret$fairDiffs,mean(fairDiffs))
    print(i)
  }
    return(ret)
}

# simulacia, ktora sluzi na vzajomne porovnanie algoritmu dynamickeho programovania a algoritmu odnruskovca3000
# returnu type
#  ondruskovec3000$wrongResults$count - v kolkych simulaciach mal ondruskovec3000 rozny vysledok ako dap algoritmus (z celkovych 100*99)
#  ondruskovec3000$wrongResults$cardNum - v pripade rozdielneho vysledku ondruskovca3000 a dap sa v simulaciach ukladali zaznamy pri akom pocte kariet nastal rozlisny vysledok
#  ondruskovec3000$wrongResults$actualDiffs - v pripade rozdielneho vysledku ondruskovca3000 a dap sa ukladaly pre vysledky rozdelenia ondruskovca3000 absolutne rozdiely dvoch kopok
#  ondruskovec3000$wrongResults$dapDiffs - v pripade rozdielneho vysledku ondruskovca3000 a dap sa ukladaly pre vysledky rozdelenia dap absolutne rozdiely dvoch kopok
#  ondruskovec3000$timeRecords  - priemerna dlzka casu ondruskovca3000 pre pocet karticiek od 2:100 zo 100 simulacii
#  dap$timeRecords - priemerna dlzka casu dap pre pocet karticiek od 2:100 zo 100 simulacii

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

