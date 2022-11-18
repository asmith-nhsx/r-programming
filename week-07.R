# Week 7 - Classical Programming in R

# if statement
x <- rnorm(1)
if (x > 0) {
  y <- sqrt(x)
} else {
  y <- -sqrt(-x)
}

# loops
x <-rnorm(50)
for (i in 1:length(x)) {
  if (x[i] < 0) {
    x[i] <- 0
  }
}
x

# doing the same thing without a loop
x <-rnorm(50)
x[x<0]<-0
x

# break
x <- 1
for (i in 1:10) {
  x.old <- x
  x <- x/2 + 1/x
  if (abs(x - x.old) < 1e-8)
    break
}
x
i

# next 
for(x in 1:10) {
  if (x%%2 == 0)
    next
  print(x)
}

# while loops - obvious


# ifelse function - vectorized version of if
x <- rnorm(50)
x <- ifelse(x<0,0,x)
x


# avoid loops in R!
n <- 1e5
x <- rnorm(n)
y <- rnorm(y)

# fast
system.time(z <- x + y)

# slow!
system.time({
  z <- numeric(n)
  for (i in 1:n)
    z[i] <- x[i] + y[i]
})

# review exercise
n <- 10
coords <- matrix(rnorm(2*n), ncol=2)
plot(coords, pch=16, xlab="x", ylab="y")

coords

# sub-optimal double joins
for(i in 1:n) {
  for (j in 1:n) {
    lines(coords[c(i,j),],col="blue")
  }
}

# more optimal avoids double joins
for(i in 1:(n-1)) {
  for (j in (i+1):n) {
    lines(coords[c(i,j),],col="blue")
  }
}

# plot closest pair of points
closest.pair <- c(NA,NA)
closest.distance <- Inf

for (i in 1:(n-1)) {
  for (j in (i+1):n) { 
    dist <- sum((coords[i,]-coords[j,])^2) # sum of squares
    if (dist < closest.distance) {
      closest.pair <- c(i,j)
      closest.distance <- dist
    }           
  }
}
closest.pair
closest.distance
lines(coords[closest.pair,], col="red", lwd=4)
