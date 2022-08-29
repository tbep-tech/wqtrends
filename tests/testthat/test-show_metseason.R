test_that("Checking show_metseason class", {
  
  result <- show_metseason(mod, doystr = 90, doyend = 180, yrstr = 2000, yrend = 2017, ylab = 'Chlorophyll-a (ug/L)')
  
  expect_is(result, 'ggplot')
  
})

test_that("Checking show_metseason class, identity", {
  
  result <- show_metseason(modident, doystr = 90, doyend = 180, yrstr = 2000, yrend = 2017, ylab = 'Chlorophyll-a (ug/L)')
  
  expect_is(result, 'ggplot')
  
})

test_that("Checking show_metseason class, max as metfun", {
  
  result <- show_metseason(modident, metfun = max, doystr = 90, doyend = 180, yrstr = 2000, yrend = 2017, ylab = 'Chlorophyll-a (ug/L)', nsim = 5)
  
  expect_is(result, 'ggplot')
  
})

test_that("Checking show_metseason class, yrstr or yrend as NULL", {
  
  result <- show_metseason(modident, metfun = max, doystr = 90, doyend = 180, yrstr = NULL, yrend = NULL, ylab = 'Chlorophyll-a (ug/L)', nsim = 5)
  
  expect_is(result, 'ggplot')
  
})

test_that("Checking show_metseason class, yromit included", {
  
  result <- show_metseason(modident, metfun = max, doystr = 90, doyend = 180, yrstr = 2000, yrend = 2017, ylab = 'Chlorophyll-a (ug/L)', nsim = 5, yromit = 2015)
  
  expect_is(result, 'ggplot')
  
})

test_that("Checking show_metseason class with useave = T", {
  
  result <- show_metseason(mod, doystr = 90, doyend = 180, yrstr = 2000, yrend = 2017, ylab = 'Chlorophyll-a (ug/L)', useave = T)
  
  expect_is(result, 'ggplot')
  
})

test_that("Checking show_metseason, error if metfun not mean and useave TRUE", {
  
  expect_error(anlz_show_metseason(mod, metfun = max, doystr = 90, doyend = 180, justify = 'right', win = 5, nsim = 5, useave = T))
  
})


