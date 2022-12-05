# Week 9 - Sharing a reproducing work using Shiny package 


library(shiny)

fluidPage(
  titlePanel("Subsetting the motorcycle data"),
  sidebarLayout(
    sidebarPanel(
      p("Here is my sidebar"),
      sliderInput("range", "Subset range", min=0, max=60, value=c(0,60)),
      downloadButton("download1", "Download subset")
    ),
    mainPanel(
      plotOutput("plot1"),
      verbatimTextOutput("text1"),
      dataTableOutput("table1")
    )
  )
)
