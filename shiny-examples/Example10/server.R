library(ggplot2)
library(MASS)

shinyServer(function(input, output) {

    mcycle2 <- reactive( {   # Define reactive object mcycle2
       subset(mcycle, times>=input$range[1] & times<=input$range[2]) 
#                  Label from ui.R ^^^^^                   ^^^^^
    } )
    
    
    output$plot1 <- renderPlot( {
        qplot(times, accel, data=mcycle2(), xlim=range(mcycle$times),
#                                ^^^^^^^^^ Get the reactive object              
              ylim=range(mcycle$accel)) + geom_smooth(method="lm")
    } )

    output$text1 <- renderPrint( {
        summary(mcycle2())
#               ^^^^^^^^^ Get the reactive object        
    } )

    output$table1 <- renderDataTable( {
        mcycle2()
#       ^^^^^^^^^ Get the reactive object
    } )

    output$download1 <- downloadHandler(                                                filename = "mcycle-subset.csv",
        content = function(file) {
            write.csv(mcycle2(), file, row.names=FALSE)
#                     ^^^^^^^^^ Get the reactive object
        }
    )    
   
}) 
