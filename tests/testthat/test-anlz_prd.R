test_that("Checking anlz_prd", {
  
  result <- anlz_prd(mod) %>% 
    dplyr::pull(value) %>% 
    .[1:4] %>% 
    round(1)
  
  expect_equal(result, c(`1` = 0.3, `2` = 0.4, `3` = 0.5, `4` = 0.6))
  
})
