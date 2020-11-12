test_that("Checking anlz_perchg", {
  
  # use previously fitted list of models
  tomod <- rawdat %>%
    dplyr::filter(station %in% 32) %>%
    dplyr::filter(param %in% 'chl')
  result <- anlz_perchg(tomod, trans = 'log10', baseyr = 1990, testyr = 2016) 
  
  expect_equal(nrow(result), 4)
  
})

test_that("Checking anlz_perchg, list input", {
  
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
  result <- anlz_perchg(mods = mods, baseyr = 1990, testyr = 2016) 
  
  expect_equal(nrow(result), 3)
  
})

test_that("Checking anlz_perchg error, insufficient inputs", {
  
  expect_error(anlz_perchg(baseyr = 1996, testyr = 2016))
  
})
