fluidPage(
    titlePanel("An app with the popular sidebar layout"),
    sidebarLayout(
        sidebarPanel(
            p("Arrange the controls in the sidebar"),
            sliderInput("ignored", "Some control", min=0, max=100, value=50)    
        ),
        mainPanel(
            p("Show a plot here ..."),
            p("Maybe another plot or some output ...")
        )
    )
)
