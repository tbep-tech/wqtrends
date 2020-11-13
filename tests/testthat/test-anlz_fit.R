test_that("Checking anlz_fit", {
  
  result <- anlz_fit(mod) %>% 
    dplyr::pull(GCV)
  
  expect_is(result, 'numeric')
  
})