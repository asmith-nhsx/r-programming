# Week 5 - Plotting in R 

# R has in built base r plotting functions
# Main function is plot()

# Scatter plot
n <- 50
x <- rnorm(n)
y <- rnorm(n)


plot(x,y)
# tilde notation y is response variable x is the data value
plot(y~x)

# plot data frame
noise_data <- cbind(x=x,y=y)
plot(noise_data)

# changing labels setting data
plot(y~x, data=noise_data, type="n", xlab="Label x", main="Plot X vs Y")


# helath data examples
load(url("https://github.com/UofGAnalyticsData/R/raw/main/Week%205/w5.RData"))
plot(LifeExpectancy~HealthExpenditure, data=health, col="red")
plot(LifeExpectancy~HealthExpenditure, data=health, col=1+unclass(Region))


library(magrittr)
# using pipes
health %$% plot(HealthExpenditure,LifeExpectancy)

model <- lm(LifeExpectancy~log(HealthExpenditure), data=health)
# plots 4 plots (diagnostic plots) based on the model
plot(model)


# bar plots
# table counts number of records for each region
health %$% table(Region)
health %$% table(Region) %>% barplot()
title("Number of Countries")

# pie charts (not recommended!)
health %$% table(Region) %>% pie()


# box plots
health %$% boxplot(HealthExpenditure ~ Region)

# histogram - idea of the spread of the data
# breaks ~ number of buckets
health %$%  hist(LifeExpectancy, breaks=20)

# density plot - estimated prob density
health %$% plot(density(LifeExpectancy))

# create matrix of scatter plots
pairs(health[,4:6])

# legends
plot(LifeExpectancy~HealthExpenditure, data=health, col=1+unclass(Region))
health %$% legend("bottomright", pch=1, col=1+unclass(Region), legend=levels(Region))


plot(LifeExpectancy~HealthExpenditure, data=health, col=1+unclass(Region))
# highlight uk, australia, and us data points in the plot
health2 <- health %>% 
  filter(Country %in% c("Australia", "United Kingdom", "United States"))

# make points larger (pch = 16) and solid (cex = 2)
health2 %$% 
  points(HealthExpenditure, LifeExpectancy, col=1+unclass(Region), pch=16, cex=2)

# add text labels to the points positioned relative to the point (adj)
health2 %$%
  text(HealthExpenditure, LifeExpectancy, Country, adj=c(1,1))

# mulitple plots
# 2 rows 2 cols 
par(mfrow=c(2,2))
plot(LifeExpectancy~HealthExpenditure, data=health, col=1+unclass(Region))

# review exercise
library(MASS)

plot(hills$dist,hills$time,xlab="Distance (miles)", ylab="Time (min)", main="Hill Races in Scotland")
# add fitted line - a = intercept, b = gradient
abline(0, 7.908, lwd=2)

# add 95% conf intervals - plot data after building the shape
# plot the axes wityh no data (type=n)
plot(hills$dist,hills$time,xlab="Distance (miles)", ylab="Time (min)", main="Hill Races in Scotland", type="n")
triangle <- rbind(c(0,0), c(30, 7.1728*30), c(30, 8.6437*30))
polygon(triangle, lty=2, col="grey")
points(hills$dist, hills$time)

# add prediction interval given by the equation
plot(hills$dist,hills$time,xlab="Distance (miles)", ylab="Time (min)", main="Hill Races in Scotland", type="n")
dist0 <- seq(0,30, length.out=300)
lower <- 7.908 * dist0 - 0.7355 * sqrt(3021.25+dist0^2)
upper <- 7.908 * dist0 + 0.7355 * sqrt(3021.25+dist0^2)
lines(dist0, lower, lty=2)
lines(dist0, upper, lty=2)

triangle <- rbind(c(0,0), c(30, 7.1728*30), c(30, 8.6437*30))
polygon(triangle, lty=2, col="grey")
points(hills$dist, hills$time)


# Also ggplot plotting library
