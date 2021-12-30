test_that("Checking show_trndseason2 class", {
  
  result <- show_sumtrndseason2(mod, justify = 'center', win = 5)
  
  expect_is(result, 'ggplot')
  
})
