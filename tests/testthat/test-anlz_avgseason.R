test_that("Checking anlz_avgseason", {
  
  result <- anlz_avgseason(mod, doystr = 90, doyend = 180) 
  
  expect_equal(nrow(result), 29)
  
})

test_that("Checking anlz_avgseason, no transformation", {
  
  result <- anlz_avgseason(modident, doystr = 90, doyend = 180) 
  
  expect_equal(nrow(result), 29)
  
})

test_that("Checking  error, insufficient inputs", {
  
  expect_error(anlz_avgseason(doystr = 90, doyend = 180))
  
})
