# Modo corrido
url = "http://www.ipeadata.gov.br/ExibeSerie.aspx?oper=exportCSVBr&serid=32237"

dados = read.csv2(url, stringsAsFactors = F, col.names = c("Data", "CDI", "Dummy"))
dados$Dummy = NULL
# names(dados)[1] = "Data"
# names(dados)[2] = "CDI"

# Modo parametrizado
idSerie = 38415
url = paste0("http://www.ipeadata.gov.br/ExibeSerie.aspx?oper=exportCSVBr&serid=", 
             idSerie)
             # "=",
             # idSerie)
dadosParametrizados = read.csv2(
  url, 
  stringsAsFactors = F,
  col.names = c("Data", "Valor", "Dummy")
)

dadosParametrizados$Dummy = NULL

# Modo função
retornaSerie = function(serieId) {
  url = paste0(
    "http://www.ipeadata.gov.br/ExibeSerie.aspx?oper=exportCSVBr&serid=", 
    idSerie
  )
  
  dadosFuncao = read.csv2(
    url, 
    stringsAsFactors = F,
    col.names = c("Data", "Valor", "Dummy")
  )
  
  dadosFuncao$Dummy = NULL
  return(dadosFuncao)
}
