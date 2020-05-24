test_that("Checking anlz_trndseason, left window", {
  
  tomod <- rawdat %>%
    dplyr::filter(station %in% 32) %>%
    dplyr::filter(param %in% 'chl')
  
  # use previously fitted list of models
  trans <- 'boxcox'
  mods <- list(
    gam0 = anlz_gam(tomod, mod = 'gam0', trans = trans)
  )
  result <- anlz_trndseason(mods = mods, doystr = 90, doyend = 180, justify = 'left', win = 5) %>% 
    dplyr::pull(pval) %>% 
    .[(length(.) - 3):length(.)]
  
  expect_equal(sum(is.na(result)), 4)
  
})

test_that("Checking anlz_trndseason, center window", {
  
  tomod <- rawdat %>%
    dplyr::filter(station %in% 32) %>%
    dplyr::filter(param %in% 'chl')
  
  # use previously fitted list of models
  trans <- 'boxcox'
  mods <- list(
    gam0 = anlz_gam(tomod, mod = 'gam0', trans = trans)
  )
  result <- anlz_trndseason(mods = mods, doystr = 90, doyend = 180, justify = 'center', win = 5) %>% 
    dplyr::pull(pval) %>% 
    .[(length(.) - 3):length(.)]
  
  expect_equal(sum(is.na(result)), 3)
  
})

test_that("Checking anlz_trndseason, right window", {
  
  tomod <- rawdat %>%
    dplyr::filter(station %in% 32) %>%
    dplyr::filter(param %in% 'chl')
  
  # use previously fitted list of models
  trans <- 'boxcox'
  mods <- list(
    gam0 = anlz_gam(tomod, mod = 'gam0', trans = trans)
  )
  result <- anlz_trndseason(mods = mods, doystr = 90, doyend = 180, justify = 'right', win = 5) %>% 
    dplyr::pull(pval) %>% 
    .[(length(.) - 3):length(.)]
  
  expect_equal(sum(is.na(result)), 0)
  
})
