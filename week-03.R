# Week 3 sync session

# load test data
load(url("https://github.com/UofGAnalyticsData/R/blob/main/Week%203/chol.RData?raw=true"))
View(chol)


# add calculated column
# use matrix notation
chol[,"log.hdl.ldl"] <- log(chol[,"hdl"]/chol[,"ldl"])
# use list like dollar notation
chol$log.hdl.ldl <- log(chol$hdl/chol$ldl)
# use transform
chol <- transform(chol, log.hdl.ldl=log(hdl/ldl))

#delete columns
chol <- chol[,-7]
chol$log.hdl.ldl = NULL

# filter data
chol.smoked <-chol[chol$smoke!="no",]
View(chol.smoked)
chol.smoked <- na.omit(chol.smoked)

# Task 1
chol.lowhdl <- chol[chol$hdl<40,]
chol.lowhdl <- subset(chol, hdl<40)
View(chol.lowhdl)

#Task 2
load(url(paste("https://github.com/UofGAnalyticsData/R/blob",
               "/main/Week%203/cia.RData?raw=true",sep="")))

View(cia)

#(a) Delete all observations for which the population is missing
cia.withpop <- na.omit(cia$population)
View(cia.withpop)
?complete.cases
cia.withpop <- cia[!is.na(cia$Population),]
View(cia.withpop)

#(b) Which countries have a population of less than 10,000 inhabitants?
subset(cia.withpop, Population<=10000)

#(c) Which countries have a military expenditure of at least 8% of the GDP?
subset(cia, MilitaryExpenditure/GDP >= 0.08)$Country

#(d) Ignoring missing values, what is the combined GDP of all European countries?
sum(subset(cia, (!is.na(GDP) & Continent == "Europe"))$GDP)

#(e) Create a new column GDPPerCapita, which contains the per capita GDP (GDP) divided by Population. Also create a new column MilitaryExpPerCapita, which contains the per capita military expenditure MilitaryExpenditure divided by Population).
cia.withpop$GDPPerCapita <- cia.withpop$GDP/cia.withpop$Population
cia.withpop$MilitaryExpPerCapita <- cia.withpop$MilitaryExpenditure/cia.withpop$Population

#(f) Which country has the highest life expectancy?
cia[which.max(cia$Life),]$Country  

#(g) Which ten countries have the highest life expectancy?
head(cia[order(cia$Life, decreasing=TRUE),],n=10)

# merge data sets
load(url(paste("https://github.com/UofGAnalyticsData/R/blob/main",
               "/Week%203/children_classes.RData?raw=true",sep="")))
head(children)

head(classes)

data <- merge(children, classes, by="class")
head(data)

#Task 3
load(url(paste("https://github.com/UofGAnalyticsData/R/blob/",
               "main/Week%203/patients_weights.RData?raw=true",sep="")))
head(patients)
head(weights)

patient.weights <- merge(patients, weights, by="PatientID", all.y=TRUE)
head(patient.weights)


# importing and exporting data
cars <- read.csv("C:/Users/alex.smith_nhsx/projects/r-programming/cars.csv",
                 na.strings="*")
View(cars)

ships <- read.table("C:/Users/alex.smith_nhsx/projects/r-programming/ships.txt",
                    header=TRUE,na.strings=".")
View(ships)

# Review task
load(url(paste("https://github.com/UofGAnalyticsData/R/raw/main/Week%203/houseprices.RData", sep="")))
View(houseprices)

# Average house price in October 2014 
# filter for October
mean(subset(houseprices, Month==10)$Price)

# Number of transactions between Nov 15 and Dec 15
nrow(subset(houseprices, (Month==11 & Day>=15)|(Month==12 & Day<=15)))

# Which house sold for the lowest and which sold for the highest
houseprices[which.min(houseprices$Price),]
houseprices[which.max(houseprices$Price),]

# Use cut to create a new column called PriceGroup that take the values 
# low (Price <= 100,000), medium (100,000 < Price <= 250,000) and high (Price > 250,000)
houseprices <- transform(houseprices, PriceGroup=cut(Price, breaks=c(0,100000,250000,Inf), labels=c("low", "medium", "high")))
head(houseprices)

# What was the average price of properties which are within 1km of the University?
# Calculate distance from uni based on the long/lat formula
lambda1 <- houseprices$Lon / 180 * pi
phi1 <- houseprices$Lat / 180 * pi
lambda2 <- -4.2886 / 180 * pi
phi2 <-  55.8711  / 180 * pi
delta.lambda <- lambda2-lambda1
delta.phi <- phi2-phi1
alpha <- sin(delta.phi/2)^2 + cos(phi1)*cos(phi2)*sin(delta.lambda/2)^2
d <- 12742 * atan2(sqrt(alpha),sqrt(1-alpha))
houseprices <- transform(houseprices, Dist2Uni=d)

mean(subset(houseprices, (Dist2Uni < 1))$Price)

# Review exercises

#Task 1
health <- read.table("C:/Users/alex.smith_nhsx/projects/r-programming/health.txt", header=TRUE, )
View(health)
cia2 <- read.csv("C:/Users/alex.smith_nhsx/projects/r-programming/cia.csv",na.strings="?")
View(cia2)

#Task 2
load(url("https://github.com/UofGAnalyticsData/R/blob/main/Week%203/alcohol.RData?raw=true"))
View(alcohol)
subset(alcohol, (Gender=="Women" & Age == "16-24"))
sum(subset(alcohol, (Gender=="Women" & Age == "16-24"))$Units)
?aggregate
total_alcohol <- aggregate(Units ~ Age + Gender, data=alcohol, sum)
total_alcohol
