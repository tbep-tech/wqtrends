test_that("Checking show_prddoy class", {

  result <- show_prddoy(mod, ylab = 'Chlorophyll-a (ug/L)')
  
  expect_is(result, 'ggplot')
  
})

test_that("Checking show_prddoy yromit argument works", {
  
  result <- show_prddoy(mod, ylab = 'Chlorophyll-a (ug/L)', yromit = 2016)
  
  expect_false(2016 %in% result$data$yr)
  
})
