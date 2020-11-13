test_that("Checking anlz_trndseason, left window", {
  
  result <- anlz_trndseason(mod, doystr = 90, doyend = 180, justify = 'left', win = 5) %>% 
    dplyr::pull(pval) %>% 
    .[(length(.) - 3):length(.)]
  
  expect_equal(sum(is.na(result)), 4)
  
})

test_that("Checking anlz_trndseason, center window", {

  result <- anlz_trndseason(mod, doystr = 90, doyend = 180, justify = 'center', win = 5) %>% 
    dplyr::pull(pval) %>% 
    .[(length(.) - 3):length(.)]
  
  expect_equal(sum(is.na(result)), 3)
  
})

test_that("Checking anlz_trndseason, right window", {
  
  result <- anlz_trndseason(mod, doystr = 90, doyend = 180, justify = 'right', win = 5) %>% 
    dplyr::pull(pval) %>% 
    .[(length(.) - 3):length(.)]
  
  expect_equal(sum(is.na(result)), 0)
  
})
