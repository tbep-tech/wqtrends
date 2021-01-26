test_that("Checking show_avgseason class", {
  
  result <- show_avgseason(mod, doystr = 90, doyend = 180, yrstr = 2000, yrend = 2017, ylab = 'Chlorophyll-a (ug/L)')
  
  expect_is(result, 'ggplot')
  
})

test_that("Checking show_avgseason class, identity", {
  
  result <- show_avgseason(modident, doystr = 90, doyend = 180, yrstr = 2000, yrend = 2017, ylab = 'Chlorophyll-a (ug/L)')
  
  expect_is(result, 'ggplot')
  
})