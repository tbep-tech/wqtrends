test_that("Checking anlz_fit", {
  
  tomod <- rawdat %>%
    dplyr::filter(station %in% 32) %>%
    dplyr::filter(param %in% 'chl')
  
  result <- anlz_fit(tomod, trans = 'boxcox') %>% 
    dplyr::pull(GCV)
  
  expect_is(result, 'numeric')
  
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
    gam2 = anlz_gam(tomod, mod = 'gam2', trans = trans),
    gam6 = anlz_gam(tomod, mod = 'gam6', trans = trans)
  )
  
  result <- anlz_fit(mods = mods) %>% 
    dplyr::pull(GCV)
  
  expect_is(result, 'numeric')
  
  result <- anlz_fit(mods = mods[1:3]) %>% 
    dplyr::pull(GCV)
  
  expect_is(result, 'numeric')
  
  result <- anlz_fit(mods = mods[1:2]) %>% 
    dplyr::pull(GCV) 
  
  expect_is(result, 'numeric')
  
})



