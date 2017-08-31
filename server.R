library(shiny)
library(ggplot2)

shinyServer(function(input, output) {
   
  output$distPlot <- renderPlot({
      myplots <- list()
      for(i in 1:4) {
          local({
              i <- i
              m <- backoff_prediction(tolower(input$text), i)
              title <- paste("Top Predicted Next Words for", names[[i]], sep = " ")
              p <- ggplot(m, aes(reorder(m[[1]], m[[2]]), m[[2]])) +   
                  geom_bar(stat="identity") + coord_flip() + 
                  xlab("Next Words") + ylab("Frequency") +
                  ggtitle(title)
              myplots[[i]] <<- p
          })
      }
      
      multiplot(plotlist = myplots, cols=2)
    
  })
  
})
