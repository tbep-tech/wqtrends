test_that("Checking multiple parameters in anlz_gam", {
 
  rawdat <- rawdat %>% dplyr::filter(station %in% 32)
  expect_error(anlz_gam(rawdat), 'More than one parameter found in input data')
  
})

test_that("Checking multiple stations anlz_gam", {
  
  rawdat <- rawdat %>% dplyr::filter(param %in% 'chl')
  expect_error(anlz_gam(rawdat), 'More than one station found in input data')
  
})

test_that("Checkout output of anlz_gam", {
  
  tomod <- rawdat %>%
    dplyr::filter(station %in% 32) %>%
    dplyr::filter(param %in% 'chl')
  result <- anlz_gam(tomod, mod = 'gam2')
  expect_is(result, 'gam')
  
})