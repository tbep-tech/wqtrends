test_that("Checking multiple parameters in anlz_gam", {
 
  rawdatchk <- rawdat %>% dplyr::filter(station %in% 32)
  expect_error(anlz_gam(rawdatchk), 'More than one parameter found in input data')
  
})

test_that("Checking multiple stations anlz_gam", {
  
  rawdatchk <- rawdat %>% 
    dplyr::filter(param %in% 'chl') %>% 
    dplyr::filter(yr > 2015) %>% 
    dplyr::filter(station %in% c(32, 34))
  expect_error(anlz_gam(rawdatchk), 'More than one station found in input data')
  
})

test_that("Checkout output of anlz_gam", {
  
  result <- anlz_gam(tomod)
  expect_is(result, 'gam')
  
})

test_that("Checkout output of anlz_gam, knot reduction if knots too high", {
  
  result <- anlz_gam(tomod, kts = 1000)
  expect_is(result, 'gam')
  
})
