# pocita casovu dlzku medzi zaciatkom a koncom stavu
# func - funkcia, ktora sa prevola, ktora pozaduje ako vstupny argument vektor kariet
# cards - vektor kariet
calculateTime <- function(func,cards){
  t1 <- Sys.time()
  output <- func(cards)
  totalTime <- Sys.time() - t1
  return(list(output=output,totalTime=totalTime))
}
