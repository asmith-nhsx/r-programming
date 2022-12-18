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
  l <- ((d-1)/2)  
  if (m < d) {
    stop("Input image must be a matrix with more rows than d")
  }
  if (n < d) {
    stop("Input image must be a matrix with more columns than d")
  }
  img.denoised <- matrix(nrow=m-l,ncol=n-l)
  for (i in 1:(m-d-1)) {
    for (j in 1:(n-d-1)) {
      img.denoised[i,j] <- median(I[c(i,i+d-1),c(j,j+m,-1)])
    }
  }
  return(img.denoised)
}

image(denoise.image(img, d=5), col=grey(seq(0, 1, len=256)))

