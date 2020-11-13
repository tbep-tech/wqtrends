test_that("Checking show_prddoy class", {

  result <- show_prddoy(mod, ylab = 'Chlorophyll-a (ug/L)')
  
  expect_is(result, 'ggplot')
  
})
