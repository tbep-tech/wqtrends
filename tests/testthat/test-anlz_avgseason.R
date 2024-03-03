test_that("Checking anlz_avgseason", {
  
  result <- anlz_avgseason(mod, doystr = 90, doyend = 180) 
  
  expect_equal(nrow(result), 4)
  
})

test_that("Checking anlz_avgseason, no transformation", {
  
  result <- anlz_avgseason(modident, doystr = 90, doyend = 180) 
  
  expect_equal(nrow(result), 4)
  
})

test_that("Checking  error, insufficient inputs", {
  
  expect_error(anlz_avgseason(doystr = 90, doyend = 180))
  
})

test_that("Checking yromit", {
  
  result <- anlz_avgseason(mod, doystr = 90, doyend = 180, yromit = 2016)
  
  # excpect NA for 2016
  expected <- na.omit(result)$yr
  expect_equal(expected, c(2017, 2018, 2019))
  
})
