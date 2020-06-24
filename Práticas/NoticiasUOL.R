library(stringr)

leNoticiasUol = function() {
  pattern = paste0(
    "<a href=\"([^\"]*)\" [^>]*>",              # URL
    ".*?<span [^>]*>\\s*([^<]*)\\s*</span>",    # Fonte
    "\\s*<h3 [^>]*>([^<]*)\\s*</h3>",           # Texto
    ".*?<time [^>]*>([\\d/]+) ([\\dh]+)"        # Data e hora
  )
  
  url = "https://economia.uol.com.br/ultimas"
  txt = readLines(url, warn = F, encoding =  "UTF-8")
  
  stringSite = str_flatten(txt, "\n")
  rawData = str_match_all(stringSite, pattern)[[1]]
  
  dados = as.data.frame(rawData[,-1], stringAsFactors = F)
  colnames(dados) = c("URL", "Fonte", "Texto", "Data", "Hora")
  dados$Data = as.Date(dados$Data, "%d/%m/%Y")
  
  return(dados)
}