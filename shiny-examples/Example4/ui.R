fluidPage(
    titlePanel("An app using the Bootstrap grid system"),
    fluidRow(
        column(6,
           h4("A wide column"),
           p("Try making the browser window a lot narrower and see what happens ...z")               
        ),
        column(3,
            h4("A narrow column")
        ),    
        column(3,
            wellPanel(
                h4("A narrow column in a well")
            )
        )    
    ),
    fluidRow(
        column(3,
            wellPanel(
                h4("Another narrow column in a well")
          )
        ),
        column(9,
           h4("This is now a really wide column")
        )
    )
)
