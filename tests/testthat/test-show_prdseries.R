test_that("Checking show_prdseries class", {
  
  result <- show_prdseries(mod, ylab = 'Chlorophyll-a (ug/L)')
  
  expect_is(result, 'ggplot')
  
})

test_that("Checking show_series yromit argument works", {
  
  result <- show_prdseries(mod, ylab = 'Chlorophyll-a (ug/L)', yromit = 2016)
  
  expect_false(2016 %in% result$data$yr)
  
})
