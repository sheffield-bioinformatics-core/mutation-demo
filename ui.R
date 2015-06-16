
# This is the user-interface definition of a Shiny web application.
# You can find out more about building applications with Shiny here:
#
# http://shiny.rstudio.com
#

library(shiny)

shinyUI(fluidPage(

  # Application title
  titlePanel("Simple Sequence Matcher"),

  # Sidebar with a slider input for number of bins
  sidebarLayout(
    sidebarPanel(
      sliderInput("length",
                  "Length of Sequence:",
                  min = 5,
                  max = 100,
                  value = 5),
      sliderInput("choices",
                  "Number of permutations:",
                  min =2,
                  max = 10,
                  value = 3)
    ),

    # Show a plot of the generated distribution
    mainPanel(
      tabsetPanel(
        tabPanel("Background",
                 helpText("You will be shown a small part of the genetic code [1] for the human gene BRCA1 [2], which is a very famous gene in Cancer Genetics"),
                 helpText("The app will generate various alternative versions of the sequence, and your task is to work out which alternative matches the original sequences.
                        You can also try and spot where the errors ('mutations') are in the other sequences. Clicking the 'Show the Mutations' tab will ask the app to work out where the mutations are."),
                 helpText("You can use the 'slider' bars to increase the length of the sequence and to increase the number of alternative sequences you can choose from. Can you beat how long it takes the app to identify the correct sequence?"),
                 helpText("In reality, Cancer Research is performing experiments which investigate the human genome [3], which is about 3 Billion (3,000,000,000) letters in length, and we may have hundreds of millions of sequences to match up"),
                 helpText("Hopefully you will see how computers are extremely useful for this task!"),
                 a("[1] Introduction to genetics",href="https://en.wikipedia.org/wiki/Introduction_to_genetics"),
                 br(),
                 a("[2] The BRCA1 gene", href="https://en.wikipedia.org/wiki/BRCA1"),
                 br(),
                 a("[3] The Human Genome", href="https://en.wikipedia.org/wiki/Human_genome")
                 
                 
                 
        ),
      tabPanel("Match the Patterns", plotOutput("distPlot")),
      tabPanel("Show the Mutations", plotOutput("mutationPlot")),
      
      tabPanel("About us....",helpText("This app was developed by Mark Dunning and Elke Van Oudenhove of Cancer Research Uk Cambridge Institute"),
                                       img(src="cruk-cambridge-institute.jpg",width=350,height=77), br(),a("cruk.cam.ac.uk",href="www.cruk.cam.ac.uk"),
                                      br(),
                                      a("View source Code", href="https://github.com/markdunning/sequencer-matcher")
      )
    )
    )
  )
))
