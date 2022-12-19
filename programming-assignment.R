# R Programming Assignment
# Author: Alex Smith
# Date: 08 Dec 2022
# Username: 2840378S

# Task 1
# a)

#' Compute the volume of a cylinder
#' @param r radius of the cylinder 
#' @param h height of the cylinder
#' @return the volume of the cylinder
vol.cyl <- function(r, h) {
  return(pi * r ^ 2 * h)
}

# tests
r <- c(2, 1.5, 0.1)
h <- c(3, 4, 5)
expected <- c(37.699111, 28.274333, 0.157079) # (from calculator)
result <- vol.cyl(r, h)
result - expected < 0.00001 # close agreement

# b)

#' Compute the unused volume of a box of cylinders
#' @param r radius of a cylinder 
#' @param h height of a cylinder
#' @param n number of cylinders in a box
#' @return the unused volume in the box 
unused.volume <- function(r, h, n) {
  total_volume <- 4 * r ^ 2 * n * h
  used_volume <- n * vol.cyl(r, h)
  return(total_volume - used_volume)
}

# tests
r <- c(2, 1.5, 0.1)
h <- c(3, 4, 5)
n <- c(10, 20, 30)
expected <- r^2*n*h*(4 - pi) # simplified expression
result <- unused.volume(r, h, n)
result - expected < 0.0000001 # very close agreement

# Task 2
# load data
load(url("https://github.com/UofGAnalyticsData/R/raw/main/Assignment%203/img.RData"))
# view image
image(img, col=grey(seq(0, 1, len=256)))


#' Remove noise from an image
#' @param I matrix containing the original image
#' @param d number of pixels to smooth over
#' @return the de-noised image 
denoise.image <- function(I, d) {
  if (d %% 2 == 0) {
    stop("d must be an odd number of pixels")
  }
  m <- dim(I)[1]
  n <- dim(I)[2]
  if (m < d) {
    stop("Input image must be a matrix with more rows than d")
  }
  if (n < d) {
    stop("Input image must be a matrix with more columns than d")
  }
  img.denoised <- matrix(nrow=m-d-1,ncol=n-d-1)
  for (i in 1:(m-d-1)) {
    for (j in 1:(n-d-1)) {
      img.denoised[i,j] <- median(I[c(i,i+d-1),c(j,j+d-1)])
    }
  }
  return(img.denoised)
}

image(denoise.image(img, d=5), col=grey(seq(0, 1, len=256)))


# Task 3

#' Generate Pascal's triangle
#' @param n the number of rows of Pascal's triangle to generate
#' @return a list with n entries representing each row of Pascal's triangle
pascal <- function(n) {
  t <- list(c(1))
  for (k in 2:n) {
    t[[k]] <- c(0,t[[k-1]])+c(t[[k-1]],0)     
  }
  return(t)
}

# tests
expected <- list(1,c(1,1),c(1,2,1)) 
result <- pascal(3)
identical(expected, result)

expected <- list(1,c(1,1),c(1,2,1),c(1,3,3,1),c(1,4,6,4,1),c(1,5,10,10,5,1)) 
result <- pascal(6)
identical(expected, result)


# Task 4

#' Produce truncated polynomials
#' @param x scalar of vector of input values
#' @param x0 scalar value below which values are truncated
#' @param r power of polynomial
#' @return a scalar or vector or truncated polynomials
tp <- function(x, x0, r) {
  return(ifelse(x > x0, (x-x0)^r, 0))
}

# tests
# scalar case
expected <- 8
result <- tp(4,2,3)
expected == result

#vector case
expected <- c(4,0,1,9,16,0)
result <- tp(c(4,1,3,5,6,-1),2,2)
identical(expected, result)

# Task 5

#' Smooth quadratic spline function
#' @param x vector of input values
#' @param delta scalar value below which polynomials are truncated
#' @return output quadratic spline as a vector
bspline <- function(x, delta=1) {
  return(
    (1/(2*delta^2))*(tp(x,0,2)-3*tp(x,delta,2)+3*tp(x,2*delta,2)-tp(x,3*delta,2))
  )
}

# test
x <- seq(-1,4,length.out=250)
y <- bspline(x)
plot(y~x,type="l",ylab="B1(x)")

# Task 6


#' Create a projection 
#' @param x vector of input values
#' @param k integer value for the number of knots to use in the projection
#' @return projection object containing the calculated projection matrix P 
projection <- function(x, k) {
  
  if (k != floor(k)) {
    stop("k must be an integer")
  }
  n <- length(x)
  maxx <- max(x)
  minx <- min(x)
  delta <- (maxx - minx)/(k-2)
  # create a sequence of k equally spaced knots
  t <- seq(minx-2*delta, maxx-delta, length.out=k)
  
  # create a n by k matrix Z of smooth quadratic splines

  # expand vector x into a n by k matrix
  xm <- matrix(replicate(k,x), nrow=n)
  # expand vector t into a n by k matrix
  tm <- t(matrix(replicate(n,t), nrow=k))
  
  # create Z using the vectorized form of bspline (no for loops)
  Z <- bspline(xm - tm, delta)
  
  # create P projection matrix
  P <- Z %*% solve(t(Z) %*% Z) %*% t(Z)
  
  # construct the projection object and return it
  result <- list(x=x, delta=delta, Z=Z, P=P)
  class(result) = "projection"
  return(result)
}

# tests


# this should throw the error "k must be an integer"
x <- rnorm(5)
k <- 3.1897
tryCatch({
    projection(x,k) 
    print(FALSE)
  },
  error = function(err) {
    print(err$message == "k must be an integer")
  }
)

# test for right object type returned
n <- 5
x <- rnorm(n)
k <- 3
p <- projection(x, k)
class(p) == "projection"
p$x == x
p$delta == (max(x) - min(x))/(k-2)
dim(p$Z) == c(n, k)
dim(p$P) == c(n, n)

# task 6 - b

#' Plot the projection 
#' @param proj projection object to plot
#' @param y response variable to plot 
plot.projection <- function(proj, y, ...) {
  # project the response variable into a smooth spline
  smoothed <- p$P %*% y
  # pass additional arguments passed to plot using the ellipsis
  plot(proj$x, y, type="p", ...)
  # plot the smoothed spline
  lines(proj$x, smoothed)
}

# test
x <- seq(1,10)
y <- rnorm(10,5,2)
k <- 6
p <- projection(x, k)
plot(p,y)


# task 6 - c
library(MASS)
p <- projection(mcycle$times, 12)
plot(p, mcycle$accel, xlab="times", ylab="accel")

