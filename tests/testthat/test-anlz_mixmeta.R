test_that("Checking anlz_mixmeta", {

  # fit models with function
  tomod <- rawdat %>%
    dplyr::filter(station %in% 32) %>%
    dplyr::filter(param %in% 'chl')
  trans <- 'boxcox'
  mods <- list(
    gam0 = anlz_gam(tomod, mod = 'gam0', trans = trans),
    gam1 = anlz_gam(tomod, mod = 'gam1', trans = trans),
    gam2 = anlz_gam(tomod, mod = 'gam2', trans = trans)
    )
  avgseason <- anlz_avgseason(mods = mods, doystr = 90, doyend = 180)
  result <- anlz_mixmeta(avgseason, yrstr = 2000, yrend = 2017)
  
  expect_is(result[[1]], 'mixmeta')
  
})
