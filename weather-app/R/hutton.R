library(tidyverse)

huttonCriteria <- function(x) {
  
  if (!is.data.frame(x)) {
    stop("huttonCriteria only works with a data frame")
  }
  if (!all(c('month','day','hour','air_temperature','rltv_hum') %in% names(x))) {
    stop("huttonCriteria expects 'month', 'day', 'hour', 'air_temperature' and 'rltv_hum' columns")
  }
  if (!all(c('air_temperature','rltv_hum') 
           %in% names(x)[sapply(x,is.numeric)])) {
    stop("huttonCriteria expects 'air_temperature' and 'rltv_hum' columns to contain numeric data")
  }
  return (
    x %>% group_by(month,day) %>%
          summarize(min_temp=min(air_temperature),
                    above_90 = sum(rltv_hum >= 90, na.rm = TRUE)) %>% 
          ungroup() %>%
          mutate(hutton = lag(min_temp, n = 2) >= 10 & 
                   lag(min_temp) >= 10 &
                   lag(above_90, n = 2) >= 6 &
                   lag(above_90) >= 6)
  )
}
