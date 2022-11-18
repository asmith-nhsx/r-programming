# Logical ops
a <- TRUE
b <- FALSE

c <- a & !b
c

(a|b)&b

x <- 3
x < 0
x <= 3
x >0 & x<2

# Vectors
v <- c(1,2,3)
v[1]
u <- c(2,4,6)
w <- u + v
w[1]
w[2]
r <- 1:5
r[5]
length(r)
s <- rev(r)
s[5]
names(v) <- c("A","B", "C")
v
r[1:4]
r[c(1,2)]

v <- c(1,2)
r + v
seq(1,2,by=0.2)
seq(1,2,length.out=4)
rep(1:3,times=4)

# Strings


# Matrices
# %*% is the matrix product

# Task 1 (Babylonian Method)

x <- 1
x <- x/2 + 1/x
x <- x/2 + 1/x
x <- x/2 + 1/x
x <- x/2 + 1/x
x <- x/2 + 1/x
x <- x/2 + 1/x
x <- x/2 + 1/x

x
sqrt(2)

x <- 1
for (i in 1:20)
  x <- x/2 + 1/x

x


# Task 2 (Monte-Carlo integration)

n <- 100000
x <- runif(n)
y <- runif(n)
fx <- 1-exp(sin(pi*x)^2)*cos(pi*x)^2
intergal <- sum(y < fx)/n
intergal

f <- function(x){
  1-exp(sin(pi*x)^2)*cos(pi*x)^2
}
integrate(f,0,1)


# Review exercises
# Task 1
exp(1)
(1+1/1000)^1000
(1/56)^(1/4)

# Task 2
a <- c(TRUE, FALSE)
b <- c(FALSE, FALSE)
c <- (!a & !b)  #c(FALSE, TRUE)
d <- !(a & b)   #c(TRUE, TRUE)
e <- !(a | b)   #c(FALSE, TRUE)
c
d
e

#Task 3
a <- sample(c(TRUE, FALSE), 1)
b <- sample(c(TRUE, FALSE), 1)
a
b
c <- a == b
c <- (a & b) | (!a & !b)
c

#Task 4
1:10
rep(1:3,times=4)
c(1:20,19:1)
(1:10) ^ 2

#Task 5
2 ^ (0:9)
sum(2^(0:9))
sum(1/(2^(1:30)))

#Task 6
p <- rbind(c(1,0,0,-1,0),
           c(0,5,0,0,0),
           c(3,0,1,0,0),
           c(0,0,0,7,0),
           c(0,0,0,0,9))
p
p[1,]
p[,2]
p[1:3,1:2]
p
t(p)
solve(p)
p[1,] <- 1:5
p
p[p > 0] <- 1
p
