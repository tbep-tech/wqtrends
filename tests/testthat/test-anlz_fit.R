test_that("Checking anlz_fit", {
  
  tomod <- rawdat %>%
    dplyr::filter(station %in% 32) %>%
    dplyr::filter(param %in% 'chl')
  
  result <- anlz_fit(tomod, trans = 'boxcox') %>% 
    dplyr::pull(GCV)
  
  expect_equal(result, c(0.200444893755889, 0.173069880941896, 0.15855087967915, 0.119742850923618))
  
})

test_that("Checking anlz_fit error", {
  
  expect_error(anlz_fit(), 'Must supply one of moddat or mods')
  
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
    dplyr::pull(GCV)
  
  expect_equal(result, c(0.200444893755889, 0.173069880941896, 0.15855087967915))
  
})

