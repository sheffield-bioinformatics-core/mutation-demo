
# This is the server logic for a Shiny web application.
# You can find out more about building applications with Shiny here:
#
# http://shiny.rstudio.com
#

library(shiny)

shinyServer(function(input, output) {

  output$distPlot <- renderPlot({
    
    library(org.Hs.eg.db)
    library(BSgenome.Hsapiens.UCSC.hg19)
    library(ggplot2)
    library(gridExtra)
    hg19 <- BSgenome.Hsapiens.UCSC.hg19
    
    start <- sample(41196312:41277500,1)
    length <- input$length
    
    seq <-strsplit(as.character(getSeq(hg19, "chr17",start,start+length)),"")[[1]]
    
    df <- data.frame(pos=1:length(seq),letter=seq)
    gg <- ggplot(df, aes(x=pos,y=1,fill=letter)) +geom_tile() + geom_vline(aes(xintercept=1:(length(seq))+0.5)) + scale_fill_manual(values=c("A" = "red","C"="blue","G"="yellow","T"="green")) + ggtitle(paste("Sequence of BRCA1 from ", start, "to", start + length))
    
    gg
  
      
    
    nPerms <- input$choices
    
    for(i in 1:nPerms){
      #pick at random how many positions to change
      posToChange <- sample(1:length(seq),sample(1:4,1))
      seq2 <- seq
      seq2[posToChange] <- sample(c("A","T","C","G"),length(posToChange),replace=TRUE)
      df <- rbind(df, data.frame(pos=1:length(seq),letter=seq2))
    }
    
    df$layout <- rep(sample(1:(nPerms+1)),each=length(seq))
    
    # generate bins based on input$bins from ui.R
    #x    <- faithful[, 2]
    #bins <- seq(min(x), max(x), length.out = input$length + 1)

    # draw the histogram with the specified number of bins
    #hist(x, breaks = bins, col = 'darkgray', border = 'white')
    gg2 <- ggplot(df, aes(x=pos,y=1,fill=letter)) +geom_tile() + geom_vline(aes(xintercept=1:(length(seq))+0.5))+ scale_fill_manual(values=c("A" = "red","C"="blue","G"="yellow","T"="green")) + facet_wrap(~layout)
    
    gg2
    
    grid.arrange(gg,gg2)
  })

})
