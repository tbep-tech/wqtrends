test_that("Checking anlz_avgseason", {
  
  # use previously fitted list of models
  tomod <- rawdat %>%
    dplyr::filter(station %in% 32) %>%
    dplyr::filter(param %in% 'chl')
  result <- anlz_avgseason(tomod, trans = 'log10', doystr = 90, doyend = 180) 
  
  expect_equal(nrow(result), 120)
  
})

test_that("Checking , list input", {
  
  tomod <- rawdat %>%
    dplyr::filter(station %in% 32) %>%
    dplyr::filter(param %in% 'chl')
  
  # use previously fitted list of models
  trans <- 'log10'
  mods <- list(
    gam0 = anlz_gam(tomod, mod = 'gam0', trans = trans),
    gam1 = anlz_gam(tomod, mod = 'gam1', trans = trans),
    gam2 = anlz_gam(tomod, mod = 'gam2', trans = trans)
  )
  result <- anlz_avgseason(mods = mods, doystr = 90, doyend = 180) 
  
  expect_equal(nrow(result), 90)
  
})

test_that("Checking  error, insufficient inputs", {
  
  expect_error(anlz_avgseason(doystr = 90, doyend = 180))
  
})
