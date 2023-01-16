# This file controls how the shiny app looks like

fluidPage(                              

  # Title of your app (at top, spread across entire page)
  titlePanel("Our first Shiny app"),

  # Typically the controls are arranged in a sidebar on the left
  sidebarLayout(
      sidebarPanel(
          sliderInput("n",                        # Name of the variable
#                     ^^^ This name will be referred to in server.R
                      "Number of observations"  , # Label shown
                      min=1, max=1000, step=1,    # Range and (optional) step size
                      value = 100                 # Initial value
                      ),
          sliderInput("mu",                       # Name of the variable 
#                     ^^^^ This name will be referred to in server.R
                      "Mean",                     # Label shown
                      min=-10, max=10, step=0.1,  # Range and (optional) step size
                      value = 0                   # Initial value
                      ),
          sliderInput("sigma",                    # Name of the variable 
#                     ^^^^^^^ This name will be referred to in server.R
                      "Standard deviation",       # Label shown
                      min=0, max=5, step=0.1,     # Range and (optional) step size
                      value = 1                   # Initial value
                      )
      ),                
  
  # The main panel is typically used for displaying R output
      mainPanel(h2("Estimated Density" ),    
                plotOutput("densityPlot")         # We'll put a plot here
#                          ^^^^^^^^^^^^^ This name will be referred to in server.R            
                )
  )
)
