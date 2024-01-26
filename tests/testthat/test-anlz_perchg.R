test_that("Checking anlz_perchg", {
  
  result <- anlz_perchg(mod, baseyr = 2016, testyr = 2019) 
  
  expect_equal(nrow(result), 1)
  
})

test_that("Checking anlz_perchg error, insufficient inputs", {
  
  expect_error(anlz_perchg(baseyr = 1996, testyr = 2016))
  
})
