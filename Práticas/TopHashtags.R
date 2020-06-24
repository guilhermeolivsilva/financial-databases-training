library(stringr)
library(tidyr)

tweets = read.csv("Dados/tweets.csv", stringsAsFactors = F)
hashtags = drop_na(as.data.frame(table(str_extract(tweets$text, "#\\w+"))))
hashtags = hashtags[order(-hashtags$Freq),]

topHashtags = head(hashtags, 5)


tweetsComHashtag = View(tweets[grepl("#\\w+", tweets$text),])
