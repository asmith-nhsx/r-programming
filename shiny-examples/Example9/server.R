library(ggplot2)
library(MASS)

shinyServer(function(input, output) {

    output$ui <- renderUI( { # Add the output component  based on the user's choice
        if (input$outputType=="Plot")
            output <- plotOutput("plot1")
        if (input$outputType=="Summary")
            output <- verbatimTextOutput("text1")
        if (input$outputType=="Table")
            output <- dataTableOutput("table1")
        output        
    } )
    
    output$plot1 <- renderPlot( {
        mcycle2 <- subset(mcycle, times>=input$range[1] & times<=input$range[2])
        qplot(times, accel, data=mcycle2, xlim=range(mcycle$times),
              ylim=range(mcycle$accel)) + geom_smooth(method="lm")
    } )

    output$text1 <- renderPrint( {
        mcycle2 <- subset(mcycle, times>=input$range[1] & times<=input$range[2])
        summary(mcycle2)
    } )

    output$table1 <- renderDataTable( {
        subset(mcycle, times>=input$range[1] & times<=input$range[2])
    } )
   
}) 
