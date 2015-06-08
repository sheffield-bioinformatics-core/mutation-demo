
# This is the server logic for a Shiny web application.
# You can find out more about building applications with Shiny here:
#
# http://shiny.rstudio.com
#

library(shiny)

shinyServer(function(input, output) {
  
  
  generate.sequence <- reactive({
    library(org.Hs.eg.db)
    library(BSgenome.Hsapiens.UCSC.hg19)
    library(ggplot2)
    library(gridExtra)
    hg19 <- BSgenome.Hsapiens.UCSC.hg19
    
    start <- sample(41196312:41277500,1)
    length <- input$length
    
    seq <-strsplit(as.character(getSeq(hg19, "chr17",start,start+length)),"")[[1]]
    seq
    out <- NULL
    out[[1]] <- seq
    
    df <- data.frame(pos=1:length(seq),letter=seq)
    nPerms <- input$choices
    seqList <- NULL
    diffList <- NULL
    seqList[[1]] <- seq
    diffList[[1]] <- 0
    
    for(i in 1:nPerms){
      #pick at random how many positions to change
      posToChange <- sample(1:length(seq),sample(1:4,1))
      seq2 <- seq
      seq2[posToChange] <- sample(c("A","T","C","G"),length(posToChange),replace=TRUE)
      df <- rbind(df, data.frame(pos=1:length(seq),letter=seq2))
      seqList[[i+1]] <- seq2
      diffList[[i+1]] <- sum(seq != seq2)
    }
    
    df$Number <- rep(sample(1:(nPerms+1)),each=length(seq))
    
    out[[2]] <- df
    out[[3]] <- seqList
    out[[4]] <- diffList
    out
    
    }
  )
  
  
  
  output$distPlot <- reactivePlot(function(){
    
    seq <- generate.sequence()[[1]]
    
    df <- data.frame(pos=1:length(seq),letter=seq)
    gg <- ggplot(df, aes(x=pos,y=1,fill=letter)) +geom_tile(position="identity") 
    gg <- gg + scale_fill_manual(values=c("A" = "red","C"="blue","G"="yellow","T"="green")) 
    gg <- gg + ggtitle(paste("Sequence of BRCA1 from ", start, "to", start + length)) 
    gg <- gg + theme(axis.title.y=element_blank(),axis.text.y=element_blank(),axis.ticks.y=element_blank()) 
    breaks <- data.frame(xs = c(0.5, 1:(length(seq))+0.5))
    gg <- gg + geom_vline(data=breaks, aes(xintercept=xs))
    
    gg
    
    
    df <- generate.sequence()[[2]]

    
    gg2 <- ggplot(df, aes(x=pos,y=1,fill=letter)) +geom_tile() 

    gg2 <- gg2 + scale_fill_manual(values=c("A" = "red","C"="blue","G"="yellow","T"="green")) 
    gg2 <- gg2 + facet_wrap(~Number)
    gg2 <- gg2 + theme(axis.title.y=element_blank(),axis.text.y=element_blank(),axis.ticks.y=element_blank()) 
    breaks <- data.frame(xs = rep(c(0.5, 1:(length(seq))+0.5),nPerms))
    gg2 <- gg2 + geom_vline(data=breaks, aes(xintercept=xs))
    gg2
        
   grid.arrange(gg,gg2)
    
    
    
  })
  output$mytable <- renderDataTable({
   df <- generate.sequence()[[2]]
   seqList <- generate.sequence()[[3]]
   diffList <- generate.sequence()[[4]]
   out <- data.frame(Pattern = unlist(lapply(seqList,function(x) paste(x,collapse=""))), Difference = unlist(diffList), Number = unique(df$Number))
   out
     
  }
  )  
})
