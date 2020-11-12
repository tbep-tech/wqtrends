test_that("Checking anlz_backtrans, log10", {
  
  tomod <- rawdat %>%
    dplyr::filter(station %in% 32) %>%
    dplyr::filter(param %in% 'chl')
  dat <- anlz_trans(tomod, trans = 'log10')
  result <- anlz_backtrans(dat) %>% 
    dplyr::pull(value) %>% 
    .[1:4] %>% 
    round(1)
  
  expect_equal(result, c(2.1, 6.9, 10.8, 7.4))

})

test_that("Checking anlz_backtrans, error", {
  
  tomod <- rawdat %>%
    dplyr::filter(station %in% 32) %>%
    dplyr::filter(param %in% 'chl')
  dat <- anlz_trans(tomod, trans = 'log10') %>% 
    dplyr::select(-trans)

  expect_error(anlz_backtrans(dat))
  
})

