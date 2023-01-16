# This file controls how the shiny app looks like

fluidPage(                              
  titlePanel("Our first Shiny app (modified)"),
  sidebarLayout(
      sidebarPanel(
          sliderInput("n",                        
                      "Number of observations"  , 
                      min=1, max=1000, step=1,    
                      value = 100                 
                      ),
          sliderInput("mu",                       
                      "Mean",                     
                      min=-10, max=10, step=0.1,  
                      value = 0                   
                      ),
          sliderInput("sigma",                    
                      "Standard deviation",       
                      min=0, max=5, step=0.1,   
                      value = 1                 
                      ),
          actionButton("simulate",                # Name of new action variable
                       "Simulate")                # Label shown on new button
      ),                
  
  # The main panel is typically used for displaying R output
      mainPanel(h2("Estimated Density" ),    
                plotOutput("densityPlot")         
                )
  )
)
