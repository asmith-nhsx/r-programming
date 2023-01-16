
library(tidyverse)
library(shiny)
library(maps)
library(lubridate)
source("R/common.R", local=TRUE)

server <- function(input, output, session) {

  observeEvent(input$aggregation,{
    # restrict time axis options
    # for monthly averages just allow calendar time
    # for raw hourly data do not allow weekday 
    options <- switch(input$aggregation,
                      "monthly_average"=timeAxes["Calendar time"],
                      "raw"=timeAxes[timeAxes != "weekday"],
                      timeAxes)
    
    updateRadioButtons(session, 
                       input="timeAxis", 
                       choices=options)
    
  })
  
  observeEvent(input$weatherStations,{
    # restrict options for hutton criteria 
    # to the selected weather stations
    selectedSites <- selectedSites()
    huttonSites <- selectedSites$Site_ID
    names(huttonSites) <- selectedSites$Site_Name
    updateSelectizeInput(session,
                         input="huttonSite",
                         choices=huttonSites)
  })

  selectedSites <- reactive({
    sites[sites$Site_ID %in% input$weatherStations,]
  })
  
  weatherData <- reactive({
    files <- paste0("data/Site_", selectedSites()$Site_ID, ".csv")
    do.call(rbind,(lapply(files, read.csv))) %>%
      # remove data for the non-existent leap day 29 Feb 2022!
      filter(!startsWith(ob_time, "29/02/2022")) %>% 
      inner_join(selectedSites(), by=c("Site"="Site_ID"))
  })
  
  weatherVariable.description <- reactive({
    names(weatherVariables[weatherVariables == input$weatherVariable])[1]
  })

  timeAxis.description <- reactive({
    names(timeAxes[timeAxes == input$timeAxis])[1]
  })
  
  aggregation.description <- reactive({
    names(aggregations[aggregations == input$aggregation])[1]
  })
  
  applyTime <- function(timeAxis, aggregate, sdate) {
    # convert string date to POSIXct date
    date <- dmy_hm(sdate)
    switch(timeAxis,
           "weekday"=wday(date),
           "weekhour"=wday(date)*24 + hour(date),
           "hour"=hour(date),
           switch(aggregate,
                  "monthly_average"=month(date),
                  "calendar_time"=date,
                  #return the date without a time component
                  as_date(date)))
  }
  
  applyAggregation <- function(aggregate, value) {
    switch(aggregate,
           "daily_average"=mean(value),
           "monthly_average"=mean(value), # time axis will be grouped by month
           "daily_max"=max(value),
           "daily_min"=min(value),
           value)    
  }
  
  output$mainPlot <- renderPlot({

    selectedSites <- selectedSites()

    validate(
      need(nrow(selectedSites)<=5, "Select 5 or fewer weather stations")
    )
    
    cat(file=stderr(), "Selected sites:", paste0(selectedSites$Site_Name), "\n")
    
    #cat(file=stderr(), "Drawing Main Plot...")
    plotData <- weatherData() %>%
      mutate(time=applyTime(input$timeAxis, input$aggregation, ob_time)) %>%
      group_by(Site, Site_Name, time) %>%
      summarise(agg_value=applyAggregation(input$aggregation, get(input$weatherVariable)))
    
    cat(file=stderr(), "Input:", input$weatherVariable, "\n")
    
    #plot(avg_temp~t, data=weatherData, col=Site, type="l")
    plot <- ggplot(plotData) +
      aes(x=time, y=agg_value, colour=Site_Name) + 
      labs(title=paste0(weatherVariable.description(), " ", aggregation.description()), 
           x=timeAxis.description(),
           y=weatherVariable.description())
    
    if (input$timeAxis == "calendar_time") {
      plot <- plot + geom_line()
    } else {
      plot <- plot + geom_point()     
    }

    return(plot)
  })
  
  output$locationPlot <- renderPlot({
    maps::map("world","UK")
    selectedSites <- selectedSites()
    points(sites$Longitude, sites$Latitude, pch=16, col="red")
    points(selectedSites$Longitude, selectedSites$Latitude, pch=16, col="blue")
  })
  
  recentData <- reactive({
    num_sites <- nrow(selectedSites())
    weatherData() %>% 
      mutate(time=dmy_hm(ob_time)) %>%
      arrange(desc(time)) %>%
      head(168 * num_sites) %>%
      group_by(Site, Site_Name, month, day) %>%
      summarise(across(unname(unlist(weatherVariables)), mean, .names = "mean_{.col}"))    
  })
  
  output$recentData <- renderDataTable({
    recentData()
  })
  
  output$huttonCriteria <- renderDataTable({
    weatherData() %>% 
      filter(Site == input$huttonSite & month == input$huttonMonth) %>%
      huttonCriteria()
  }, options=list(pageLength=31))
  
  output$downloadCSV <- downloadHandler(                                      
    filename = "weather-data.csv", 
    content = function(file) { 
      write.csv(recentData(), file, row.names=FALSE)
    }
  )

}
