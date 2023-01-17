
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
    common.selectedSites(input$weatherStations)
  })
  
  weatherData <- reactive({
    common.weatherData(selectedSites())
  })
  
  output$mainPlot <- renderPlot({

    selectedSites <- selectedSites()

    validate(
      need(nrow(selectedSites)<=5, "Select 5 or fewer weather stations")
    )
    
    common.mainPlot(weatherData(),
                    input$timeAxis,
                    input$aggregation,
                    input$weatherVariable)
  })
  
  output$locationPlot <- renderPlot({
    maps::map("world","UK")
    points(sites$Longitude, sites$Latitude, pch=16, col="red")
    points(selectedSites()$Longitude, selectedSites()$Latitude, pch=16, col="blue")
  })
  
  output$recentData <- renderDataTable({
    common.recentData(weatherData(), nrow(selectedSites()), 7)
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
  
  output$downloadReport <- downloadHandler(
    filename = "report.docx",
    content = function(file) {
      render("report.Rmd", output_format="word_document",
             output_file=file, params=list(weatherStations=input$weatherStations,
                                           timeAxis=input$timeAxis,
                                           aggregation=input$aggregation,
                                           weatherVariable=input$weatherVariable))
    }
  )
}
