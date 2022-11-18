# Question 1

A <- diag(c(3,1,3,1))
A[1,3] <- 4
A[3,2] <- -1
A[4,1] <- 6
A

# Question 2
potus <- read.csv("potus.txt", header=TRUE, sep=";")

# Check row count, expecting 3179
nrow(potus)

# Check column names and types:
# Expecting: 
# County      : chr 
# State       : chr 
# VotesTrump  : int  
# VotesClinton: int  
# PercTrump   : num  
# PercClinton : num  
# PercWhite   : num  
# HIncome     : num 

colnames(potus)
str(potus)

# display first few rows of data
head(potus)

# Question 3
n <- 10000
arrival <- 35+rexp(n, rate=0.2)
departure <- 40+rexp(n, rate=0.2)

# difference between departure and arrival times
diff <- departure - arrival

# number of times we would have missed the train
misses <- length(diff[diff <= 0])
misses

# proportion of times missing the train
misses / n

# Question 4

load(url("https://github.com/UofGAnalyticsData/R/raw/main/Assignment%201/lakes.RData"))
View(lakes)

# What is the surface area of Loch Assynt?
lakes["Loch Assynt",]$SurfaceArea

# What is the average pH value of the lakes in the data set?
mean(lakes$pH)

# What is the most acidic (lowest pH value) lake?
# add row names (lake names) as a column in the data frame
lakes$lake <- row.names(lakes)
lakes[which.min(lakes$pH),]$lake

# Add a new column Volume, which is the product of the surface area and the mean depth.
lakes$Volume <- lakes$SurfaceArea * lakes$MeanDepth

# What is the combined total biovolume of the 10 largest lakes (in the sense of having the largest surface areas)?
ord <- order(lakes$SurfaceArea, decreasing = TRUE)
sum(lakes[ord,][1:10,]$TotalBiovolume)

