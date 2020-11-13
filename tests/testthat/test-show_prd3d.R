test_that("Checking show_prd3d class", {
  

  result <- show_prd3d(mod, ylab = 'Chlorophyll-a (ug/L)')
  
  expect_is(result, 'plotly')
  
})