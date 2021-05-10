test_that("Checking anlz_prdday", {
  
  result <- anlz_prdday(mod) %>% 
    dplyr::pull(value) %>% 
    .[1:4] %>% 
    round(1)
  
  expect_equal(result, c(4, 4, 3.9, 3.9))
  
})

