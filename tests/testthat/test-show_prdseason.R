test_that("Checking show_prdseason class", {

  result <- show_prdseason(mod, ylab = 'Chlorophyll-a (ug/L)')
  
  expect_is(result, 'ggplot')
  
})

