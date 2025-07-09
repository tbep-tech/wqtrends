test_that("Checking show_prdseason class", {

  result <- show_prdseason(mod, ylab = 'Chlorophyll-a (ug/L)')
  
  expect_is(result, 'ggplot')
  
})

test_that("Checking show_prdseason yromit argument works", {
  
  result <- show_prdseason(mod, ylab = 'Chlorophyll-a (ug/L)', yromit = 2016)
  
  expect_false(2016 %in% result$data$yr)
  
})