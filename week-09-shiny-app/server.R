library(ggplot2)
library(MASS)

shinyServer(function(input, output){
  
  # refactor for reactive component
  mcycle2 <- reactive({
    subset(mcycle, times>=input$range[1] & times<=input$range[2])
  })
  
  output$plot1 <- renderPlot( {
    #mcycle2 <- subset(mcycle, times>=input$range[1] & times<=input$range[2])
    
    qplot(times, accel, data=mcycle2(), xlim=range(mcycle$times),
          ylim=range(mcycle$accel)) + geom_smooth(method="lm")
    
  })
  
  output$text1 <- renderPrint( {
    #mcycle2 <- subset(mcycle, times>=input$range[1] & times<=input$range[2])
    
    summary(mcycle2())
    
  })
  
  output$table1 <- renderDataTable({
    #subset(mcycle, times>=input$range[1] & times<=input$range[2])
    mcycle2()
  })
  
  
  output$download1 <- downloadHandler(
    filename = 'mcycle-subset.csv',
    content = function(file) {
      #mcycle2 <- subset(mcycle, times>=input$range[1] & times<=input$range[2])
      write.csv(mcycle2(), file, row.names = FALSE)
    }
  )
  
})