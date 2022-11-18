# quiz 2
load(url("https://github.com/UofGAnalyticsData/R/raw/main/Assignment%202/got.RData"))

# Q1 - Find the number of characters from house "Lannister".

characters %>%
  filter(houseName=="Lannister") %>%
  nrow

nrow(characters)
head(characters)
nrow(filter(characters, houseName=="Lannister"))

# Q2 Print who killed "Joffrey Baratheon".
kills %>%
  filter(name=="Joffrey Baratheon") %>%
  select(killedBy)

#Q3 Add a column northener to the data frame characters which is TRUE 
# if the house is "Mormont", "Bolton" or "Stark", and otherwise FALSE.
characters <- characters %>%
  mutate(northerner = (houseName =="Mormont" | 
                       houseName == "Bolton" | 
                       houseName == "Stark") & 

# Q4 For each scene in the first episode of season 1 find the number of characters 
#  appearing in it.
# Visualise this information in a bar chart. Your plot should look similar to 
# the one shown below.
# For this part, you can use  either "classical" plotting functions or ggplot2

eps <- appearances %>% inner_join(scenes, by=c("scene"="id"))


head(ep1)

ep1 <- eps %>% filter(episode=="S1E01")


ggplot(data=ep1) +
  geom_bar(aes(x=number))

head(appearances)


scenes %>% group_by(episode) %>% 
  summarise(total_scenes=n()) %>% 
  arrange(desc(total_scenes)) %>%
  slice(1)


scenes.duration <- scenes %>% inner_join(episodes, by=c("episode"="id")) %>%
  group_by(season,episode) %>% 
  summarise(total_scenes=n(), total_duration=sum(duration))

head(scenes.duration)
ggplot(scenes.duration) +
  aes(x=total_duration,y=total_scenes) +
  geom_point(aes(colour=season)) +
  theme_minimal()


load(url("https://github.com/UofGAnalyticsData/R/raw/main/Assignment%202/Rainfall_Year.RData"))

# Calculate the average rainfall for each region across all years and months. 

rainfall.long <-  rainfall %>% 
  pivot_longer(cols=3:188,names_to = "year",values_to = "amount")

rainfall.long %>% 
  group_by(year) %>% 
  summarise(avg_rainfall=mean(amount))


moves <- rbind(c( 1, 0),              # There are four possible moves
               c(-1, 0),              # right, left, up and down
               c( 0, 1),
               c( 0,-1))
n <- 100                              # Number of steps            
choices <- sample(4, n, replace=TRUE) # Choose which step type for each step
selected.moves <- moves[choices,]     # Translate to moves
coords <- cbind(x=cumsum(selected.moves[,1]), y=cumsum(selected.moves[,2]))


# Translate to coordinates

# ggplot
df <- as.data.frame(coords)
ggplot(df) +
  aes(x=x,y=y) +
  geom_point() +
  geom_path() +
  ggtitle("Spatial Random Walk")

# base R
plot(coords)
title("Spatial Random Walk")
lines(coords)

load(url("https://github.com/UofGAnalyticsData/R/raw/main/Assignment%202/got.RData"))
scenes.duration <- scenes %>% inner_join(episodes, by=c("episode"="id")) %>%
  mutate(season=factor(season)) %>%
  group_by(season,episode) %>% 
  summarise(total_scenes=n(), total_duration=sum(duration))

ggplot(scenes.duration) +
  aes(x=total_duration,y=total_scenes,colour=season) +
  geom_point()
