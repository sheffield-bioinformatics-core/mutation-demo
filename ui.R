
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
                  value = 10),
      sliderInput("choices",
                  "Number of permutations:",
                  min = 5,
                  max = 10,
                  value = 5)
    ),

    # Show a plot of the generated distribution
    mainPanel(
      plotOutput("distPlot")
    )
  )
))
