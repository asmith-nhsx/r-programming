fluidPage(
    titlePanel("Subsetting the motorcycle data"),
    sidebarLayout(
        sidebarPanel(
            sliderInput("range", "Subset range", min=0, max=60, value=c(0,60)),
#                        ^^^^^ Label used in server.R when querying slider
            downloadButton("download1", "Download subset", icon="download")
#                          ^^^^^^^^^^^  Label used in server.R when generating download
            
        ),
        mainPanel(
            plotOutput("plot1"),
#                       ^^^^^ Label used in server.R when updating plot                       
            verbatimTextOutput("text1"),
#                               ^^^^^ Label used in server.R when updating output
            dataTableOutput("table1")
#                            ^^^^^^ Label used in server.R when updating table
        )
    )
)
