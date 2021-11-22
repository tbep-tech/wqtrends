test_that("Checking show_trndseason class", {
  
  result <- show_sumtrndseason(mod, doystr = 90, doyend = 180, justify = 'center', win = 5:6)
  
  expect_is(result, 'ggplot')
  
})
