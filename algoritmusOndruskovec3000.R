#algoritmus bol inspirovany petrom ondruskom. Rychly pretestovany na vela hodnotach a vsak nema 100 % uspesnot tj.
# ked uloha dynamickeho programovania najde najoptimalnejsie riesenie nemusi nutne uspiet aj ondruskovec3000 priklad takeho vstupu -> c(1,2,3,4,6) kde optimalne rozdelenie je na (1,3,4) a (2,6) ale ondrusmovec ho tak nedokaze rozdelit kvoli svojim "retazovym" obmedzeniam
# Efektivita tohto algoritmu by mala presvitat hlavne pri velkom pocte kariet (kludne s velkymi hodnotami), kde sa ocakava ze rozdelenie na 
# dve particie moze nastat s viacerymi moznostami.
# vysvetleniee funkcie nizsie v komentoch

# return type
#  cards1$cardsValues - hodnoty karticiek na prvej kopke
#  cards1$cardsSum - sucet hodnot karticiek na prvej kope
#  cards2$cardsValues - hodnoty karticiek na druhej kopke
#  cards2$cardsSum - sucet hodnot karticiek na druhej kope
ondruskovec3000 <- function(cards) {
  # dlzka kariet
  n<- length(cards)
  cards <- sort(cards)
  # do akeho ciselka sa chceme trafit
  target <- sum(cards)/2
  # dolezity krok vytvorenie matice "matrice" kde hodnota matrice[i,j] je vlastne  sum(cards[i:j])
  # teda skusa vytvorit sucet cez jeden retazec nascitanych kariet a vsak nie cez viacej retazcov naraz (to je dovod preco zvoli niekedy
  # menej optimalny / nenanajde ziaden optimalny vysledok) napr cards <- c(1,2,3,4,5,6), pren nevytvori retazce 1,2 a  4,5 sucasne, miesto
  # toho vyskusa vytvorit vsetky mozne retazce s jednotkovou dlzkou. ak si chceme vyskusat ako taka matica vyzera tak nizsie je na to cisto urcena funkcia matriceTest
  matrice <- matrix(apply(expand.grid(1:n, 1:n), 1, function(y) sum(cards[y[2]:y[1]])), n, n)
  # pripustny rozdiel medzi nascitanymi suctami a targetom, zacina na nule -> najvacsie optimum ktore chceme
  i <- 0
  # idx bude premenna, do ktorej napchame optimalny vysledok typu [i,j] teda index v matici kde matrice[i,j]
  idx <- c()
  # ako su jednotlive sucty vzdialene v abs hodnote od premennej target. floor je na zabezpecenie v pripade necelociselnosti premennej target
  absMatrice <- floor(abs(matrice - target))
  # v cykle sme pokial idx nebude napchaty nejakou hodnotou alebo pokial i nie je rovne suctu kartam
  while(i<sum(cards) && length(idx)==0){
    # zistime indexy ->  absMatrice[i,j] , pre ktore je rozdiel hodnot matice a targetValue (sum(cards)/2) == i , i zacina na nule 
    idx <- which(absMatrice == i, arr.ind = TRUE)
    i <- i + 1
  }
  # ak sme sme vysli z cyklu, checkneme ci nenastala moznost, ze sa i dostalo az po koniec a idx nebolo naplnene, v takom pripade vraciame NULL hodnoty
  if(length(idx)==0){
    return(list(cards1=NULL,cards2=NULL))
  }
  # zistime indexy  pre optimalne karty z matice
  minIdx <- min(idx[1,])
  maxIdx <- max(idx[1,])
  #vratime dva objekty , pre prvu kopku a druhu kopku
  return(list(
    cards1=list(
      cardsValues=cards[minIdx:maxIdx],
      cardsSum=sum(cards[minIdx:maxIdx])
      ),
    cards2=list(
      cardsValues=cards[-(minIdx:maxIdx)],
      cardsSum=sum(cards[-(minIdx:maxIdx)])
    )
  ))
}

# funkcia na testovanie return typu -> matrice[i,j]= sum(cards[i,j])
# cards - vektor kariet
matriceTest <- function(cards){
  n<- length(cards)
  return(matrix(apply(expand.grid(1:n, 1:n), 1, function(y) sum(cards[y[2]:y[1]])), n, n))
}





