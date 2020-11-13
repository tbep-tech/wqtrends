test_that("Checking show_prdseries class", {
  
  result <- show_prdseries(mod, ylab = 'Chlorophyll-a (ug/L)')
  
  expect_is(result, 'ggplot')
  
})
