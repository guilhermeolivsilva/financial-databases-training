library(stringr)

ler.projecoes.igp.anbima = function(){
  
  # bugfix 03/05/2020: retirando \n e \s do pattern
  pattern = paste0(
    "<td [^>]*>(\\w+ de \\d+)</td>", # mes de coleta
    "<td [^>]*>(\\d{2}/\\d{2}/\\d{2,4})</td>", # data de projecao
    "<td [^>]*><strong>([\\d,-]*)</strong></td>", # projecao
    "<td [^>]*>(\\d{2}/\\d{2}/\\d{2,4})</td>") # validade
  
  url = "http://www.anbima.com.br/pt_br/informar/estatisticas/precos-e-indices/projecao-de-inflacao-gp-m.htm"
  
  txt = try(readLines(url, warn = F))
  if(is(txt, "try-error")) stop("erro ao ler projecoes IGP ANBIMA")
  
  #s = str_flatten(txt, "\n")
  s = paste(txt, collapse = "\n")
  s = str_replace_all(s, "(</?strong>)\\s*\\1", "\\1") # tratamento para tirar <strong>'s
  # redundantes.
  # P.Ex: "<strong><strong>" vira "<strong>"
  # e "</strong></strong>" vira "</strong>"
  
  s = str_replace_all(s, "</?p>", "")              # bugfix 03/05/2020: retirando <p> e </p>
  
  m = str_match_all(string = s, pattern = pattern)[[1]]
  
  dados = m[,-1]
  colnames(dados) = c("mes.coleta", "data", "projecao", "validade")
  dados = as.data.frame(dados, stringsAsFactors = F)
  dados$identificador = c("IGPM 1", "IGPM 2", "IGPM 3", "IPCA 1", "IPCA 2")
  
  dados$data = as.Date(dados$data, "%d/%m/%y")
  dados$validade = as.Date(dados$validade, "%d/%m/%y")
  
  dados$projecao = suppressWarnings(as.numeric(gsub(",", ".", dados$projecao)))
  
  dados
  
}