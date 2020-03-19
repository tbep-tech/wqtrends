test_that("Checking show_prd3d class", {
  
  tomod <- rawdat %>%
    dplyr::filter(station %in% 32) %>%
    dplyr::filter(param %in% 'chl')
  result <- show_prd3d(moddat = tomod, ylab = 'Chlorophyll-a (ug/L)', trans = 'boxcox')
  
  expect_is(result, 'plotly')
  
})

test_that("Checking show_prd3d class, list input", {
  
  tomod <- rawdat %>%
    dplyr::filter(station %in% 32) %>%
    dplyr::filter(param %in% 'chl')
  trans <- 'boxcox'
  mods <- list(
    gam1 = anlz_gam(tomod, trans = trans)
    )
  result <- show_prd3d(mods = mods, ylab = 'Chlorophyll-a')

  expect_is(result, 'plotly')
  
})

test_that("Checking show_prd3d error, more than one model", {
  
  tomod <- rawdat %>%
    dplyr::filter(station %in% 32) %>%
    dplyr::filter(param %in% 'chl')
  trans <- 'boxcox'
  mods <- list(
    gam0 = anlz_gam(tomod, mod = 'gam0', trans = trans),
    gam1 = anlz_gam(tomod, mod = 'gam1', trans = trans)
    )
  
  expect_error(show_prd3d(mods = mods, ylab = 'Chlorophyll-a (ug/L)'))
  
})

test_that("Checking show_prd3d error, insufficient inputs", {
  
  expect_error(show_prd3d(ylab = 'Chlorophyll-a (ug/L)'))
  
})
