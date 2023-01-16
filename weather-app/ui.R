library(shiny)
source("R/common.R", local=TRUE)

# Define UI for application that draws a histogram
ui <- fluidPage(

  # Application title
  titlePanel("My First Shiny Weather App"),

  # Sidebar with a slider input for number of bins
  sidebarLayout(
    sidebarPanel(
      radioButtons("weatherVariable", "Weather variable:", 
                   selected="air_temperature",
                   choices=weatherVariables
      ),
      checkboxGroupInput("weatherStations", "Weather stations (select 5):",
                         selected=head(weatherStations,5),
                         choices=weatherStations
      ),
      radioButtons("aggregation", "Select aggregation to plot:", 
                   selected="daily_average",
                   choices=aggregations
      ),
      radioButtons("timeAxis", "Select time axis type:", 
                   selected="weekday",
                   choices=timeAxes
      ),
      downloadButton("downloadCSV", "Download CSV"),
      downloadButton("downloadWord", "Download Word Report")      
    ),
    # Show a plot 
    mainPanel(
      tabsetPanel(
        tabPanel("Main",
          plotOutput("mainPlot"),
          plotOutput("locationPlot"),
          dataTableOutput("recentData")
        ),
        tabPanel("Hutton Criteria",
          selectizeInput("huttonSite", "Site:",
                        choices=NULL),
          selectizeInput("huttonMonth", "Month:",
                        choices=months),
          dataTableOutput("huttonCriteria")
        )        
      )
    )
  )
)
