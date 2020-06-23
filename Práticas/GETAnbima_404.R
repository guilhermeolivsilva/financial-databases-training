# date = Sys.Date() - 1
  
anbimaMercSec = function(date) {
  stopifnot(length(date) == 1)
  
  if(class(date) != "Date") {
    if(class(date) == "int") {
      date = as.Date(as.character(date), "%Y-%m-%d")
    }
    if(class(date) == "character") {
      date = as.Date(date, "%Y-%m-%d")
    } else {
      return(NULL)
    }
  }

  url = format(date, "https://www.anbima.com.br/informacoes/merc-sec/arqs/ms%y%m%d.txt")
  
  dados = read.table(
    file = url,
    header = T,
    sep = "@",
    dec = ",",
    skip = 2,
    stringsAsFactors = F,
    na.strings = "--"
  )
  
  # Adicionar conversão de datas para o tipo adequado
  
  return(dados)
}
  