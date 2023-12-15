test_that("Checking show_mettrndseason class", {
  
  result <- show_mettrndseason(mod, doystr = 90, doyend = 180, justify = 'left', win = 5, ylab = 'Chlorophyll-a (ug/L)')
  
  expect_is(result, 'ggplot')
  
})

test_that("Checking show_mettrndseason class with cmbn as T", {
  
  result <- show_mettrndseason(mod, doystr = 90, doyend = 180, justify = 'left', win = 5, ylab = 'Chlorophyll-a (ug/L)', cmbn = T)
  
  expect_is(result, 'ggplot')
  
})

test_that("show_mettrndseason throws an error if cols length is not 4 for cmbn as F", {

  expect_error(show_mettrndseason(mod, cols = c('red', 'blue')), "Four names or colors must be provided")
  
})

test_that("show_mettrndseason throws an error if cols length is not 3 for cmbn as T", {
  
  expect_error(show_mettrndseason(mod, cols = c('red', 'blue'), cmbn = T), "Three names or colors must be provided")
  
})