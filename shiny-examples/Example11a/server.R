library(ggplot2)

shinyServer(function(input, output) {
    
    output$densityPlot <-  renderPlot( {
        input$simulate                # Force dependency on the button
        n <- isolate(input$n)         # Prevent dependency on n 
        mu <- isolate(input$mu)       # Prevent dependency on mu
        sigma <- isolate(input$sigma) # Prevent dependency on sigma
        x <- rnorm(n, mu, sigma)   
        qplot(x, geom="density", col="estimated") +
            geom_rug() + xlim(-10,10) + ylim(0,0.75) +                     
            stat_function(fun=function(x) dnorm(x, mu, sigma), 
                          aes(color="exact"), inherit.aes=FALSE)
     })

})
