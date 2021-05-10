test_that("Checking anlz_prdmatrix", {
  
  result <- anlz_prdmatrix(mod, doystr = 90, doyend = 180) 
  
  expect_is(result, 'data.frame')

})
