# pocita casovu dlzku medzi zaciatkom a koncom stavu
# func - funkcia, ktora sa prevola, ktora pozaduje ako vstupny argument vektor kariet
# cards - vektor kariet
# return type
#  output - output povodnej funkcie "func"
#  totalTime - celkovy cas za ktory skoncila funkcia "func"
calculateTime <- function(func,cards){
  t1 <- Sys.time()
  output <- func(cards)
  totalTime <- Sys.time() - t1
  return(list(output=output,totalTime=totalTime))
}
