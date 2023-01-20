# test the server is working and generating outputs without errors
testServer(expr = {
  suppressWarnings({
    session$setInputs(aggregation = "monthly_average", 
                      timeAxis = "calendar_time",
                      weatherVariable = "air_temperature",
                      weatherStations = c(971, 1450, 613, 1090, 315),
                      huttonSite = 971,
                      huttonMonth = 1)
    output$mainPlot
    output$locationPlot
    output$recentData
    output$huttonCriteria
    succeed("All server outputs generated")    
  })
})
