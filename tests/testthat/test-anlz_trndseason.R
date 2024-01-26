test_that("Checking anlz_trndseason, left window", {
  
  result <- anlz_trndseason(mod, doystr = 90, doyend = 180, justify = 'left', win = 2) %>% 
    dplyr::pull(pval) %>% 
    .[(length(.) - 3):length(.)]
  
  expect_equal(sum(is.na(result)), 1)
  
})

test_that("Checking anlz_trndseason, center window", {

  result <- anlz_trndseason(mod, doystr = 90, doyend = 180, justify = 'center', win = 3) %>% 
    dplyr::pull(pval) %>% 
    .[(length(.) - 3):length(.)]
  
  expect_equal(sum(is.na(result)), 2)
  
})

test_that("Checking anlz_trndseason, right window", {
  
  result <- anlz_trndseason(mod, doystr = 90, doyend = 180, justify = 'right', win = 2) %>% 
    dplyr::pull(pval) %>% 
    .[(length(.) - 3):length(.)]
  
  expect_equal(sum(is.na(result)), 1)
  
})

test_that("Checking anlz_trndseason, max as metfun", {
  
  result <- anlz_trndseason(mod, metfun = max, doystr = 90, doyend = 180, justify = 'right', win = 2, nsim = 5) %>% 
    dplyr::pull(pval) %>% 
    .[(length(.) - 3):length(.)]
  
  expect_equal(sum(is.na(result)), 1)
  
})

test_that("Checking anlz_trndseason, error if metfun not mean and useave TRUE", {
  
  expect_error(anlz_trndseason(mod, metfun = max, doystr = 90, doyend = 180, justify = 'right', win = 2, nsim = 5, useave = T))
  
})

