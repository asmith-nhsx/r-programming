# Question 1

# create matrix
A <- rbind(c(5, 1, 0, 4),
           c(4, 0, 6, 7),
           c(3, 3, 8, 9),
           c(1, 1, 1, 1))
A

# inverse
solve(A)

# compute transpose
TA <- t(A)
TA

# matrix multiply 
A %*% TA

# Question 2

# Download the file available at
# https://github.com/UofGAnalyticsData/R/raw/main/Assignment%201/saheart.csv
# and provide the command to read the file into R. 
# Make sure that variable names (if present) and missing values (if present) are read in correctly.

saheart <- read.csv("C:/Users/alex.smith_nhsx/projects/r-programming/saheart.txt",
                    header=TRUE)
head(saheart)

# Question 3
n1 <- 20
n2 <- 20
x <- saheart$age[1:n1]
y <- saheart$obesity[1:n2]
xbar <- mean(x)
ybar <- mean(y)
sxy <- 1/(n1+n2-2)*(sum((x-xbar)^2) + sum((y-ybar)^2))
t <- (xbar-ybar)/sqrt((1/n1+1/n2)*sxy)

# Question 4
load(url("https://github.com/UofGAnalyticsData/R/raw/main/Assignment%201/starwars.RData"))

# luke's eye colour
starwars[starwars$name=="Luke Skywalker",]$eye_color
# number of character taller than han solo
hanh <- starwars[starwars$name=="Han Solo",]$height
nrow(starwars[starwars$height > hanh,])
# add bmi column
starwars$bmi <- 10000 * starwars$mass/(starwars$height^2)
# max bmi
starwars[which.max(starwars$bmi),]$name
# same home world as Chewbacca
home <- starwars[starwars$name=="Chewbacca",]$homeworld
subset(starwars, homeworld==home)$name
