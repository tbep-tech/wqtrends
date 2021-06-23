test_that("Checking anlz_prd", {
  
  result <- anlz_prd(mod) %>% 
    dplyr::pull(value) %>% 
    .[1:4] %>% 
    round(1)
  
  expect_equal(result, c(`1` = 2.8, `2` = 2.5, `3` = 2.3, `4` = 2.1))
  
})

test_that("Checking anlz_prd, annual = T", {
  
  result <- anlz_prd(mod, annual = T) %>% 
    dplyr::pull(annvalue) %>% 
    .[1:4] %>% 
    round(1)
  
  expect_equal(result, c(`1` = 2.8, `2` = 2.5, `3` = 2.3, `4` = 2.1))
  
})

