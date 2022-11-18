# Week 6 - Using ggplot in R

# https://github.com/UofGAnalyticsData/R/raw/main/Week%206/w6.RData

library(tidyverse)

# geom = geometry element - type of plot
# aes = aesthetics element - color, lines, symbols etc.

load(url("https://github.com/UofGAnalyticsData/R/raw/main/Week%205/w5.RData"))

# quick plot for easy plotting
qplot(HealthExpenditure, LifeExpectancy, data=health, colour=Region, size=Population)


# basic structure of ggplot command
# ggplot(data=) + aes() + geo 

# same command as quick plot done as full ggplot
ggplot(data=health) + aes(x=HealthExpenditure, y=LifeExpectancy) + 
  geom_point(aes(colour=Region, size=Population))


# fit a line with a "linear model" = "lm" with a logarithmic x axis
ggplot(data=health) + aes(x=HealthExpenditure, y=LifeExpectancy) + 
  geom_point(aes(colour=Region, size=Population)) +
  geom_smooth(method="lm") +
  scale_x_log10()


# move the grouping (colour) to the general aesthetic so that the fitting
# function fits lines to every region group
ggplot(data=health) + aes(x=HealthExpenditure, y=LifeExpectancy, colour=Region) + 
  geom_point(aes(size=Population)) +
  geom_smooth(method="lm") +
  scale_x_log10()

# add in general title and axis labels
ggplot(data=health) + aes(x=HealthExpenditure, y=LifeExpectancy, colour=Region) + 
  geom_point(aes(size=Population)) +
  geom_smooth(method="lm") +
  scale_x_log10() +
  ggtitle("Relationship between Health Expenditure and Life Expectancy") +
  xlab("Health Expenditure") +
  ylab("Life Expectancy")

# best way to update the legend is to change the factors in the data frame 
# rather than trying to hack the plot

# add colour palette using scale_colour_distiller
# (use scale_colour_brewer for discrete data)
# resource for colour palettes
# https://colorbrewer2.org/#type=sequential&scheme=BuGn&n=3
ggplot(data=health) + aes(x=HealthExpenditure, y=LifeExpectancy) + 
  geom_point(aes(colour=Population)) +
  scale_color_distiller(palette = "Yl0rRd", trans="log") +
  ggtitle("Relationship between Health Expenditure and Life Expectancy") +
  xlab("Health Expenditure") +
  ylab("Life Expectancy")

# control theme and fix the text direction on the x-axis to stop overlapping
# labels
ggplot(data=health) +
  geom_bar(aes(x=Region)) +
  theme(axis.text.x = element_text(angle = 90, hjust = 1))

# with built in minimal theme
ggplot(data=health) + aes(x=HealthExpenditure, y=LifeExpectancy) + 
  geom_point(aes(colour=Population)) +
  scale_color_distiller(palette = "Yl0rRd", trans="log") +
  ggtitle("Relationship between Health Expenditure and Life Expectancy") +
  xlab("Health Expenditure") +
  ylab("Life Expectancy") +
  theme_minimal()


# create individual "facet" plots for each region
ggplot(data=health) + aes(x=HealthExpenditure, y=LifeExpectancy, colour=Region) + 
  geom_point(aes(size=Population)) +
  geom_smooth(method="lm") +
  scale_x_log10()+
    facet_wrap(~Region)


# Review exercise
load(url("https://github.com/UofGAnalyticsData/R/raw/main/Week%206/t3.RData"))

# a) create plot of per capita GDP in UK from 1995 to 2010
# use back ticks for column name as it contains spaces
ggplot(data=EU) +
  geom_line(aes(Year, `United Kingdom`)) +
  ylab("Per Capita GDP") +
  ggtitle("Per Capita GDP in PPS (UK)")


# b) Change the code to show the data from all countries
# transform data into long format from wide format
EU.long <- EU %>% pivot_longer(cols=2:8, names_to="Country", values_to="GDP")
head(EU.long)
ggplot(data=EU.long) +
  geom_line(aes(Year, GDP, colour=Country)) +
  ylab("Per Capita GDP") +
  ggtitle("Per Capita GDP in PPS")

# c) normalise data for each country in the year 2000 and see how this has changed

EU.long.2000 <- EU.long %>% filter(Year==2000)

EU.long.rel <- EU.long %>% inner_join(EU.long.2000, by="Country", suffix=c("","_2000")) %>%  
    mutate(relGDP=GDP/GDP_2000) %>%
    # have to specify deplyr version of select
    dplyr::select(Year, Country, relGDP)
head(EU.long.rel)

ggplot(data=EU.long.rel) +
  geom_line(aes(Year, relGDP, colour=Country)) +
  geom_vline(xintercept=2000, linetype=2)

# review exercise - task 1
library(MASS)

ggplot(data=hills) +
  aes(x=dist,y=time) +
  geom_ribbon(aes(ymax=7.1728*dist,ymin=8.6437*dist), fill="lightgrey") +  
  geom_point() +
  geom_line(aes(y=7.908*dist), size=1) +
  geom_line(aes(y=7.908 * dist - 0.7355 * sqrt(3021.25 + dist^2)), 
            linetype=2) +
  geom_line(aes(y=7.908 * dist + 0.7355 * sqrt(3021.25 + dist^2)), 
            linetype=2) + 
  xlab("Distance (miles)") +
  ylab("Time (min)") +
  ggtitle("Hill Races in Scotland")

# review exercise - task 2
# (a) Create a bar plot showing the number of stations in each city.
ggplot(data=stations) +
  aes(x=city, fill=city) + 
  geom_bar()
head(stations)

# (b) Create a plot of the density of the time (decimal hour) 
# of when trips are started. Use colour to distinguish between the different 
# cities the trip is started in and create one panel for week days and one for week ends. 
# Saturdays and Sundays in August 2015 were 
# August 1st, 2nd, 8th, 9th, 15th, 16th, 22nd, 23rd, 29th, 30th.
trips.densisty <- 
ggplot(data=health) + aes(x=HealthExpenditure, y=LifeExpectancy, colour=Region) + 
  geom_point(aes(size=Population)) +
  geom_smooth(method="lm") +
  scale_x_log10()+
  facet_wrap(~Region)
