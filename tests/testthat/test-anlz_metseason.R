test_that("Checking anlz_metseason", {
  
  result <- anlz_metseason(mod, doystr = 90, doyend = 180, nsim = 5) 
  
  expect_equal(nrow(result), 4)
  
})

test_that("Checking anlz_metseason, no transformation", {
  
  result <- anlz_metseason(modident, doystr = 90, doyend = 180, nsim = 5) 
  
  expect_equal(nrow(result), 4)
  
})

test_that("Checking  error, insufficient inputs", {
  
  expect_error(anlz_metseason(doystr = 90, doyend = 180, nsim = 5))
  
})

test_that("Checking yromit", {
  
  result <- anlz_metseason(mod, doystr = 90, doyend = 180, nsim = 5, yromit = 2016)
   
  # excpect NA for 2016
  expected <- na.omit(result)$yr
  expect_equal(expected, c(2017, 2018, 2019))
  
})
