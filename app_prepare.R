#Preparing data for Shiny application
#loafing libraries
library(NLP)
library(stringr)
library(dplyr)
library(stringi)
library(tm)
library(RWeka)
library(SnowballC)

#Read the data
blogs_data <- readLines(con = "./final/en_US/en_US.blogs.txt", encoding= "UTF-8", skipNul = TRUE)
news_data <- readLines(con = "./final/en_US/en_US.news.txt", encoding= "UTF-8", skipNul = TRUE)
twitter_data <- readLines(con = "./final/en_US/en_US.twitter.txt", encoding= "UTF-8", skipNul = TRUE)

#Select a 5% part of dataset for app speed purposes
set.seed(555)
app_data <- c(sample(blogs_data, length(blogs.data) * 0.05),
              sample(news_data, length(news.data) * 0.05),
              sample(twitter_data, length(twitter.data) * 0.05))

#Creating corpus data
corp <- VCorpus(VectorSource(app_data))

#Data cleaning:
#Transform the character's type to ASCII to eliminate foreign letters and unnecesarry symbols and rewrite the corpus
temps <- sapply(corp, function(row) iconv(row, "latin1", "ASCII", sub=""))
corp <- VCorpus(VectorSource(temps)); rm(temps)
toSpace <- content_transformer(function(x, pattern) gsub(pattern, " ", x))
corp <- tm_map(corp, toSpace, "(f|ht)tp(s?)://(.*)[.][a-z]+")
corp <- tm_map(corp, toSpace, "@[^\\s]+")
corp <- tm_map(corp, removePunctuation)
corp <- tm_map(corp, stripWhitespace)
corp <- tm_map(corp, removeWords, stopwords("en"))
corp <- tm_map(corp, tolower)
corp <- tm_map(corp, removeNumbers)
corp <- tm_map(corp, PlainTextDocument)
bad_words <- readLines(con="./bad_words.txt", skipNul = TRUE)
corp <- tm_map(corp, removeWords, bad_words)
saveRDS(corp, file = "corp_clean.RData")
corp_clean_DF <-data.frame(text=unlist(sapply(corp,`[`, "content")),stringsAsFactors = FALSE)

#tokenizing words of the data corpus
bigram <- NGramTokenizer(corp_clean_DF, Weka_control(min = 2, max = 2))
trigram <- NGramTokenizer(corp_clean_DF, Weka_control(min = 3, max = 3))
quadgram <- NGramTokenizer(corp_clean_DF, Weka_control(min = 4, max = 4))
#creating DF
bigram_df <- data.frame(table(bigram))
trigram_df <- data.frame(table(trigram))
quagram_df <- data.frame(table(quagram))
#ordering DF
bigram_df <- bigram_df[order(bigram_df$Freq,decreasing = TRUE),]
trigram_df <- trigram_df[order(trigram_df$Freq,decreasing = TRUE),]
quagram_df <- quagram_df[order(quagram_df$Freq,decreasing = TRUE),]
#naming DF columns
names(bigram_df) <- c("words","freq")
names(trigram_df) <- c("words","freq")
names(quagram_df) <- c("words","freq")

#generating bigram data frame from the cleaned dataset 
#returning bigram DF with 2 words - save to bigram.RData
bigram_df$words <- as.character(bigram_df$words)
wsplit2 <- strsplit(bigram_df$words,split=" ")
bigram_df <- transform(bigram_df,word1= sapply(wsplit2,"[[",1),word2= sapply(wsplit2,"[[",2))
bigram_df<-bigram_df[bigram_df$freq > 1,]
saveRDS(bigram_df,"bigram.RData")

#generating trigram data frame from the cleaned dataset 
#returning trigram DF with 3 words - save to trigram.RData
trigram_df$words <- as.character(trigram_df$words)
wsplit3 <- strsplit(trigram_df$words,split=" ")
trigram_df <- transform(trigram_df, word1= sapply(wsplit3,"[[",1), word2= sapply(wsplit3,"[[",2), word3= sapply(wsplit3,"[[",3))
trigram_df<-trigram_df[trigram_df$freq > 1,]
saveRDS(trigram_df,"trigram.RData")

#generating quagram data frame from the cleaned dataset 
#returning quagram DF with 4 words - save to quagram.RData
quagram_df$words <- as.character(quagram_df$words)
wsplit4 <- strsplit(quagram_df$words,split=" ")
quagram_df <- transform(quagram_df, word1= sapply(wsplit4,"[[",1), word2= sapply(wsplit4,"[[",2), word3= sapply(wsplit4,"[[",3), word4= sapply(wsplit4,"[[",4))
quagram_df<-quagram_df[quagram_df$freq > 1,]
saveRDS(quagram_df,"quagram.RData")
