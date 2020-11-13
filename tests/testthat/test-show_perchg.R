test_that("Checking show_perchg class", {
  
  result <- show_perchg(mod, baseyr = 1990, testyr = 2017, ylab = 'Chlorophyll-a (ug/L)')
  
  expect_is(result, 'ggplot')
  
})