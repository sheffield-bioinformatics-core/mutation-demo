
# This is the user-interface definition of a Shiny web application.
# You can find out more about building applications with Shiny here:
#
# http://shiny.rstudio.com
#

library(shiny)

shinyUI(fluidPage(

  # Application title
  titlePanel("Detecting DNA mutations: Demo"),

  # Sidebar with a slider input for number of bins
  sidebarLayout(
    sidebarPanel(
      sliderInput("length",
                  "Length of Sequence:",
                  min = 5,
                  max = 100,
                  value = 5),
      sliderInput("choices",
                  "Number of Patients:",
                  min =2,
                  max = 4,
                  value = 2,step=1),
      radioButtons("useColour","Colour each position?",choices=c("Yes","No"),selected = "Yes"),
      radioButtons("useText","Show letters?",choices=c("Yes","No"),selected="No")
    ),

    # Show a plot of the generated distribution
    mainPanel(
      tabsetPanel(
        tabPanel("Background",
                 helpText("You will be shown a small part of the genetic code [1] for the human gene BRCA1 [2], which is a very famous gene in Cancer Genetics"),
                 helpText("The app will generate various alternative versions of the sequence, and your task is to work out which alternative matches the original sequences.
                        You can also try and spot where the errors ('mutations') are in the other sequences. Clicking the 'Show the Mutations' tab will ask the app to work out where the mutations are."),
                 helpText("You can use the 'slider' bars to increase the length of the sequence and to increase the number of patients to analyse. Can you beat how long it takes the app to identify the correct sequence?"),
                 helpText("In reality, Cancer Research is performing experiments which investigate the human genome [3], which is about 3 Billion (3,000,000,000) letters in length, and we may have hundreds of millions of sequences to match up"),
                 helpText("Hopefully you will see how computers are extremely useful for this task!"),
                 h2("Why is mutation detection in BRCA1 so important?"),
                 helpText("PARP inhibitor drug [4]was found to be effective in ovarian and breast cancers patients with mutations in BRCA1/2 genes. PARPi drug blocks an enzyme that is used to repair DNA damages. Cancer cells in patients with BRCA1/2 mutations have problems with fixing DNA breaks already and PARPi drug make that worse. As normal cells in BRCA1/2 carriers have one working copy of BRCA1/2 genes they remain. PARP inhibitor can then be used as a different therapeutic strategy for the treatment of tumors that lack BRCA function. Several PARPi have entered clinical trials and show promising activity in breast, ovarian and other cancers associated with BRCA1/2 mutations or other defects in DNA repair system (homologous recombination DNA repair). 
"),
                 a("[1] Introduction to genetics",href="https://en.wikipedia.org/wiki/Introduction_to_genetics",target="_blank"),
                 br(),
                 a("[2] The BRCA1 gene", href="https://en.wikipedia.org/wiki/BRCA1",target="_blank"),
                 br(),
                 a("[3] The Human Genome", href="https://en.wikipedia.org/wiki/Human_genome",target="_blank"),
                 br(),
                 a("[4] The PARP Inhibitor",href="https://en.wikipedia.org/wiki/PARP_inhibitor",target="_blank"),
                 helpText("Youtube videos"),
                 a("What is DNA and How Does it Work? ",href="https://www.youtube.com/watch?v=zwibgNGe4aY",target="_blank"),
                 br(),
                 a("What is a Mutation?",href="https://www.youtube.com/watch?v=K4FeRP6LdoA",target="_blank"),
                 br(),
                 a("Mutation and How Cancer Develops | Cancer Research UK ",href="https://www.youtube.com/watch?v=8BJ8_5Gyhg8",target="_blank"),
                 br(),
                 a("18 Things You Should Know About Genetics",href="https://www.youtube.com/watch?v=bVk0twJYL6Y",target="_blank")
                
                 
                 
                 
        ),
      tabPanel("Analyse the Patients", plotOutput("distPlot",height=750)),
      tabPanel("Ask the Computer", plotOutput("mutationPlot",height=750)),
      
      tabPanel("About us....",helpText("This app was developed by Mark Dunning, Ania Piskorz and Elke Van Oudenhove of Cancer Research Uk Cambridge Institute"),
                                       img(src="cruk-cambridge-institute.jpg",width=350,height=77), br(),a("cruk.cam.ac.uk",href="www.cruk.cam.ac.uk"),
                                      br(),
                                      a("View source Code", href="https://github.com/markdunning/sequencer-matcher")
      )
    )
    )
  )
))
