test_that("Checking anlz_prdday", {
  
  result <- anlz_prdday(mod) %>% 
    dplyr::pull(value) %>% 
    .[1:4] %>% 
    round(1)
  
  expect_equal(result, c(6.3, 6.3, 6.3, 6.3))
  
})

