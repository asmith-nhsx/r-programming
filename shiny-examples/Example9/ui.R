fluidPage(
    titlePanel("Subsetting the motorcycle data"),
    sidebarLayout(
        sidebarPanel(
            sliderInput("range", "Subset range", min=0, max=60, value=c(0,60)),
            radioButtons("outputType", "Select output type",
                         choices=c("Plot", "Summary", "Table"), selected="Plot")
        ),
        mainPanel(
            uiOutput("ui")   # Put adaptive UI component here
        )
    )
)
