source('hlavneZadanie.r')
source('calcTime.r')
source('nadstavboveSimulacie.r')
source('algoritmusOndruskovec3000.r')
source('nadstavbaOptimalizaciaPoctuKarticiek.r')
# Ak chceme vidiet definiciu nejakej funkcie vyuzivanu v tomto file -> CTRL + klik na nu 

# prevolanim funkcie solveCardsSeparation(cards,showMatrices),  nachadzajuci sa v subore hlavneZadanie.r dostavame riesenie poovodne zadanej ulohy 
# kde mame rozdelit karticky podla ich hodnot na dve kopy tak aby ich rozdiel na konci rozdelenia bol co najmensi. Dodatocny popis postupu algoritmu je v danom subore
#_________________POPIS FUNKCIE NA PREVOLAVANIE__________________________________________________________________________________________
# argument cards - vektor ciselnych hodnot kariet, pre ktore ma byt algoritmus aplikovany napr c(1,2,3,4,5)
# argument showMatrices - boolean hodnota, ktora indikuje ci ma funkcia vratit aj hodnotu vyplatovej matice a spatnej vazby napr. TRUE -> defaultne je na FALSE
# funkcia vzdy returnuje: xopt,uOpt  pripadne v,V ak je showMatrices==TRUE
cards <- c(10, 1, 30, 8, 5, 7, 3, 4, 2, 3, 1, 5)
return <- solveCardsSeparation(cards)
#_________________________________________________________________________________________________________________________________________
# Teraz budeme spustat rozne simulacie, v ktorych bude pocet karticiek inkrementovat a ich hodnoty
# budu nahodne generovane z rovnomerneho rozdelenia (pre nejaky fixny interval) a nasledne zaokruhlene nadol.
# Zacneme s dvoma kartickami a tam spustime napr 100 simulacii, v kazdej z nich sa pre obe karticky 
# nahodne vygeneruje nejaka hodnota, zaznamename celkovu dlzku simulacie + ci sa podarilo karticky rozdelit
# na dve kopky s rovnakymi hodnotami.
# Na konci sformujeme vysledky typu : kolko trva hra pre nejaky pocet karticiek.
# Nastavime aby sa karticky generovali len z inetrvalu (1:30), tento interval je volitelny a vsak jeho nafuknutie
# zapricini dlhsie posobenie algoritmu + ine vysledky simulacie 
# pre n=100, to trva cca 3898.784 sec
return2 <- simulationOfCardsIncrement(100,1,30)
# Vysledky simulacie
#return2$equalSubsets <- c(2,6,7,16,20,43,45,49,54,51,45,56,51,48,50,56,42,52,43,50,49,52,52,44,56,50,57,45,50,44,44,45,43,47,50,48,48,37,48,50,54,45,50,54,50,54,48,53,51,50,55,50,54,48,53,59,41,40,48,45,58,54,51,66,50,49,46,47,46,52,53,54,57,53,51,51,47,46,50,52,57,49,51,46,54,53,52,49,47,50,48,46,53,39,53,59,60,49,56)
#return2$timeRecords: <- c(0.0009875011,0.0011968756,0.0020156932,0.0029627895,0.0044748306,0.0057054114,0.0077383304,0.0094458389,0.0114806151,0.0143635845,0.0164774942,0.0196306729,0.0232179570,0.0262819386,0.0297953081,0.0323790932,0.0359996939,0.0413864946,0.0466714191,0.0496034098,0.0554474545,0.0602769685,0.0667600536,0.0699811625,0.0761745906,0.0829411340,0.0894022107,0.0945483518,0.1024374413,0.1091204262,0.1150263214,0.1223362684,0.1323213243,0.1386750174,0.1443929386,0.1618116212,0.1602506709,0.1701735234,0.1775653195,0.1929961252,0.1981862617,0.2097892952,0.2188009810,0.2290839481,0.2364946127,0.2714862990,0.2772607660,0.2817893934,0.2916381764,0.2979484534,0.3131509042,0.3178090549,0.3268839407,0.3460949731,0.3610127592,0.3747623324,0.4218893576,0.4006289673,0.4054148865,0.4430832648,0.4620868754,0.4673195577,0.4779331255,0.5137790203,0.4944499612,0.5097688985,0.5255872631,0.5583546495,0.5674001455,0.5785809207,0.5833282137,0.6259813166,0.6378407001,0.6726203537,0.6795112896,0.6981220102,0.7248235178,0.7201261997,0.7156209445,0.7427794480,0.7484947586,0.7833221221,0.7922729492,0.8094278789,0.8373285532,0.8841257405,0.8828628731,0.8904146457,0.9259297180,0.9970118713,0.9787363195,0.9914941883,1.0033658981,1.0197561979,1.0583628106,1.0742751861,1.1319405484,1.1387415910,1.1563011384)
# Graficke zobrazenie simulacie
#plot(return2$timeRecords, type="o", col="red", lwd=1.2, xlab="Pocet kariet", ylab=c('mean(dlzka algoritmu v sec)'))
# plot(return2$equalSubsets, type="o",xlim=c(1,100), col="red", lwd=1.2, xlab="Pocet kariet", ylab=c('pocet spravodlivyh rozdeleni'))
# abline(h=c(40,50,60), col=c("cadetblue2","blue","cadetblue2"), lwd=c(1,1.2,1))
# plot(return2$diffs, type="o",xlim=c(1,100),ylim=c(0,5), col="red", lwd=1.2, xlab="Pocet kariet", ylab=c('vypocet diff'))
# abline(h=c(.4,0.5,.6), col=c("cadetblue2","blue","cadetblue2"), lwd=c(1,1.2,1))
# plot(return2$fairDiffs, type="o",xlim=c(1,100),ylim=c(0,10), col="red", lwd=1.2, xlab="Pocet kariet", ylab=c('vypocet diff'))
# abline(h=c(0), col=c("blue"), lwd=c(1.2))
#_________________________________________________________________________________________________________________________________________
#Teraz budeme porovnavat nas rychly a vsak nie 100% uspesny algoritmus ondruskovec3000 s algoritmom dynamickeho programovania a spravime z 
# toho nejaky zaver
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
# Este porovname nejake extremne hodnoty, 200,300,400,500,600,700,800,900,1000
return4 <- extremCardQuantitySimulation() 
# v extremnych hodnotach je vidiet rozdiel este silnejsie
# par(mfrow=c(2,1))
# plot(return4$ondruskovedTimeRecords,type="l", col="blue", lwd=2, xlab="(Pocet kariet)*100", ylab=c('mean(dlzka algoritmu v sec)'),main="Rychlost ondruskovca3000")
# plot(return4$ondruskovedTimeRecords, ylim=c(0,150),type="l", col="blue", lwd=2, xlab="(Pocet kariet)*100", ylab=c('mean(dlzka algoritmu v sec)'),main="Rychlost ondruskovca3000 vs dap algoritmu")
# lines(return4$dapTimeRecords, type="l", col="red", lwd=2)
#_________________________________________________________________________________________________________________________________________
# Teraz skusime pre dap algoritmus generovat karty z velkeho rozsahu 1-500, ocakavame, ze spravodlive delenie zacne byt od vacsieho poctu kariet ako v simulaciach, kde sa generovali hodnoty od 1 po 30, kvoli tomu nebudeme, pre kazdy pocet robit 100 simulacii ale len 3
return5 <- simulationOfCardsIncrement(30,1,500,3)
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
return6 <- solveCardsSeparationByValueAndQuantity(cards2) # tu to spravodlivo rozdeli podla poctu aj hodnot tj ako bolo vysie ocakavene rozdelenie
# Predstavme si este jeden pripad, majme karty dane ako:
cards3 <- c(1,1,1,1,1,1,2,9)
# povodny algoritmus vyriesi ulohu nasledovne
solveCardsSeparation(cards3) # zoberie prvych 7 kariet na jednu kopku a posledne dve (2ku a 9ku) na druhu aby bol rozdiel co najmensi
# algoritmus ktory riesi aj optimalizaciu pocetnosti
solveCardsSeparationByValueAndQuantity(cards3) # zoberie 5 jednotiek a 1 dvojku na jednu kopu a 1 jednotku + 1 deviatku na druhu, citit ze aj tak rozdiel hodnot kariet je silnejsii ako rozdiel pocetnosti kariet -> (x - sum(cards))^2 >= (z - length(cards))^2
# algoritmus je spraveny tak ze vieme pridat vahu bud rozdielu hodnot kartiet alebo rozdielu poctu kariet
# najprv pridajme vacsiu vahu rozdielu hodnot kariet
solveCardsSeparationByValueAndQuantity(cards3,2,1) # dostavame vysledok ako v povodnom algoritme  solveCardsSeparation(cards3)
# pridajme vahu rozdielu poctu kariet
solveCardsSeparationByValueAndQuantity(cards3,1,2) # rozdiel poctu kariet prebija rozdiel hodnot kariet a teda 4 jednotky a 1 dvojku dava na prvu kopu a 2 jednotky + 1 deviatku na druhu kopu
# pridajme este vacsiu vahu rozdielu poctu kariet aby sme docielili rovnost poctu kariet
solveCardsSeparationByValueAndQuantity(cards3,1,3) # docielili sme rovnost poctu kariet. Je dobre si vsimnut ze to rozdelilo aj tak takym sposobom aby rozdiel hodnot kariet bol zaroven co najmensi (vybralo kartu s hodnotou 2 na prvu kopu)


