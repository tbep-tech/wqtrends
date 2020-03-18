test_that("Checking anlz_pred", {
  
  tomod <- rawdat %>%
    dplyr::filter(station %in% 32) %>%
    dplyr::filter(param %in% 'chl')
  
  result <- anlz_pred(tomod, trans = 'boxcox') %>% 
    dplyr::pull(value) %>% 
    .[1:4]
  
  expect_equal(result, c(0.80529973011085, 0.854991329587398, 0.960502089820474, 1.13723410782409))
  
})

test_that("Checking anlz_pred error", {
  
  expect_error(anlz_pred(), 'Must supply one of moddat or mods')
  
})

test_that("Checking anlz_pred list input", {
  
  tomod <- rawdat %>%
    dplyr::filter(station %in% 32) %>%
    dplyr::filter(param %in% 'chl')
  trans <- 'boxcox'
  mods <- list(
    gam0 = anlz_gam(tomod, mod = 'gam0', trans = trans),
    gam1 = anlz_gam(tomod, mod = 'gam1', trans = trans),
    gam2 = anlz_gam(tomod, mod = 'gam2', trans = trans)
  )
  
  result <- anlz_pred(mods = mods) %>% 
    dplyr::pull(value) %>% 
    .[1:4]
  
  
  expect_equal(result, c(0.80529973011085, 0.854991329587398, 0.960502089820474, 1.13723410782409))
  
})

