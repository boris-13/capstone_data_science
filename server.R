################# ~~~~~~~~~~~~~~~~~ ######## ~~~~~~~~~~~~~~~~~ #################
##                                                                            ##
##                        Data Science Capstone Project                       ##
##                                                                            ##            
##                        Boris Romanciuc, january 2019                       ##
##                                                                            ##
##        Github Repo: https://github.com/boris-13/capstone_data_science      ##
##                                                                            ##
################# ~~~~~~~~~~~~~~~~~ ######## ~~~~~~~~~~~~~~~~~ #################

#The server part for the Shiny app guessing next word to be typed

#Loading necesary libraries
library(tm)
library(NLP)
library(shiny)
library(stringr)

#Loading matrix frequencies (bigram, trigram and quadgram)
bigram <- readRDS("data/bigram.RData")
trigram <- readRDS("data/trigram.RData") 
quagram <- readRDS("data/quagram.RData")

#Defining a search function for bigram frequency table.
# $nw2 - next word in bigram DF
# $prop - proposition typed
# $nw - next word
nw2<-function(prop) {
  nw<-as.character(head((bigram[bigram$word1==prop[1],])$word2,1))
  freq<-as.character(head((bigram[bigram$word1==prop[1],])$freq,1))
  if(identical(nw,character(0))) {nw<-"a";freq<-0}
  nwlist<-list(nw, freq)
  return(nwlist)
}

#Defining a search function for trigram frequency table.
#if nothing found - search in bigram DF
# $nw3 - next word in trigram DF
nw3<-function(prop) {
  nw<-as.character(head((trigram[trigram$word1==prop[1] & trigram$word2 == prop[2],])$word3,1))
  freq<-as.character(head((trigram[trigram$word1==prop[1] & trigram$word2 == prop[2],])$freq,1))
  nwlist<-list(nw, freq)
  if(identical(nw,character(0))) {nwlist=nwf(prop[2])}
  return(nwlist)
}

#Defining a search function for quagram frequency table.
#if nothing found - search in trigram DF
nw4<-function(prop) {
  nw<-as.character(head((quagram[quagram$word1==prop[1] & quagram$word2 == prop[2] & quagram$word3 == prop[3],])$word4,1))
  freq<-as.character(head((quagram[quagram$word1==prop[1] & quagram$word2 == prop[2] & quagram$word3 == prop[3],])$freq,1))
  nwlist<-list(nw, freq)
  if(identical(nw,character(0))) {nwlist=nwf(paste(prop[2],prop[3],sep=" "))}
  return(nwlist)
}


#Defining searching sentence function
# $quanw - quantity of words
# $inprop - input proposition
nwf<-function(inprop, ngramw=0)  {
  tempprop <- tolower(inprop)
  tempprop <- removePunctuation(tempprop)
  tempprop <- removeNumbers(tempprop)
  tempprop <- str_replace_all(tempprop, "[^[:alnum:]]", " ")
  tempprop <- stripWhitespace(tempprop)
  prop<- strsplit(tempprop," ")[[1]]
  quanw<-length(prop)

  if(quanw==1 || ngramw==2) { #to find out next word, use bigram DF
    nwlist<-nw2(tail(prop,1))
  }  
  else if(quanw==2 || ngramw==3) { #to find out next word, use trigram DF
    nwlist<-nw3(tail(prop,2))
  }
  else if(quanw>2 || ngramw==3) {
    nwlist<-nw4(tail(prop,3))
  }
  else {
    nwlist<-list("a",0)
  }
  return(nwlist)
}

#testtime<-function(inprop,ngramw=0) {
#  currtime <- proc.time()
#  nwf(inprop,0)
#  duration<-proc.time() - currtime
#  return(duration)
#}

# Define server logic required to draw a histogram
shinyServer(function(input, output) {
  output$nw<-renderPrint({
    result<-nwf(input$inputText,0)
    result[[1]]
    
  })
})
