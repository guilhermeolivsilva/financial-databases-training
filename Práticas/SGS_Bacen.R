library(httr)
library(XML)

xmlGetValor = function(idSerie, data) {
  stopifnot(
    is.integer(idSerie),
    length(idSerie) == 1,
    is(data, "Date"),
    length(data) == 1
  )
  
  return(paste0(
    '<?xml version=\"1.0\"?>',
    '<SOAP-ENV:Envelope xmlns:SOAP-ENC=\"http://schemas.xmlsoap.org/soap/encoding/\" xmlns:SOAP-ENV=\"http://schemas.xmlsoap.org/soap/envelope/\" xmlns:xsi=\"http://www.w3.org/2001/XMLSchema-instance\" xmlns:xsd=\"http://www.w3.org/2001/XMLSchema\" SOAP-ENV:encodingStyle=\"http://schemas.xmlsoap.org/soap/encoding/\">',
    		'<SOAP-ENV:Body>',
    			'<getValor xmlns="http://publico.ws.casosdeuso.sgs.pec.bcb.gov.br\">',
    				'<in1 xsi:type=\"xsd:long\">', idSerie, '</in1>',
    				'<in2 xsi:type=\"xsd:string\">', format(data, "%d/%m/%Y"), '</in2>',
    			'</getValor>',
    		'</SOAP-ENV:Body>',
    '</SOAP-ENV:Envelope>'
  ))
}

lerBacen = function(idSerie, data) {
  stopifnot(
    is.integer(idSerie),
    length(idSerie) == 1,
    is(data, "Date"),
    length(data) == 1
  )
  
  req = POST(
    url = "https://www3.bcb.gov.br/wssgs/services/FachadaWSSGS",
    add_headers(
      SOAPAction = "\"http://publico.ws.casosdeuso.sgs.pec.bcb.gov.br#getValor\""
    ),
    body = xmlGetValor(idSerie, data)
  )
  
  
  doc = xmlParse(rawToChar(req$content), asText = T)
  root = xmlRoot(doc)
  node = xmlElementsByTagName(root, "multiRef", recursive = T)[[1]]
  value = as.numeric(xmlValue(node))
  
  return(value)
}

