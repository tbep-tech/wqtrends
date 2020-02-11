test_that("Checking multiple parameters in anlz_transs", {
  
  rawdat <- rawdat %>% dplyr::filter(station %in% 32)
  expect_error(anlz_trans(rawdat), 'More than one parameter found in input data')
  
})

test_that("Checking multiple stations anlz_trans", {
  
  rawdat <- rawdat %>% dplyr::filter(param %in% 'chl')
  expect_error(anlz_trans(rawdat), 'More than one station found in input data')
  
})

test_that("Checkout output of anlz_trans", {
  
  tomod <- rawdat %>%
    dplyr::filter(station %in% 32) %>%
    dplyr::filter(param %in% 'chl')
  result <- anlz_trans(tomod, trans = 'boxcox')
  expect_is(result, 'data.frame')
  
})

test_that("Checkout output of anlz_trans", {
  
  tomod <- rawdat %>%
    dplyr::filter(station %in% 32) %>%
    dplyr::filter(param %in% 'chl')
  result <- anlz_trans(tomod, trans = 'log10')
  expect_is(result, 'data.frame')
  
})

test_that("Checkout output of anlz_trans", {
  
  tomod <- rawdat %>%
    dplyr::filter(station %in% 32) %>%
    dplyr::filter(param %in% 'chl')
  result <- anlz_trans(tomod, trans = 'ident')
  expect_is(result, 'data.frame')
  
})