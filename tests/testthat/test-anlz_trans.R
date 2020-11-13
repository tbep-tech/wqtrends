test_that("Checking multiple parameters in anlz_transs", {
  
  tmp <- rawdat %>% dplyr::filter(station %in% 32)
  expect_error(anlz_trans(tmp), 'More than one parameter found in input data')
  
})

test_that("Checking multiple stations anlz_trans", {
  
  tmp <- rawdat %>% dplyr::filter(param %in% 'chl')
  expect_error(anlz_trans(tmp), 'More than one station found in input data')
  
})

test_that("Checkout output of anlz_trans", {
  
  result <- anlz_trans(tomod, trans = 'log10')
  expect_is(result, 'data.frame')
  
})

test_that("Checkout output of anlz_trans", {
  
  result <- anlz_trans(tomod, trans = 'ident')
  expect_is(result, 'data.frame')
  
})