
# This is the server logic for a Shiny web application.
# You can find out more about building applications with Shiny here:
#
# http://shiny.rstudio.com
#

library(shiny)

library(RColorBrewer)

mypal <- brewer.pal(9,"Set1")
names(mypal) <- c("red","blue","green","purple","orange","yellow","brown","pink","grey")

shinyServer(function(input, output) {
  
  
  generate.sequence <- reactive({
    library(org.Hs.eg.db)
    library(BSgenome.Hsapiens.UCSC.hg19)
    library(ggplot2)
    library(gridExtra)
    hg19 <- BSgenome.Hsapiens.UCSC.hg19
    
    start <- sample(41196312:41277500,1)
    length <- input$length  - 1
    
    seq <-strsplit(as.character(getSeq(hg19, "chr17",start,start+length)),"")[[1]]
    seq
    out <- NULL
    out[[1]] <- seq
    
    df <- data.frame(pos=1:length(seq),letter=seq)
    nPerms <- input$choices - 1 
    seqList <- NULL
    diffList <- NULL
    seqList[[1]] <- seq
    diffList[[1]] <- 0
    
    maxChanges <- length(seq)*0.2
      
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
    df$Patient <- paste0("Patient",df$Number)
    df$Mutated <- do.call(c, lapply(seqList, function(x) x != seq))
    
    out[[2]] <- df
    out[[3]] <- seqList
    out[[4]] <- diffList
    out
    
  }
  )
  
  
  
  output$distPlot <- reactivePlot(function(){
    ##Seems like I have to define these defaults?
    start <- 41196312
    length<-10
    nPerms  <- 5
    seq <- generate.sequence()[[1]]
    
    df <- data.frame(pos=1:length(seq),letter=seq,Patient="Human Genome")
    
    useColour <- ifelse(input$useColour == "Yes",TRUE,FALSE)
    useText <- ifelse(input$useText == "Yes",TRUE,FALSE)
    
    if(useColour){
    gg <- ggplot(df, aes(x=pos,y=1,fill=letter,label=letter)) +geom_tile(position="identity") 
    } else gg <- ggplot(df, aes(x=pos,y=1,label=letter)) +geom_tile(position="identity",fill="white")
    
    
    gg <- gg + scale_fill_manual(values=c("A" = "green","C"="blue","G"="yellow","T"="red")) 
    gg <- gg + facet_wrap(~Patient)
    
    if(useText) gg <- gg + geom_text()
    
    gg <- gg + theme(axis.title.y=element_blank(),axis.text.y=element_blank(),axis.ticks.y=element_blank(),panel.background =  element_blank()) 
    breaks <- data.frame(xs = c(0.5, 1:(length(seq))+0.5))
    gg <- gg + geom_vline(data=breaks, aes(xintercept=xs))
    
    gg
    
    
    df <- generate.sequence()[[2]]
    
    if(useColour){
      gg2 <- ggplot(df, aes(x=pos,y=1,fill=letter,label=letter)) +geom_tile() 
    } else   gg2 <- ggplot(df, aes(x=pos,y=1,label=letter)) +geom_tile(fill="white")
    
    if(useText) gg2 <- gg2 + geom_text()
    
    gg2 <- gg2 + scale_fill_manual(values=c("A" = "green","C"="blue","G"="yellow","T"="red"))  + ggtitle("Which patients show a mutation?")
    gg2 <- gg2 + facet_wrap(~Patient,ncol=1)
    gg2 <- gg2 + theme(axis.title.y=element_blank(),axis.text.y=element_blank(),axis.ticks.y=element_blank(),panel.background =  element_blank())
    breaks <- data.frame(xs = rep(c(0.5, 1:(length(seq))+0.5),nPerms))
    gg2 <- gg2 + geom_vline(data=breaks, aes(xintercept=xs))
    gg2
    
    grid.arrange(gg,gg2)
      
  })
  
  output$mutationPlot <- reactivePlot(function(){
    start <- 41196312
    length<-10
    nPerms  <- 5
    seq <- generate.sequence()[[1]]
    
    useColour <- ifelse(input$useColour == "Yes",TRUE,FALSE)
    useText <- ifelse(input$useText == "Yes",TRUE,FALSE)
    
    df <- data.frame(pos=1:length(seq),letter=seq,Patient="Human Genome")
    if(useColour){
      gg <- ggplot(df, aes(x=pos,y=1,fill=letter,label=letter)) +geom_tile(position="identity") 
    }
    else gg <- ggplot(df, aes(x=pos,y=1,label=letter)) +geom_tile(position="identity",fill="white")
    
    if (useText) gg <- gg + geom_text()
    
    gg <- gg + scale_fill_manual(values=c("A" = "green","C"="blue","G"="yellow","T"="red")) 
    gg <- gg + facet_wrap(~Patient)
    gg <- gg + theme(axis.title.y=element_blank(),axis.text.y=element_blank(),axis.ticks.y=element_blank(),panel.background =  element_blank()) + theme(legend.position="none")
    breaks <- data.frame(xs = c(0.5, 1:(length(seq))+0.5))
    gg <- gg + geom_vline(data=breaks, aes(xintercept=xs))
    
    gg
    
    df <- generate.sequence()[[2]]
    
    
    gg3 <- ggplot(df, aes(x=pos,y=1,fill=Mutated,label=letter)) +geom_tile() 
    
    if(useText) gg3 <- gg3 + geom_text()
    
    gg3 <- gg3 + scale_fill_manual(values=c("TRUE" = "deeppink","FALSE"="white")) + ggtitle("The computer will analyse the sequence and show any mutated positions in pink")
    gg3 <- gg3 + facet_wrap(~Patient,ncol=1)
    gg3 <- gg3 + theme(axis.title.y=element_blank(),axis.text.y=element_blank(),axis.ticks.y=element_blank(),panel.background =  element_blank()) + theme(legend.position="none")
    breaks <- data.frame(xs = rep(c(0.5, 1:(length(seq))+0.5),nPerms))
    gg3 <- gg3 + geom_vline(data=breaks, aes(xintercept=xs))
    
    grid.arrange(gg,gg3)
  
    }
  )
  output$mytable <- renderDataTable({
    df <- generate.sequence()[[2]]
    seqList <- generate.sequence()[[3]]
    diffList <- generate.sequence()[[4]]
    out <- data.frame(Pattern = unlist(lapply(seqList,function(x) paste(x,collapse=""))), Difference = unlist(diffList), Number = unique(df$Number))
    out
    
  }
  )  
})
