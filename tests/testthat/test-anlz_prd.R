test_that("Checking anlz_prd", {
  
  tomod <- rawdat %>%
    dplyr::filter(station %in% 32) %>%
    dplyr::filter(param %in% 'chl')
  
  result <- anlz_prd(tomod, trans = 'boxcox') %>% 
    dplyr::pull(value) %>% 
    .[1:4]
  
  expect_equal(result, c(`1` = 0.80529973011085, `2` = 0.854991329587399, `3` = 0.960502089820473, 
                         `4` = 1.13723410782409))
  
})

test_that("Checking anlz_prd error", {
  
  expect_error(anlz_prd(), 'Must supply one of moddat or mods')
  
})

test_that("Checking anlz_prd list input", {
  
  tomod <- rawdat %>%
    dplyr::filter(station %in% 32) %>%
    dplyr::filter(param %in% 'chl')
  trans <- 'boxcox'
  mods <- list(
    gam0 = anlz_gam(tomod, mod = 'gam0', trans = trans),
    gam1 = anlz_gam(tomod, mod = 'gam1', trans = trans),
    gam2 = anlz_gam(tomod, mod = 'gam2', trans = trans)
  )
  
  result <- anlz_prd(mods = mods) %>% 
    dplyr::pull(value) %>% 
    .[1:4]
  
  expect_equal(result, c(`1` = 0.80529973011085, `2` = 0.854991329587399, `3` = 0.960502089820473, 
                         `4` = 1.13723410782409))
  
})

