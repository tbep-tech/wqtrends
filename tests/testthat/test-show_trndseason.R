test_that("Checking show_trndseason class", {
  
  tomod <- rawdat %>%
    dplyr::filter(station %in% 32) %>%
    dplyr::filter(param %in% 'chl')
  result <- show_trndseason(moddat = tomod, gami = 'gam1', doystr = 90, doyend = 180, justify = 'left', win = 5, ylab = 'Slope chlorophyll-a (ug/L)', trans = 'boxcox')
  
  expect_is(result, 'ggplot')
  
})

test_that("Checking show_trndseason class, list input", {
  
  tomod <- rawdat %>%
    dplyr::filter(station %in% 32) %>%
    dplyr::filter(param %in% 'chl')
  trans <- 'boxcox'
  mods <- list(
    gam1 = anlz_gam(tomod, trans = trans)
  )
  result <- show_trndseason(mods = mods, doystr = 90, doyend = 180, justify = 'left', win = 5, ylab = 'Slope chlorophyll-a (ug/L)')
  
  expect_is(result, 'ggplot')
  
})

test_that("Checking show_trndseason error, more than one model", {
  
  tomod <- rawdat %>%
    dplyr::filter(station %in% 32) %>%
    dplyr::filter(param %in% 'chl')
  trans <- 'boxcox'
  mods <- list(
    gam0 = anlz_gam(tomod, mod = 'gam0', trans = trans),
    gam1 = anlz_gam(tomod, mod = 'gam1', trans = trans)
  )
  
  expect_error(show_trndseason(mods = mods, doystr = 90, doyend = 180, justify = 'left', win = 5, ylab = 'Slope chlorophyll-a (ug/L)'))
  
})

test_that("Checking show_trndseason error, insufficient inputs", {
  
  expect_error(show_avgseason(doystr = 90, doyend = 180, justify = 'left', win = 5, ylab = 'Slope chlorophyll-a (ug/L)'))
  
})
