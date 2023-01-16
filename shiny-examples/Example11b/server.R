library(ggplot2)

shinyServer(function(input, output) {
    
    observeEvent(input$simulate, {    # Run this code if simulate button is pressed
        output$densityPlot <-  renderPlot( {
            n <- isolate(input$n)         # Prevent dependency on n 
            mu <- isolate(input$mu)       # Prevent dependency on mu
            sigma <- isolate(input$sigma) # Prevent dependency on sigma
            x <- rnorm(n, mu, sigma)    
            qplot(x, geom="density", col="estimated") +
                geom_rug() + xlim(-10,10) + ylim(0,0.75) +                         
                stat_function(fun=function(x) dnorm(x, mu, sigma), 
                              aes(colour="exact"), inherit.aes = FALSE)
        })
        
    }, ignoreNULL=FALSE)              # ignoreNULL=FALSE triggers the event
                                      # when the app starts (otherwise no
                                      # density would be initially visible)

})
