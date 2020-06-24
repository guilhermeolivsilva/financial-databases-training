# Versão específica
url = "ftp://ftp.cetip.com.br/MediaCDI/20200619.txt"

# Generalização
data = as.Date("2020-01-02", "%Y-%m-%d")
urlGeral = format(data, "ftp://ftp.cetip.com.br/MediaCDI/%Y%m%d.txt")

txt = readLines(urlGeral)
gsub(" ", "", txt)
cdi = as.numeric(txt)/100

# Função
ler.CETIP.CDI = function(date) {
  if(length(date) > 1) {
    counter = 1
    cdi = c()
    
    for(element in date) {
      if(class(element) != "Date") {
        element = as.Date(element, "%Y-%m-%d")
      }
      
      url = format(element, "ftp://ftp.cetip.com.br/MediaCDI/%Y%m%d.txt")
      txt = readLines(url)
      gsub(" ", "", txt)
      
      cdi[counter] = as.numeric(txt)/100
      counter = counter + 1
    }
    
    return(cdi)
  } 
  
  else {
    if(class(date) != "Date") {
      date = as.Date(date, "%Y-%m-%d")
    }
    
    url = format(date, "ftp://ftp.cetip.com.br/MediaCDI/%Y%m%d.txt")
    txt = readLines(url)
    gsub(" ", "", txt)
    
    cdi = as.numeric(txt)/100
    
    return(cdi)
  }
}

ler.CETIP.CDI(Sys.Date() - 3)
ler.CETIP.CDI("2020-06-19")
teste = ler.CETIP.CDI(c("2020-06-19", "2020-06-09"))
