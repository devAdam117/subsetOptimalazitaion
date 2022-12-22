source('hlavneZadanie.r')
source('calcTime.r')
source('nadstavboveSimulacie.r')
source('algoritmusOndruskovec3000.r')
source('nadstavbaOptimalizaciaPoctuKarticiek.r')
# Ak chceme vidiet definiciu nejakej funkcie vyuzivanu v tomto file -> CTRL + klik na nu , zobrazi sa jej implement + vnutorny comment co a ako funguje. Ak chceme vidiet aj popisane vstupy/vystupy treba otvorit dany file.
# Prvych par riadkov sluzi na import danych funkci, ktore sa tu budu prevolavat. Pre ich importnutie, je potrebne v rstudiu nastavit: session -> set working directory -> to source file location

# prevolanim funkcie solveCardsSeparation(cards,showMatrices),  nachadzajuci sa v subore hlavneZadanie.r dostavame riesenie poovodne zadanej ulohy 
# kde mame rozdelit karticky podla ich hodnot na dve kopy tak aby ich rozdiel na konci rozdelenia bol co najmensi. Dodatocny popis postupu algoritmu je v danom subore
# _________________POPIS FUNKCIE NA PREVOLAVANIE__________________________________________________________________________________________
# argument cards - vektor ciselnych hodnot kariet, pre ktore ma byt algoritmus aplikovany napr c(1,2,3,4,5)
# argument showMatrices - boolean hodnota, ktora indikuje ci ma funkcia vratit aj hodnotu vyplatovej matice a spatnej vazby napr. TRUE -> defaultne je na FALSE
# funkcia vzdy returnuje: xopt,uOpt  pripadne v,V ak je showMatrices==TRUE
cards <- c(10, 1, 30, 8, 5, 7, 3, 4, 2, 3, 1, 5)
return <- solveCardsSeparation(cards)

