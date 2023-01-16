library("tidyverse")
library("lubridate")
sites <- read_csv("data/Sites.csv", ) %>% 
  arrange(Site_Name) %>% 
  head(5)

cat(paste0(sites$Site_Name,","))

files <- paste0("data/Site_", sites$Site_ID, ".csv")
data <- do.call(rbind,(lapply(files, read.csv)))
weatherData <- data %>% 
  filter(!startsWith(ob_time, "29/02/2022")) %>% 
  inner_join(sites, by=c("Site"="Site_ID")) %>% 
  mutate(time=wday(dmy_hm(ob_time))) %>%
  group_by(Site, Site_Name, month, day, time) %>%
  summarise(avg_temp=mean(air_temperature))

#plot(avg_temp~t, data=weatherData, col=Site, type="l")
ggplot(weatherData) +
  aes(x=time, y=avg_temp, colour=Site_Name) + 
  geom_point()

data[is.na(data$ob_time)]$ob_time

parse_dmy_hm = function(x){
  d=lubridate::dmy_hm(x, quiet=TRUE)
  errors = x[!is.na(x) & is.na(d)]
  if(length(errors)>0){
    cli::cli_warn("Failed to parse some dates: {.val {errors}}")
  }
  d
}
data2 <- data %>% 
  filter(!startsWith(ob_time, "29/02/2022"))

parse_dmy_hm(data2$ob_time)


recentData <- data %>% 
  filter(!startsWith(ob_time, "29/02/2022")) %>% 
  inner_join(sites, by=c("Site"="Site_ID")) %>% 
  mutate(time=dmy_hm(ob_time)) %>%
  arrange(desc(time)) %>%
  head(168 * 5) %>%
  group_by(Site, Site_Name, month, day) %>%
  summarise(across(unname(unlist(weatherVariables)), mean, .names = "mean_{.col}"))

