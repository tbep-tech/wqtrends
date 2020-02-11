test_that("Checking anlz_fit", {
  
  tomod <- rawdat %>%
    dplyr::filter(station %in% 32) %>%
    dplyr::filter(param %in% 'chl')
  
  result <- anlz_fit(tomod, trans = 'boxcox') %>% 
    pull(GCV)
  
  expect_equal(result, c(146.622000066429, 141.353748534362, 139.048564782218, 125.559570930222))
  
})

test_that("Checking anlz_fit error", {
  
  expect_error(anlz_fit(), 'Must supply one of rawdat or mods')
  
})

test_that("Checking anlz_fit list input", {
  
  tomod <- rawdat %>%
    dplyr::filter(station %in% 32) %>%
    dplyr::filter(param %in% 'chl')
  trans <- 'boxcox'
  mods <- list(
    gam0 = anlz_gam(tomod, mod = 'gam0', trans = trans),
    gam1 = anlz_gam(tomod, mod = 'gam1', trans = trans),
    gam2 = anlz_gam(tomod, mod = 'gam2', trans = trans)
  )
  
  result <- anlz_fit(mods = mods) %>% 
    pull(GCV)
  
  expect_equal(result, c(146.622000066429, 141.353748534362, 139.048564782218))
  
})