# _________________________________________________________________________________________________________________________________________
# Teraz budeme inkrementovat pocet karticiek od 2 po 100. Pre kazdy pocet sa spusti 100 simulacii a z nich ziskame potrebne informacie.
# Zacneme s dvoma kartickami a tam spustime 100 simulacii, v kazdej z nich sa pre obe karticky 
# nahodne vygeneruje nejaka hodnota, zaznamename celkovu dlzku simulacie + ci sa podarilo karticky rozdelit
# na dve kopky s rovnakymi hodnotami.
# Na konci sformujeme vysledky typu : kolko trva hra pre nejaky pocet karticiek.
# Nastavime aby sa karticky generovali len z inetrvalu (1:30), tento interval je volitelny a vsak jeho nafuknutie
# zapricini dlhsie posobenie algoritmu + ine vysledky simulacie 
# simulationOfCardsIncrement(100,1,30) -> pre n=100, to trva cca 3898.784 sec
# ak by sme chceli mat vysledok hned po ruke bez cakania, tak staci prevolat:  return2 <??? readRDS("return2.rds" ) (fixne data, ktore sme ziskali, ked sme my nechali zbehnut simulaciu)
# _________________POPIS FUNKCIE NA PREVOLAVANIE__________________________________________________________________________________________
# vysvetlenie return typu je vo file nadstavboveSimulacie.r
# simulationOfCardsIncrement(n,min,max,simNum)
# n - do akeho poctu karticiek chcieme viest simulacie
# min, max-  z akeho intervalu maju byt generovane hodnoty karticiek
# simNum - kolko simulacii mazbehnut pre kazdy pocet karticiek
return2 <- simulationOfCardsIncrement(100,1,30)
# Graficke zobrazenie simulacie
# plot(return2$timeRecords, type="o", col="red", lwd=1.2, xlab="Pocet kariet", ylab=c('mean(dlzka algoritmu v sec)'))
# plot(return2$equalSubsets, type="o",xlim=c(1,100), col="red", lwd=1.2, xlab="Pocet kariet", ylab=c('pocet spravodlivyh rozdeleni'))
# abline(h=c(40,50,60), col=c("cadetblue2","blue","cadetblue2"), lwd=c(1,1.2,1))
# plot(return2$diffs, type="o",xlim=c(1,100),ylim=c(0,5), col="red", lwd=1.2, xlab="Pocet kariet", ylab=c('vypocet diff'))
# abline(h=c(.4,0.5,.6), col=c("cadetblue2","blue","cadetblue2"), lwd=c(1,1.2,1))
# plot(return2$fairDiffs, type="o",xlim=c(1,100),ylim=c(0,10), col="red", lwd=1.2, xlab="Pocet kariet", ylab=c('vypocet diff'))
# abline(h=c(0), col=c("blue"), lwd=c(1.2))
#_________________________________________________________________________________________________________________________________________
#Teraz budeme porovnavat nas rychly a vsak nie 100% uspesny algoritmus ondruskovec3000 s algoritmom dynamickeho programovania a spravime z 
# toho nejaky zaver
# ak by sme chceli mat vysledok hned po ruke bez cakania, tak staci prevolat:  return3 <??? readRDS("return3.rds" ) (fixne data, ktore sme ziskali, ked sme my nechali zbehnut simulaciu)
# _________________POPIS FUNKCIE NA PREVOLAVANIE__________________________________________________________________________________________
# vysvetlenie return typu je vo file nadstavboveSimulacie.r
# simulationOfAlgorithmComparision(n,min,max)
# n - do akeho poctu karticiek chcieme viest simulacie
# min, max-  z akeho intervalu maju byt generovane hodnoty karticiek
return3 <- simulationOfAlgorithmComparision(100,1,30)
# Pocet nespravnych vysledkov a kolko z nich bolo pre aky pocet kariet
# numOfWorseResults <- return3$ondruskovec3000$wrongResults$count -> 1774
# h1 <- hist(return3$ondruskovec3000$wrongResults$cardNum, breaks=25, xlab = 'Pocet kariet', ylab='Pocet nespravnych vysledkov', ylim=c(0,380), col="chocolate", border="pink", main=NULL)
# text(h1$mids,h1$counts,labels=h1$counts, adj=c(0.5, -0.5),cex=1.15)
# V akych hodnotach byval nespravny vysledok ondruskovca3000 od dap vysledku algoritmu + pocetnost k nim
# h2 <- hist(abs(return3$ondruskovec3000$wrongResults$dapDiffs-return3$ondruskovec3000$wrongResults$actualDiffs), breaks=12, xlab = 'abs(dapResult - ondruskovec3000Result)', ylab='Pocet takych vysledkov', ylim=c(0,1500), col="chocolate", border="pink", main=NULL)
# text(h2$mids,h2$counts,labels=h2$counts, adj=c(0.5, -0.5),cex=1.15)
# mean(return3$ondruskovec3000$wrongResults$dapDiffs) -> 0.3568207
# mean(return3$ondruskovec3000$wrongResults$actualDiffs) -> 3.020857
# V ostatnych (9700-1774) pripadoch, dal algoritmus ondurskovec3000 rovnaky vysledok ako dap algoritmus, takze nakoniec porovname casovu zatazenost od velkosti vstupnych argumentov (kariet). Tu su casy pri dap rychlejsie ako v returne2 kvoli tomu ze tento process bezal na inom pc
# par(mfrow=c(2,1))
# plot(return3$ondruskovec3000$timeRecords,type="l", col="blue", lwd=2, xlab="Pocet kariet", ylab=c('mean(dlzka algoritmu v sec)'),main="Rychlost ondruskovca3000")
# plot(return3$ondruskovec3000$timeRecords, ylim=c(0,.5),type="l", col="blue", lwd=2, xlab="Pocet kariet", ylab=c('mean(dlzka algoritmu v sec)'),main="Rychlost ondruskovca3000 vs dap algoritmu")
# lines(return3$dap$timeRecords, type="l", col="red", lwd=2)
#_________________________________________________________________________________________________________________________________________
# Este porovname nejake extremne hodnoty casov pre vacsie pocty karticiek -> 200,300,400,500,600,700,800,900,1000
return4 <- extremCardQuantitySimulation() 
# v extremnych hodnotach je vidiet rozdiel este silnejsie
# par(mfrow=c(2,1))
# plot(return4$ondruskovedTimeRecords,type="l", col="blue", lwd=2, xlab="(Pocet kariet)*100", ylab=c('mean(dlzka algoritmu v sec)'),main="Rychlost ondruskovca3000")
# plot(return4$ondruskovedTimeRecords, ylim=c(0,150),type="l", col="blue", lwd=2, xlab="(Pocet kariet)*100", ylab=c('mean(dlzka algoritmu v sec)'),main="Rychlost ondruskovca3000 vs dap algoritmu")
# lines(return4$dapTimeRecords, type="l", col="red", lwd=2)
#_________________________________________________________________________________________________________________________________________
# Teraz skusime pre dap algoritmus generovat karty z velkeho rozsahu 1-500, ocakavame, ze spravodlive delenie zacne byt od vacsieho poctu kariet ako v simulaciach, kde sa generovali hodnoty od 1 po 30, kvoli tomu nebudeme, pre kazdy pocet robit 100 simulacii ale len 10
return5 <- simulationOfCardsIncrement(40,1,500,10)
# par(mfrow=c(1,1))
# plot(return5$timeRecords,type="l", col="blue", lwd=2, xlab="Pocet kariet", ylab=c('mean(dlzka algoritmu v sec)')")
# par(mfrow=c(2,2))
# plot(return5$diffs, type="o",xlim=c(1,40),ylim=c(0,220), col="red", lwd=1.2, xlab="Pocet kariet", ylab=c('vypocet diff'),main="Vypocet diff")
# plot(return5$diffs, type="o",xlim=c(6,40),ylim=c(0,2), col="red", lwd=1.2, xlab="Pocet kariet", ylab=c('vypocet diff'),main="Vypocet diff")
# abline(h=c(0), col=c("blue"), lwd=c(1.2))
# plot(return5$fairDiffs, type="o",xlim=c(1,40),ylim=c(0,250), col="red", lwd=1.2, xlab="Pocet kariet", ylab=c('vypocet diff'),main="Vypocet diff, ked sum(cards) je delitelne 2")
# plot(return5$fairDiffs, type="o",xlim=c(6,40),ylim=c(0,2), col="red", lwd=1.2, xlab="Pocet kariet", ylab=c('vypocet diff'),main="Vypocet diff, ked sum(cards) je delitelne 2")
# abline(h=c(0), col=c("blue"), lwd=c(1.2))
#_________________________________________________________________________________________________________________________________________
# Este urobime jednu nadstavbu a to taku, ze modifikujeme povodny dap algoritmus tak aby sme neoptimalizovali len hodnoty karticiek ale aj pocet. Teda chceme aby hodnoty a aj pocet bol co najspravodlivejsi. Je zrejme ze v payoff funkcii
# budu hodnoty (x - sum(cards))^2 >= (z - length(cards))^2 a hodnoty budu prebijat istym sposobom pocet, preto sme im pridelili aj vahy
cards2 <- c(1,1,1,1,2,2) # ocakavane rozdelenie -> prvaKopka : 1,1,2 , druhaKopka: 1,1,2
solveCardsSeparation(cards2) # -> povodna uloha zoberie prve 4 hodnoty a da ich na prvu kopku a posledne 2 a da ich na druhu
# _________________POPIS FUNKCIE NA PREVOLAVANIE__________________________________________________________________________________________
# vysvetlenie return typu je vo file nadstavbaOptimalizaciaPoctuKarticiek.r
# solveCardsSeparationByValueAndQuantity(cards,valueWeight=1,quantityWeight=1,showMatrices=FALSE)
# cards - vektor kariet
# valueWeigth - vaha, ktora sa viacej priklana na vysledok rozdielu hodnot karticiek v dvhoch kopkach, default = 1
# quantityWeight - vaha, ktora sa viacej priklana na vysledok rozdielu pocetnosti karticke v dvhoch kopkach, default = 1
# showMatrices - ci ma vypisat matice v a V, default = FALSE
return6 <- solveCardsSeparationByValueAndQuantity(cards2) # tu to spravodlivo rozdeli podla poctu aj hodnot tj ako bolo vysie ocakavene rozdelenie
# Predstavme si este jeden pripad, majme karty dane ako:
cards3 <- c(1,1,1,1,1,1,2,9)
# povodny algoritmus vyriesi ulohu nasledovne
solveCardsSeparation(cards3) # zoberie prvych 7 kariet na jednu kopku a poslednu (9ku) na druhu aby bol rozdiel hodnot co najmensi
# algoritmus ktory riesi aj optimalizaciu pocetnosti
solveCardsSeparationByValueAndQuantity(cards3) # zoberie 5 jednotiek a 1 dvojku na jednu kopu a 1 jednotku + 1 deviatku na druhu, citit ze aj tak rozdiel hodnot kariet je silnejsii ako rozdiel pocetnosti kariet -> (x - sum(cards))^2 >= (z - length(cards))^2
# algoritmus je spraveny tak ze vieme pridat vahu bud rozdielu hodnot kartiet alebo rozdielu poctu kariet
# najprv pridajme vacsiu vahu rozdielu hodnot kariet
solveCardsSeparationByValueAndQuantity(cards3,3,1) # dostavame vysledok ako v povodnom algoritme  solveCardsSeparation(cards3)
# pridajme vahu rozdielu poctu kariet
solveCardsSeparationByValueAndQuantity(cards3,1,2) # rozdiel poctu kariet prebija rozdiel hodnot kariet a teda 4 jednotky a 1 dvojku dava na prvu kopu a 2 jednotky + 1 deviatku na druhu kopu
# pridajme este vacsiu vahu rozdielu poctu kariet aby sme docielili rovnost poctu kariet
solveCardsSeparationByValueAndQuantity(cards3,1,7) # docielili sme rovnost poctu kariet. Je dobre si vsimnut ze to rozdelilo aj tak takym sposobom aby rozdiel hodnot kariet bol zaroven co najmensi (vybralo kartu s hodnotou 2 na prvu kopu)


