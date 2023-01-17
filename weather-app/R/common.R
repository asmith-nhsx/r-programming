library(tidyverse)
library(shiny)
library(maps)
library(lubridate)
library(rmarkdown)

sites <- read.csv("data/Sites.csv") %>% arrange(Site_Name)

weatherStations <- sites$Site_ID
names(weatherStations) <- sites$Site_Name

weatherVariables <- c("Average wind speed (knots)"="wind_speed",
                      "Air temperature (degrees centigrade)"="air_temperature",
                      "Relative humidity (%)"="rltv_hum",
                      "Visibility (metres)"="visibility")

aggregations <- c("Raw hourly data (no aggregation)"="raw",
                  "Daily averages"="daily_average",
                  "Monthly averages"="monthly_average",
                  "Daily maxima"="daily_max",
                  "Daily minima"="daily_min")

timeAxes <- c("Calendar time"="calendar_time",
              "Weekday (0 to 7)"="weekday",
              "Hour in week (0 to 168)"="weekhour",
              "Hour in day (0 to 24)"="hour")

months <- 1:12
names(months) <- month.name

#' select weather station sites 
#' @param weatherStations list of site ids to select 
#' @return the selected sites 
common.selectedSites <- function(weatherStations) {
  sites[sites$Site_ID %in% weatherStations,]
}

#' read in weather data from selected sites 
#' @param selectedSites data frame of selected weather station sites 
#' @return data frame of all weather data from the selected sites 
common.weatherData <- function(selectedSites) {
  files <- paste0("data/Site_", selectedSites$Site_ID, ".csv")
  do.call(rbind,(lapply(files, read.csv))) %>%
    # remove data for the non-existent leap day 29 Feb 2022!
    filter(!startsWith(ob_time, "29/02/2022")) %>% 
    inner_join(selectedSites, by=c("Site"="Site_ID"))
}

#' return the human friendly description of the selected parameter 
#' @param choices vector of parameter options  
#' @param selected value of the selected parameter
#' @return description for the selected parameter 
common.paramDescription <- function(choices, selected) {
  names(choices[choices == selected])[1]
}

#' convert string dates to appropriate time variable 
#' @param timeAxis selected time axis   
#' @param aggregate selected aggregation
#' @param sdata string date in format dd/mm/yy hh:mm
#' @return description for the selected parameter 
common.applyTime <- function(timeAxis, aggregate, sdate) {
  # convert string date to POSIXct date using lubridate
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

#' apply appropriate summary aggregation function   
#' @param aggregate selected aggregation
#' @param value variable value to aggregate
#' @return result of the aggregation 
common.applyAggregation <- function(aggregate, value) {
  switch(aggregate,
         "daily_average"=mean(value),
         "monthly_average"=mean(value), # time axis will be grouped by month
         "daily_max"=max(value),
         "daily_min"=min(value),
         value)    
}

#' plot the weather data   
#' @param weatherData base weather data to plot
#' @param timeAxis choice of time axis
#' @param aggregation choice of aggregation
#' @param weatherVariable choice of weather variable
#' @return plot of weather data
common.mainPlot <- function(weatherData, 
                            timeAxis,
                            aggregation, 
                            weatherVariable) {
  
  # group and summarise the weather data based on the parameter choices
  plotData <- weatherData %>%
    mutate(time=common.applyTime(timeAxis, aggregation, ob_time)) %>%
    group_by(Site, Site_Name, time) %>%
    summarise(agg_value=common.applyAggregation(aggregation, get(weatherVariable)))
  
  # fetch descriptions for the selected parameter choices
  timeAxis.description <- common.paramDescription(timeAxes, timeAxis)  
  aggregation.description <- common.paramDescription(aggregations, aggregation)
  weatherVariable.description <- common.paramDescription(weatherVariables, weatherVariable)

  # plot the data with appropriate axis labels
  plot <- ggplot(plotData) +
    aes(x=time, y=agg_value, colour=Site_Name) + 
    labs(title=paste0(weatherVariable.description, " ", aggregation.description), 
         x=timeAxis.description,
         y=weatherVariable.description)
  
  # set plot type based on choice of time axis
  if (timeAxis == "calendar_time") {
    plot <- plot + geom_line()
  } else {
    plot <- plot + geom_point()     
  }
  
  return(plot)
  
}

#' daily average weather data for all selected sites over recent days
#' @param weatherData base weather data for all selected sites
#' @param numSites the number of selected sites
#' @param days the number of days data to return 
#' @return daily averages for all weather variables at the selected sites
common.recentData <- function(weatherData, numSites, days) {
  weatherData %>% 
    mutate(time=dmy_hm(ob_time)) %>%
    arrange(desc(time)) %>%
    # the data for each site is recorded hourly
    head(days * 24 * numSites) %>%
    group_by(Site, Site_Name, month, day) %>%
    summarise(across(unname(unlist(weatherVariables)), mean, .names = "mean_{.col}")) 
}