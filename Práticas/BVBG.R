library(XML)
library(plyr)

from.node.to.data.frame = function(bizGroup) {
  doc = xmlElementsByTagName(bizGroup, "Document", recursive = F)[[1]]
  priceReport = xmlChildren(doc)[[1]]
  tickerSymbol = xmlValue(xmlElementsByTagName(priceReport, "TckerSymb", recursive = T))
  finInstrAttributes = xmlElementsByTagName(priceReport, "finInstrAttributes", recursive = F)[[1]]
  
  node = as.data.frame(t(getChildrenStrings(finInstrAttributes)), stringsAsFactors = F)
  node$tickerSymbol = tickerSymbol
  
  return(node)
}

BvbgIndividualPorData = function(date) {
  stopifnot(length(date) == 1)
  
  if(class(date) != "Date") {
    date = as.Date(date, "%Y-%m-%d")
  }
  
  url = format(date, "ftp://ftp.bmf.com.br/IPN/TRS/BVBG.086.01/PR%y%m%d.zip")
  filename = format(date, "Downloads/PR%y%m%d.zip")
  download.file(url = url, destfile = filename)
  
  files = unzip(filename, exdir = "Downloads/BVBG")
  root = xmlRoot(xmlParse(max(files)))
  
  # NOTA: abordagem simples, mas lenta: xmlElementsByTagName(root, "PricRpt", recursive = T)  
  bizFileHdr = xmlChildren(root)[[1]]
  xchange = xmlChildren(bizFileHdr)[[1]]
  bizGroups = xmlElementsByTagName(xchange, "BizGrp", recursive = F)
  
  # 56 foi uma escolha arbitrária
  bizGroup = bizGroups[[56]]
  
  doc = xmlElementsByTagName(bizGroup, "Document", recursive = F)[[1]]
  priceReport = xmlChildren(doc)[[1]]
  tickerSymbol = xmlValue(xmlElementsByTagName(priceReport, "TckerSymb", recursive = T))[[1]]
  finInstrAttributes = xmlElementsByTagName(priceReport, "finInstrAttributes", recursive = F)[[1]]
  
  df = as.data.frame(t(getChildrenStrings(finInstrAttributes)), stringsAsFactors = F)
  df$tickerSymbol = tickerSymbol
  
  return(df)
}

BvbgPorData = function(date) {
  stopifnot(length(date) == 1)
  
  if(class(date) != "Date") {
    date = as.Date(date, "%Y-%m-%d")
  }
  
  dados = data.frame()
  
  url = format(date, "ftp://ftp.bmf.com.br/IPN/TRS/BVBG.086.01/PR%y%m%d.zip")
  filename = format(date, "Downloads/PR%y%m%d.zip")
  download.file(url = url, destfile = filename)
  
  files = unzip(filename, exdir = "Downloads/BVBG")
  root = xmlRoot(xmlParse(max(files)))
  file.remove(files)
  # NOTA: abordagem simples, mas lenta: xmlElementsByTagName(root, "PricRpt", recursive = T)  
  bizFileHdr = xmlChildren(root)[[1]]
  xchange = xmlChildren(bizFileHdr)[[1]]
  bizGroups = xmlElementsByTagName(xchange, "BizGrp", recursive = F)
  
  # Versão "manual" (lenta)
  # for(bizGroup in bizGroups) {
  #   dados = rbind.fill(dados, from.node.to.data.frame(bizGroup))
  # }
  
  # Versão interna do pacote (rápida)
  dados = ldply(.data = bizGroups, .fun = from.node.to.data.frame)
  
  dados[, ".id"] = NULL
  non.numerics = c("TckerSymb", "MktDataStrmId", "AdjstQtStin", "PrvsAdjstQtStin")
  numerics = colnames(dados)[!colnames(dados) %in% non.numerics]
  for(column in numerics) { dados[, column] = as.numeric(dados[, column]) }
  
  return(dados)
}


