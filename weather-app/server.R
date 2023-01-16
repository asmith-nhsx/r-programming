#
# This is the server logic of a Shiny web application. You can run the
# application by clicking 'Run App' above.
#
# Find out more about building applications with Shiny here:
#
#    http://shiny.rstudio.com/
#

library(shiny)
library(maps)

# Define server logic required to draw a histogram
server <- function(input, output, session) {

  sites <- reactive({
    cat(file=stderr(), "Loading sites...")
    read_csv("data/Sites.csv", ) %>% arrange(Site_Name)
  })
  
  selectedSites <- reactive({
    sites <- sites()
    sites[sites$Site_ID %in% input$weatherStations,]
  })
  
  weatherData <- reactive({
    files <- paste0("data/Site_", selectedSites()$Site_ID, ".csv")
    do.call(rbind,(lapply(files, read.csv)))
  })
  
  
  output$mainPlot <- renderPlot({

    selectedSites <- selectedSites()
    
    validate(
      need(length(selectedSites)<=5, "Select 5 or fewer weather stations")
    )
    
    cat(file=stderr(), "Selected sites:", selectedSites)
    cat(file=stderr(), "Drawing Main Plot...")
    
    sites <- read_csv("data/Sites.csv", ) %>% arrange(Site_Name) %>% head(5)
    files <- paste0("data/Site_", sites$Site_ID, ".csv")
    data <- do.call(rbind,(lapply(files, read.csv)))
    weatherData <- data %>% inner_join(sites, by=c("Site"="Site_ID")) %>% 
      group_by(Site,Site_Name,month,day) %>%
      summarise(avg_temp=mean(air_temperature), t=min(as.Date(ob_time)))
    
    #plot(avg_temp~t, data=weatherData, col=Site, type="l")
    ggplot(weatherData) +
      aes(x=t, y=avg_temp, colour=Site_Name) + 
      geom_line()

  })
  
  output$locationPlot <- renderPlot({
    maps::map("world","UK")
    sites <- sites()
    selectedSites <- selectedSites()
    points(sites$Longitude, sites$Latitude, pch=16, col="red")
    points(selectedSites$Longitude, selectedSites$Latitude, pch=16, col="blue")
  })

}
