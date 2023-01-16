fluidPage(
    titlePanel("An app with two tabs in the main panel"),
    sidebarLayout(
        sidebarPanel(
            p("Arrange the controls in the sidebar"),
            sliderInput("ignored", "Some control", min=0, max=100, value=50)    
        ),
        mainPanel(
            tabsetPanel(
                tabPanel("Plot",
                         p("Show a plot here ..."),
                         p("Click on the tab titles to change tabs ...")
                         ),
                tabPanel("Other output",
                          p("Another plot or some output ...")
                         )
            )
        )
    )
)
