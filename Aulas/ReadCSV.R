dados = read.csv("Dados/carteira.csv")
dados = read.csv2("Dados/carteira2.csv",
                  stringsAsFactors = FALSE)

dados$data = as.Date(dados$data, "%Y-%m-%d")
dados$vencimento = as.Date(dados$vencimento, "%Y-%m-%d")