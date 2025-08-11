test_that("Checking show_prdseries class", {
  
  result <- show_prdseries(mod, ylab = 'Chlorophyll-a (ug/L)')
  
  expect_is(result, 'ggplot')
  
})

test_that("Checking show_series yromit argument works", {
  
  result <- show_prdseries(mod, ylab = 'Chlorophyll-a (ug/L)', yromit = 2016)
  
  chk <- result$data[result$data$yr == 2016, 'value',]
  expect_true(all(is.na(chk)))
  
})
