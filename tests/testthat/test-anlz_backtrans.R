test_that("Checking anlz_backtrans, log10", {
  
  tomod <- rawdat %>%
    dplyr::filter(station %in% 32) %>%
    dplyr::filter(param %in% 'chl')
  dat <- anlz_trans(tomod, trans = 'log10')
  result <- anlz_backtrans(dat) %>% 
    dplyr::pull(value) %>% 
    .[1:4]
  
  expect_equal(result, c(2.2, 7.2, 11.1, 7.3))

})

test_that("Checking anlz_backtrans, boxcox", {
  
  tomod <- rawdat %>%
    dplyr::filter(station %in% 32) %>%
    dplyr::filter(param %in% 'chl')
  dat <- anlz_trans(tomod, trans = 'boxcox')
  result <- anlz_backtrans(dat) %>% 
    dplyr::pull(value) %>% 
    .[1:4]
  
  expect_equal(result, c(2.2, 7.2, 11.1, 7.3))
  
})

test_that("Checking anlz_backtrans, error", {
  
  tomod <- rawdat %>%
    dplyr::filter(station %in% 32) %>%
    dplyr::filter(param %in% 'chl')
  dat <- anlz_trans(tomod, trans = 'boxcox') %>% 
    dplyr::select(-trans)

  expect_error(anlz_backtrans(dat))
  
})

