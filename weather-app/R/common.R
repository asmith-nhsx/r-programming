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