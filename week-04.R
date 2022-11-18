# Week 4 sync session
# Tidy verse
library(tidyverse)

f <- function(x){
  (x+2)^2
}

x <- 2
f(x)

# using forward pipe
x %>% f

rnorm(1000) %>% sin() %>% max()

# usual nested call stack
max(sin(rnorm(1000)))

# tibbles - suped up data frame



# reading in data with readr



# Data manipulation with dplyr

# filter = subset in base r
# slice = select row items by row numbers and ranges
# mutate = adds in new variables to dataset
# arrange = sort in base r
# join type commands = merge in base r


load(url("https://github.com/UofGAnalyticsData/R/raw/main/Week%204/velib"))
View(bikes)
View(stations)

# filtering data
stations %>% filter(departement=="Paris")

# slice data - first five records
stations %>% slice(1:5)

# select columns
stations %>% select(name, departement)

# add calc col
bikes <- bikes %>% mutate(total_stands = available_bikes + available_bike_stands)


bikes %>% group_by(name) %>%
  summarize(avg_stands=mean(available_bike_stands)) %>%
  arrange(desc(avg_stands)) %>%
  slice(1)

# Example question
load(url("https://github.com/UofGAnalyticsData/R/raw/main/Week%204/EURef.RData"))
head(brexit)
head(genelec)
wards_extended <- wards %>% inner_join(genelec, by="ConstituencyCode", suffix=c("Ward", "Const")) %>%
  mutate(LabVote/ElectorateConst * ElectorateWard,
         ConVote/ElectorateConst * ElectorateWard,
         LDVote/ElectorateConst * ElectorateWard,
         GreenVote/ElectorateConst * ElectorateWard,
         UKIPVote/ElectorateConst * ElectorateWard
         )

wards_extended <- wards %>% inner_join(genelec, by="ConstituencyCode", suffix=c("Ward", "Const")) %>%
  mutate_at(vars(ConVote:TotalVote), funs(./ElectorateConst*ElectorateWard))
