test_that("Checking show_avgseason class", {
  
  tomod <- rawdat %>%
    dplyr::filter(station %in% 32) %>%
    dplyr::filter(param %in% 'chl')
  result <- show_avgseason(moddat = tomod, gami = 'gam1', doystr = 90, doyend = 180, yrstr = 2000, yrend = 2017, ylab = 'Chlorophyll-a (ug/L)', trans = 'log10')
  
  expect_is(result, 'ggplot')
  
})

test_that("Checking show_avgseason class, list input", {
  
  tomod <- rawdat %>%
    dplyr::filter(station %in% 32) %>%
    dplyr::filter(param %in% 'chl')
  trans <- 'log10'
  mods <- list(
    gam1 = anlz_gam(tomod, trans = trans)
  )
  result <- show_avgseason(mods = mods, doystr = 90, doyend = 180, yrstr = 2000, yrend = 2017, ylab = 'Chlorophyll-a (ug/L)')
  
  expect_is(result, 'ggplot')
  
})

test_that("Checking show_avgseason error, more than one model", {
  
  tomod <- rawdat %>%
    dplyr::filter(station %in% 32) %>%
    dplyr::filter(param %in% 'chl')
  trans <- 'log10'
  mods <- list(
    gam0 = anlz_gam(tomod, mod = 'gam0', trans = trans),
    gam1 = anlz_gam(tomod, mod = 'gam1', trans = trans)
  )
  
  expect_error(show_avgseason(mods = mods, doystr = 90, doyend = 180, yrstr = 2000, yrend = 2017, ylab = 'Chlorophyll-a (ug/L)'))
  
})

test_that("Checking show_avgseason error, insufficient inputs", {
  
  expect_error(show_avgseason(doystr = 90, doyend = 180, yrstr = 2000, yrend = 2017, ylab = 'Chlorophyll-a (ug/L)'))
  
})
