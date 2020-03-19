test_that("Checking show_perchg class", {
  
  tomod <- rawdat %>%
    dplyr::filter(station %in% 32) %>%
    dplyr::filter(param %in% 'chl')
  result <- show_perchg(moddat = tomod, gami = 'gam1', baseyr = 1990, testyr = 2017, ylab = 'Chlorophyll-a (ug/L)', trans = 'boxcox')
  
  expect_is(result, 'ggplot')
  
})

test_that("Checking show_perchg class, list input", {
  
  tomod <- rawdat %>%
    dplyr::filter(station %in% 32) %>%
    dplyr::filter(param %in% 'chl')
  trans <- 'boxcox'
  mods <- list(
    gam1 = anlz_gam(tomod, trans = trans)
  )
  result <- show_perchg(mods = mods, baseyr = 1990, testyr = 2017, ylab = 'Chlorophyll-a (ug/L)')
  
  expect_is(result, 'ggplot')
  
})

test_that("Checking show_perchg error, more than one model", {
  
  tomod <- rawdat %>%
    dplyr::filter(station %in% 32) %>%
    dplyr::filter(param %in% 'chl')
  trans <- 'boxcox'
  mods <- list(
    gam0 = anlz_gam(tomod, mod = 'gam0', trans = trans),
    gam1 = anlz_gam(tomod, mod = 'gam1', trans = trans)
  )
  
  expect_error(show_perchg(mods = mods, baseyr = 1990, testyr = 2017, ylab = 'Chlorophyll-a (ug/L)'))
  
})

test_that("Checking show_perchg error, insufficient inputs", {
  
  expect_error(show_perchg(baseyr = 1990, testyr = 2017, ylab = 'Chlorophyll-a (ug/L)'))
  
})
