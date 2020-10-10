test_that("Checking anlz_prd", {
  
  tomod <- rawdat %>%
    dplyr::filter(station %in% 32) %>%
    dplyr::filter(param %in% 'chl')
  
  result <- anlz_prd(tomod, trans = 'boxcox') %>% 
    dplyr::pull(value) %>% 
    .[1:4] %>% 
    round(1)
  
  expect_equal(result, c(`1` = 0.8, `2` = 0.9, `3` = 1, `4` = 1.2))
  
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
    .[1:4] %>% 
    round(1)
  
  expect_equal(result, c(`1` = 0.8, `2` = 0.9, `3` = 1, `4` = 1.2))
  
})

