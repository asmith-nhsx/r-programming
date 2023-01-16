library(ggplot2)
library(MASS)

shinyServer(function(input, output) {
    
    output$plot1 <- renderPlot( {
#          ^^^^^ Label from ui.R
        mcycle2 <- subset(mcycle, times>=input$range[1] & times<=input$range[2])
#                               Label from ui.R ^^^^^                   ^^^^^
        qplot(times, accel, data=mcycle2, xlim=range(mcycle$times),
              ylim=range(mcycle$accel)) + geom_smooth(method="lm")
    } )

    output$text1 <- renderPrint( {
#          ^^^^^ Label from ui.R
        mcycle2 <- subset(mcycle, times>=input$range[1] & times<=input$range[2])
#                               Label from ui.R ^^^^^                   ^^^^^
        summary(mcycle2)
    } )

    output$table1 <- renderDataTable( {
#          ^^^^^ Label from ui.R
        subset(mcycle, times>=input$range[1] & times<=input$range[2])
#                   Label from ui.R ^^^^^                   ^^^^^
    } )

    output$download1 <- downloadHandler(                                        #          ^^^^^^^^^ Label from ui.R
        filename = "mcycle-subset.csv", # Filename shown to user in browser
        content = function(file) { # Function to generate the download file
            mcycle2 <- subset(mcycle, times>=input$range[1] & times<=input$range[2])
#                                  Label from ui.R ^^^^^                   ^^^^^
            write.csv(mcycle2, file, row.names=FALSE)
        }
    )
}) 
