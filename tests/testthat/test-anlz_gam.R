test_that("Checking multiple parameters in anlz_gam", {
 
  rawdat <- rawdat %>% dplyr::filter(station %in% 32)
  expect_error(anlz_gam(rawdat), 'More than one parameter found in input data')
  
})

test_that("Checking multiple stations anlz_gam", {
  
  rawdat <- rawdat %>% dplyr::filter(param %in% 'chl')
  expect_error(anlz_gam(rawdat), 'More than one station found in input data')
  
})

test_that("Checkout output of anlz_gam", {
  
  result <- anlz_gam(tomod)
  expect_is(result, 'gam')
  
})

test_that("Checkout output of anlz_gam, knot reduction", {
  
  result <- anlz_gam(tomod, kts = 500)
  expect_is(result, 'gam')
  
})
