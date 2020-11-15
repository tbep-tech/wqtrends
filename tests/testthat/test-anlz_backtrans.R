test_that("Checking anlz_backtrans, log10", {
  
  dat <- anlz_trans(tomod, trans = 'log10')
  result <- anlz_backtrans(dat) %>% 
    dplyr::pull(value) %>% 
    .[1:4] %>% 
    round(1)
  
  expect_equal(result, c(2.8, 3.1, 2.5, 4.2))

})

test_that("Checking anlz_backtrans, error", {
  
  dat <- anlz_trans(tomod, trans = 'log10') %>% 
    dplyr::select(-trans)

  expect_error(anlz_backtrans(dat))
  
})

