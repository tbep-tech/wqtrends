test_that("Checking anlz_prdday", {
  
  tomod <- rawdat %>%
    dplyr::filter(station %in% 32) %>%
    dplyr::filter(param %in% 'chl')
  
  result <- anlz_prdday(tomod, trans = 'boxcox') %>% 
    dplyr::pull(value) %>% 
    .[1:4] %>% 
    round(1)
  
  expect_equal(result, c(0.8, 0.8, 0.8, 0.8))
  
})

test_that("Checking anlz_prdday error", {
  
  expect_error(anlz_prdday(), 'Must supply one of moddat or mods')
  
})

test_that("Checking anlz_prdday list input", {
  
  tomod <- rawdat %>%
    dplyr::filter(station %in% 32) %>%
    dplyr::filter(param %in% 'chl')
  trans <- 'boxcox'
  mods <- list(
    gam0 = anlz_gam(tomod, mod = 'gam0', trans = trans),
    gam1 = anlz_gam(tomod, mod = 'gam1', trans = trans),
    gam2 = anlz_gam(tomod, mod = 'gam2', trans = trans)
  )
  
  result <- anlz_prdday(mods = mods) %>% 
    dplyr::pull(value) %>% 
    .[1:4] %>% 
    round(1)
  
  expect_equal(result, c(0.8, 0.8, 0.8, 0.8))
  
})

