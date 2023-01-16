#
# This is the user-interface definition of a Shiny web application. You can
# run the application by clicking 'Run App' above.
#
# Find out more about building applications with Shiny here:
#
#    http://shiny.rstudio.com/
#

library(shiny)
weatherVariables <- c("Average wind speed in knots"="wind_speed",
                      "Air temperature measured in degrees centigrade"="air_temperature",
                      "Relative humidity, measured as a (%)"="rltv_hum",
                      "Visibility, measured in metres"="visibility")

weatherStations <- read_csv("data/Sites.csv") %>% arrange(Site_Name)

aggregations <- c("Raw hourly data (no aggregation)"="raw",
                  "Daily averages"="daily_average",
                  "Monthly averages"="monthly_average",
                  "Daily maxima"="daily_max",
                  "Daily minima"="daily_min")

timeAxes <- c("Calendar time"="calendar_time",
              "Weekday (0 to 7)"="weekday",
              "Hour in week (0 to 168)"="weekhour",
              "Hour in day (0 to 24)"="hour")

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
                               selected=head(weatherStations$Site_ID,5),
                               choiceNames=weatherStations$Site_Name,
                               choiceValues=weatherStations$Site_ID
            ),
            radioButtons("aggregation", "Select aggregation to plot:", 
                         selected="daily_average",
                         choices=aggregations
            ),
            radioButtons("timeAxis", "Select time axis type:", 
                         selected="weekday",
                         choices=timeAxes
            )
            #,            
            #actionButton("submit",
            #             "Submit") 
        ),
        # Show a plot 
        mainPanel(
            plotOutput("mainPlot"),
            plotOutput("locationPlot")
        )
    )
)
