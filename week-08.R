# Week 8 - Functions in R

?rnorm # get documentation

# all arguments in named form
rnorm(n=100, mean=1, sd=1)

# all arguments in positional form
rnorm(100, 1, 1)

# can use  a mixture
rnorm(100, mean=1, sd=2)

# defining your own functions

# general syntax
function_name <- function(arg_1, arg_2, ...) {
  statement1
  ...
  statementn
}

plot(c(-3,3), c(-3,3),type="n")
x <- 0
y <- 0
width <- 4

square <- function(x,y,width,...) {
  rect(x-width/2,y-width/2,x+width/2,y+width/2,...)
}

square(0,0,6,col="green")
square(0,0,4,col="blue")
square(0,0,2,col="black")

# Task 3 - returning objects
harmonic.mean <- function(x) {
  n <- length(x)
  n/sum(1/x)
}

geometric.mean <- function(x) {
  n <- length(x)
  prod(x)^(1/n)
}


all.means <- function(x) {
  return(list(arithmetic=mean(x),
       harmonic=harmonic.mean(x),
       geometric=geometric.mean(x)))
}
x <- rnorm(100)
all.means(x)

# unit testing in R - "test that" package

# Review task
box.muller <- function() {
  u <- runif(2)
  theta <- 2*pi*u[1]
  r <- sqrt(-2*log(u[2]))
  r*(c(sin(theta), cos(theta)))
}

polar.marsaglia <- function() {
  while(TRUE) {
    u <- runif(2,-1,1)
    s <- sum(u^2)
    if (s<1) break
  }
  rho <- sqrt((-2*log(2))/s)
  rho*u
}

simulate.normal <- function(n,mu=0,sigma=1,method=box.muller) {
  result <- matrix(nrow=ceiling(n/2),ncol=2)
  for(i in 1:nrow(result)) {
    result[i,] <- mu+sigma*method()
  }
  result[1:n]
}

test <- simulate.normal(1000,mu=2, sigma=3)
mean(test)
sd(test)
