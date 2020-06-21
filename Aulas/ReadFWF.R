dados = read.fwf("Dados/carteira.txt",
                 widths = c(1, 10, 5, 10, 3, 11),
                 stringsAsFactors = FALSE,
                 strip.white = TRUE)


colnames(dados) = c("id", "data", "papel", "vencimento", "quantidade", "preco")
dados$data = as.Date(dados$data, "%Y-%m-%d")
dados$vencimento = as.Date(dados$vencimento, "%Y-%m-%d")
