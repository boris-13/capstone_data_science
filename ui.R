################# ~~~~~~~~~~~~~~~~~ ######## ~~~~~~~~~~~~~~~~~ #################
##                                                                            ##
##                        Data Science Capstone Project                       ##
##                                                                            ##            
##                        Boris Romanciuc, january 2019                       ##
##                                                                            ##
##        Github Repo: https://github.com/boris-13/capstone_data_science      ##
##                                                                            ##
################# ~~~~~~~~~~~~~~~~~ ######## ~~~~~~~~~~~~~~~~~ #################

#The user interface part for the Shiny app guessing next word to be typed


#Loading necesary libraries
suppressPackageStartupMessages(c(
  library(shinythemes),
  library(shiny),
  library(tm),
  library(stringr),
  library(markdown),
  library(stylo)))
   
                   
shinyUI(navbarPage("My GuessApp",
                   theme ="my_theme.css",
               
############################### ~~~~~~~~1~~~~~~~~ ##############################  
## Tab 1 - Application               
               
tabPanel("Application",           
                        fluidPage(
                          fluidRow(
                            column(12,align="center",
                                    style = "display: block; 
                                    margin:0 0%; 
                                    clear: both;
                                    border-bottom:2px solid #555555;",
                                   a(target="_blank", href="https://swiftkey.com", 
                                     img(src = "logo_swiftkey.png",
                                         style = "width:180px;padding:0 15px;")),
                                   a(target="_blank", href="https://www.coursera.org/", 
                                     img(src = "logo_coursera.png",
                                         style = "width:170px;padding:0 15px;")),
                                   a(target="_blank", href="https://www.jhu.edu/", 
                                     img(src = "logo_johnshopkins.png",
                                         style = "width:160px;padding:0 15px;"))
                            )
                          ),                          
                          
                          # User Input
                          fluidRow(
                            column(12,align="center",
                                   
                                   textInput("inputText", label = h3("Enter a sentence:", value = ""),  width = "90%"),
                                   #helpText("Type in a sentence above"),
                                   br(),
                                   tags$span(style="color:grey",("Type in a sentence above. Only English words are supported."))
                            )
                          ),
                          
                          # System Prediction
                          fluidRow(
                            column(12,align="center",
                                    style = "display: block; 
                                    margin:0 0%; 
                                    clear: both;
                                    border-bottom:2px solid #555555;",
                                   br(),
                                   br(),
                                   tags$h3("The next word might be:"),
                                   h3(textOutput('nw'), 
                                                        style="display:block;
                                                               margin:0 auto;
                                                               color:white;
                                                               padding: 15px;
                                                               width: 500px;
                                                               height: 100px;
                                                               background-color:#78acc4; 
                                                               font-size:46px; "),
                                   br(),
                                   br()
                            )       
                          ),
                          
                          # Footer
                          fluidRow(
                            column(12,
                                  tags$b("Data Science Capstone Project"),align="center",
                                  br(),
                                  tags$b("Author: Boris Romanciuc - January, 2019")
                            ) #column
                          ) # fluidRow
                        ) # fluidPage
               ), # tabPanel

############################### ~~~~~~~~2~~~~~~~~ ##############################  
## Tab 2 - Instructions  
               tabPanel("Instructions",           
                        fluidPage(
                          fluidRow(
                            column(12,
                             h5('Instructions',style="font-size:48px;
                                   padding-top: 50px;
                                   color:#78ACC4"),
                            
                            tags$h4("The application is guessing the next word one is going to write."),

                            tags$h4("The next word to be predicted is using the frequency of combinations of two, three and four words."),
                            
                            tags$h4("The frequency is calculated using text extracted from twitter, blogs and news texts that SwiftKey  offers for this projects."),
                           
                            tags$h4("When there is no hint for prediction or no pattern is found, then the word 'a' is used."),
                            br(),
                            br(),
                            h5("Technical Details",style="font-size:48px;
                                   padding-top: 20px;
                                   color:#78ACC4"),
                            tags$h4("The algorithm the application is using is based on n-gram modeling."),
                            
                            tags$h4("The given corpora texts were initially sampled and cleaned (punctuation removal, white space stripping, removal of numbers, lowercasing, removal of URLs, profanity filtering)."),
                            
                            tags$h4("The final corpus was tokenized into n-grams (bigrams, trigrams, quagrams)."),
                            
                            tags$h4("Bigram, trigram and quagram term frequency matrices were transposed into frequency dictionaries which are used to predict the next word based on the user text input and the corresponding n-gram frequencies.")
                  
                            ) #column
                          ) # fluidRow
                        ) # fluidPage
               ), # tabPanel

############################### ~~~~~~~~3~~~~~~~~ ##############################  
## Tab 3 - Thanks  
               tabPanel("Thanks",           
                        fluidPage(
                          fluidRow(
                            column(12,
                                   h5('Thank You! :)',align="center",
                                   style="font-size:48px;
                                   padding-top: 50px;
                                   color:#78ACC4")
                                   ) #column
                          ) # fluidRow
                        ) # fluidPage
                      )# tabPanel
    ) #navbarPage
  ) # shinyUI                       
