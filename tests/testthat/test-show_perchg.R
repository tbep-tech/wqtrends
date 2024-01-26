test_that("Checking show_perchg class", {
  
  result <- show_perchg(mod, baseyr = 2016, testyr = 2019, ylab = 'Chlorophyll-a (ug/L)')
  
  expect_is(result, 'ggplot')
  
})