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