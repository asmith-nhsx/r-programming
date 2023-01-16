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