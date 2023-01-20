# Test the common functions used by the shiny app

# working directory will be tests/testthat set by framework 
# have to go up 2 levels to the app directory
setwd("../..") 

test_that("common.selectedSites returns correct sites", {
  # arrange
  selected <- c(971, 1450, 613, 1090, 315)
  # act
  result <- common.selectedSites(selected)
  # assert
  expect_equal(dim(result), c(5, 4))
  expect_length(selected[!(selected %in% result$Site_ID)], 0)
})

test_that("common.weatherData returns expected data", {
  # arrange
  siteId <- 971
  expected <- read.csv(paste0("data/Site_", siteId, ".csv"))
  selectedSites <- data.frame(Site_ID = 971, 
                              Site_Name = "Abbotsinch", 
                              Latitude = 55.8695, 
                              Longitude = -4.42948)
  # act
  result <- common.weatherData(selectedSites)
  # assert
  expect_length(result[result$Site_ID!=siteId], 0)
  # 24 rows are filtered out for bad date 29 Feb 2022
  expect_equal(dim(result), 
               c(nrow(expected) - 24, # 24 rows are filtered out for bad date 29 Feb 2022
                 ncol(expected) + 3)) # 3 additional columns for joining back on site
})


test_that("common.paramDescription returns option label", {
  # arrange
  choices <- c("Option 1"=1,"Option 2"=2)
  # act
  result <- common.paramDescription(choices, 2)
  # assert
  expect_equal("Option 2", result)
})


test_that("common.applyTime returns the correct time variable", {
  # arrange
  timeAxis <- c("calendar_time", "calendar_time", "calendar_time", "hour", "weekhour", "weekday")
  aggregate <-c("daily_max", "raw", "monthly_average", "", "", "")
  sdate <- "20/01/2022 09:48"
  expected <- list(dmy("20/01/2022"), dmy_hm("20/01/2022 09:48"), 1, 9, 24*3+9, 4)
  for (i in 1:6) {
    # act
    result <- common.applyTime(timeAxis[i], aggregate[i], sdate)
    # assert
    expect_equal(expected[[i]], result)
  }
})

common.applyAggregation


test_that("common.applyAggregation applies the correct aggregate function", {
  # arrange
  aggregate <-c("daily_max", "daily_min", "daily_average", "monthly_average", "raw", "")
  input <- c(1,2,3)
  expected <- list(3, 1, 2, 2, c(1,2,3), c(1,2,3))
  for (i in 1:6) {
    # act
    result <- common.applyAggregation(aggregate[i], input)
    # assert
    expect_equal(expected[[i]], result)
  }
})


test_that("common.getPlotData groups and summarises data correctly", {
  # arrange
  siteId <- 971
  data <- read.csv(paste0("data/Site_", siteId, ".csv"))
  selectedSites <- data.frame(Site_ID = 971, 
                              Site_Name = "Abbotsinch", 
                              Latitude = 55.8695, 
                              Longitude = -4.42948)
  weatherData <- data %>% 
                filter(!startsWith(ob_time, "29/02/2022")) %>% 
                inner_join(selectedSites, by=c("Site"="Site_ID"))
  
  timeAxis = "calendar_time"
  aggregation = "monthly_average"
  weatherVariable = "rltv_hum"
  
  expected <- weatherData %>%
    mutate(time=month) %>% #time axis should be by month
    group_by(Site, Site_Name, time) %>%
    summarise(agg_value=mean(rltv_hum)) #aggregate should be average humidity
  
  #act
  result = common.getPlotData(weatherData,
                              timeAxis,
                              aggregation,
                              weatherVariable)
  
  #assert
  expect_equal(expected, result)
  
})


test_that("common.recentData returns the correct data", {
  # arrange
  data1 <- tibble(ob_time="01/01/2022 00:00",
                      month=1,
                      day=1,
                      wind_speed=2,
                      air_temperature=15,
                      rltv_hum=98,
                      visibility=500,
                      Site=917,
                      Site_Name="Site1")
  
  data2 <- tibble(ob_time="01/01/2022 00:00",
                     month=1,
                     day=1,
                     wind_speed=4,
                     air_temperature=0,
                     rltv_hum=80,
                     visibility=100,
                     Site=918,
                     Site_Name="Site2") 
  data <- rbind(data1, data2)
  weatherData <- data %>% slice(rep(1:n(), each=24))
  numSites <- 2
  days <- 1
  # act
  result <- common.recentData(weatherData, numSites, days)
  # assert
  expect_equal(2, nrow(result))
  for (i in 1:2) {
    expect_equal(data[i,]$wind_speed, result[i,]$mean_wind_speed)
    expect_equal(data[i,]$air_temperature, result[i,]$mean_air_temperature)
    expect_equal(data[i,]$rltv_hum, result[i,]$mean_rltv_hum)
    expect_equal(data[i,]$visibility, result[i,]$mean_visibility)    
  }

})