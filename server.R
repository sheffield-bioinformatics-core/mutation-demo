library(shiny)
library(RColorBrewer)
library(ggplot2)
library(gridExtra)

mypal <- brewer.pal(9,"Set1")
names(mypal) <- c("red","blue","green","purple","orange","yellow","brown","pink","grey")

cat("Loading BRCA1 sequence\n")
load('brca1seq.RData')

shinyServer(function(input, output) {

  generate.sequence <- reactive({
    length <- input$length
    start <- sample(1:(nchar(brca1seq) - length + 1), 1)
    seq <- substring(brca1seq, start, start + length - 1)
    seq <- strsplit(seq, "")[[1]]

    out <- NULL
    out[[1]] <- seq

    df <- data.frame(pos=1:length(seq),letter=seq)
    nPerms <- input$choices - 1
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
    df$Patient <- paste0("Patient",df$Number)
    df$Mutated <- do.call(c, lapply(seqList, function(x) x != seq))

    out[[2]] <- df
    out[[3]] <- seqList
    out[[4]] <- diffList
    out

  }
  )



  output$distPlot <- renderPlot({
    ##Seems like I have to define these defaults?
    start <- 41196312
    length<-10
    nPerms  <- 5
    seq <- generate.sequence()[[1]]

    df <- data.frame(pos=1:length(seq),letter=seq,Patient="Human Genome")
    df$letter <- factor(df$letter, levels= c("A","C","G","T"))
    useColour <- ifelse(input$useColour == "Yes",TRUE,FALSE)
    useText <- ifelse(input$useText == "Yes",TRUE,FALSE)

    if(useColour){
    gg <- ggplot(df, aes(x=pos,y=1,fill=letter,label=letter)) +geom_tile(position="identity")
    } else gg <- ggplot(df, aes(x=pos,y=1,label=letter)) +geom_tile(position="identity",fill="white")


    gg <- gg + scale_fill_manual(values=c("A" = as.character(mypal[3]),"C"=as.character(mypal[2]),"G"=as.character(mypal[6]),"T"=as.character(mypal[1])), drop = FALSE)
    gg <- gg + facet_wrap(~Patient)

    if(useText) gg <- gg + geom_text()

    gg <- gg + theme(axis.title.y=element_blank(),axis.text.y=element_blank(),axis.ticks.y=element_blank(),panel.background =  element_blank()) + theme(legend.position = "top", legend.title = element_blank())
    breaks <- data.frame(xs = c(0.5, 1:(length(seq))+0.5))
    gg <- gg + geom_vline(data=breaks, aes(xintercept=xs)) + xlab("")

    gg


    df <- generate.sequence()[[2]]
    df$letter <- factor(df$letter, levels= c("A","C","G","T"))

    if(useColour){
      gg2 <- ggplot(df, aes(x=pos,y=1,fill=letter,label=letter)) +geom_tile()
    } else   gg2 <- ggplot(df, aes(x=pos,y=1,label=letter)) +geom_tile(fill="white")

    if(useText) gg2 <- gg2 + geom_text()

    gg2 <- gg2 + scale_fill_manual(values=c("A" = as.character(mypal[3]),"C"=as.character(mypal[2]),"G"=as.character(mypal[6]),"T"=as.character(mypal[1]))) + ggtitle("Which patients show a mutation?")
    gg2 <- gg2 + facet_wrap(~Patient,ncol=1)
    gg2 <- gg2 + theme(axis.title.y=element_blank(),axis.text.y=element_blank(),axis.ticks.y=element_blank(),panel.background =  element_blank()) + theme(legend.position = "none")
    breaks <- data.frame(xs = rep(c(0.5, 1:(length(seq))+0.5),nPerms))
    gg2 <- gg2 + geom_vline(data=breaks, aes(xintercept=xs)) + xlab("")
    gg2

    grid.arrange(gg,gg2)

  })

  output$mutationPlot <- renderPlot({
    start <- 41196312
    length<-10
    nPerms  <- 5
    seq <- generate.sequence()[[1]]

    useColour <- ifelse(input$useColour == "Yes",TRUE,FALSE)
    useText <- ifelse(input$useText == "Yes",TRUE,FALSE)

    df <- data.frame(pos=1:length(seq),letter=seq,Patient="Human Genome")
    df$letter <- factor(df$letter, levels= c("A","C","G","T"))

    if(useColour){
      gg <- ggplot(df, aes(x=pos,y=1,fill=letter,label=letter)) +geom_tile(position="identity")
    }
    else gg <- ggplot(df, aes(x=pos,y=1,label=letter)) +geom_tile(position="identity",fill="white")

    if (useText) gg <- gg + geom_text()

    gg <- gg + scale_fill_manual(values=c("A" = as.character(mypal[3]),"C"=as.character(mypal[2]),"G"=as.character(mypal[6]),"T"=as.character(mypal[1])), drop = FALSE)
    gg <- gg + facet_wrap(~Patient)
    gg <- gg + theme(axis.title.y=element_blank(),axis.text.y=element_blank(),axis.ticks.y=element_blank(),panel.background =  element_blank()) + theme(legend.position = "top", legend.title = element_blank())
    breaks <- data.frame(xs = c(0.5, 1:(length(seq))+0.5))
    gg <- gg + geom_vline(data=breaks, aes(xintercept=xs)) + xlab("")

    gg

    df <- generate.sequence()[[2]]
    df$letter <- factor(df$letter, levels= c("A","C","G","T"))

    gg3 <- ggplot(df, aes(x=pos,y=1,fill=Mutated,label=letter)) +geom_tile()

    if(useText) gg3 <- gg3 + geom_text()

    gg3 <- gg3 + scale_fill_manual(values=c("TRUE" = as.character(mypal[8]),"FALSE"="white")) + ggtitle("The computer will analyse the sequence and show any mutated positions in pink")
    gg3 <- gg3 + facet_wrap(~Patient,ncol=1)
    gg3 <- gg3 + theme(axis.title.y=element_blank(),axis.text.y=element_blank(),axis.ticks.y=element_blank(),panel.background =  element_blank()) + theme(legend.position = "none")
    breaks <- data.frame(xs = rep(c(0.5, 1:(length(seq))+0.5),nPerms))
    gg3 <- gg3 + geom_vline(data=breaks, aes(xintercept=xs)) + xlab("")

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
