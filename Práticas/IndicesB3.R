# Código corrido
date = as.Date("2020-01-02")
url = format(date, "ftp://ftp.bmf.com.br/IndicadoresEconomicos/ID%y%m%d.ex_")
arquivo = format(date, "Downloads/ID%y%m%d.exe")

download.file(url = url, destfile = arquivo, mode = "wb")
files = unzip(zipfile = arquivo, exdir = "Downloads")

layout = read.csv2("Layout/layout_bmfindic.csv", stringsAsFactors = F)

dados = read.fwf(
  file = files,
  widths = layout$tamanho,
  col.names = layout$campo,
  stringsAsFactors = F,
  strip.white = T
)

dados$DT_ARQUIVO = as.Date(as.character(dados$DT_ARQUIVO), "%Y%m%d")
dados$VL_INDICADOR = dados$VL_INDICADOR/(10^dados$NUM_CASAS_DECIMAIS)

# Função
lerBmfPorData = function(date) {
  stopifnot(length(date) == 1)
  
  if(class(date) != "Date") {
    date = as.Date(date, "%Y-%m-%d")
  }
  
  url = format(date, "ftp://ftp.bmf.com.br/IndicadoresEconomicos/ID%y%m%d.ex_")
  arquivo = format(date, "Downloads/ID%y%m%d.exe")
  
  download.file(url = url, destfile = arquivo, mode = "wb")
  files = unzip(zipfile = arquivo, exdir = "Downloads")
  
  layout = read.csv2("Layout/layout_bmfindic.csv", stringsAsFactors = F)
  
  dados = read.fwf(
    file = files,
    widths = layout$tamanho,
    col.names = layout$campo,
    stringsAsFactors = F,
    strip.white = T
  )
  
  file.remove(files)
  
  dados$DT_ARQUIVO = as.Date(as.character(dados$DT_ARQUIVO), "%Y%m%d")
  dados$VL_INDICADOR = dados$VL_INDICADOR/(10^dados$NUM_CASAS_DECIMAIS)
  dados$NUM_CASAS_DECIMAIS = NULL
  
  return(dados[dados$DT_ARQUIVO == date,])
  
}

lerBmfPorData("2018-07-16")
