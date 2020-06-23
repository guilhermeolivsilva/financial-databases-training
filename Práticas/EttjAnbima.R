library(httr)
library(XML)

url = "https://www.anbima.com.br/informacoes/est-termo/CZ-down.asp"

req = POST(
  url = url,
  encode = "form",
  body = list(
    Idioma = "PT",
    Dt_ref = "02/08/2018",
    saida = "xml"
  )
)

