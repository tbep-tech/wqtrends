test_that("Checking anlz_backtrans, log10", {
  
  dat <- anlz_trans(tomod, trans = 'log10')
  result <- anlz_backtrans(dat) %>% 
    dplyr::pull(value) %>% 
    .[1:4] %>% 
    round(1)
  
  expect_equal(result, c(4.4, 9.3, 7.8, 6.1))

})

test_that("Checking anlz_backtrans, error", {
  
  dat <- anlz_trans(tomod, trans = 'log10') %>% 
    dplyr::select(-trans)

  expect_error(anlz_backtrans(dat))
  
})

