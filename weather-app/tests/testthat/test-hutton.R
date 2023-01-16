# Test the Hutton criteria function

test_that("Argument of wrong type throws error", {
  expect_error(huttonCriteria(1), "huttonCriteria only works with a data frame")
})

test_that("Data frame with wrong columns throws error", {
  # arrange
  df <- data.frame(c(1))
  # act and assert
  expect_error(huttonCriteria(df), 
               "huttonCriteria expects 'month', 'day', 'hour', 'air_temperature' and 'rltv_hum' columns")
})

test_that("Data frame with non-numeric columns throws error", {
  # arrange
  df <- data.frame(month = c(10), day = c(1), hour = c(1), air_temperature = c("alpha"), rltv_hum = c("beta"))
  # act and assert
  expect_error(huttonCriteria(df), 
               "huttonCriteria expects 'air_temperature' and 'rltv_hum' columns to contain numeric data")
})

test_that("Data frame with correct columns does not throw error", {
  # arrange
  df <- data.frame(month = c(10), day = c(1), hour = c(1), air_temperature = c(13), rltv_hum = c(90))
  # act and assert
  expect_no_error(huttonCriteria(df))
})

test_that("Hutton criteria is correctly calculated", {
  # arrange
  weather <- tibble(month = rep(10, times=24*5), 
                    day = rep(1:5, each=24),
                    hour = rep(1:24,times=5),
                    air_temperature = rep(9:13, each=24), 
                    rltv_hum = c(rep(80, times=43),rep(90, times=77)))
  
  expected <- tibble(month = rep(10,5),
                     day = 1:5,
                     min_temp = 9:13,
                     above_90 = c(0,5,24,24,24),
                     hutton = c(NA,FALSE,FALSE,FALSE,TRUE))
  # act
  result <- weather %>% huttonCriteria()
  
  # assert
  expect_equal(result, expected)
})