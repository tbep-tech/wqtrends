test_that("Checking anlz_prd", {
  
  result <- anlz_prd(mod) %>% 
    dplyr::pull(value) %>% 
    .[1:4] %>% 
    round(1)
  
  expect_equal(result, c(`1` = 6.6, `2` = 6.6, `3` = 6.6, `4` = 6.7))
  
})

test_that("Checking anlz_prd, annual = T", {
  
  result <- anlz_prd(mod, annual = T) %>% 
    dplyr::pull(annvalue) %>% 
    .[1:4] %>% 
    round(1)
  
  expect_equal(result, c(`1` = 6.6, `2` = 6.6, `3` = 6.6, `4` = 6.7))
  
})

