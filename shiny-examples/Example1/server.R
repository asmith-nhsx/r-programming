library(ggplot2)

# This file contains the code for performing calculations
# and controls how the shiny app looks like

shinyServer(function(input, output) {
    
    output$densityPlot <-  renderPlot( {
#          ^^^^^^^^^^^ Must be the name used in ui.R 
        n <- input$n                # Get n from slider
#                  ^ Must be the name used in ui.R
        mu <- input$mu              # Get mu from slider
#                   ^^ Must be the name used in ui.R
        sigma <- input$sigma        # Get sigma from slider
#                      ^^^^^ Must be the name used in ui.R                      
        x <- rnorm(n, mu, sigma)    # Generate sample   
        ggplot(data.frame(x = x), aes(x, col="estimated")) +
            geom_density() +
            geom_rug() + 
            xlim(-10,10) + 
            ylim(0,0.75) +                     # Plot the estimated density of the data ...
            stat_function(fun=function(x) dnorm(x, mu, sigma), aes(colour="exact"))
                                     # ... and add the true density
     })

})
