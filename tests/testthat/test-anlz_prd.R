test_that("Checking anlz_prd", {
  
  result <- anlz_prd(mod) %>% 
    dplyr::pull(value) %>% 
    .[1:4] %>% 
    round(1)
  
  expect_equal(result, c(`1` = 2.8, `2` = 2.5, `3` = 2.3, `4` = 2.1))
  
})
