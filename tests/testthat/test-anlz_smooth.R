test_that("Checking anlz_smooth", {
  
  result <- anlz_smooth(mod) %>% 
    dplyr::pull(p.value) %>% 
    round(2)
  
  expect_equal(result, 0)
  
})
