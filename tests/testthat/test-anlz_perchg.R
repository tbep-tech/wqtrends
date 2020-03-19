test_that("Checking anlz_perchg", {
  
  # use previously fitted list of models
  tomod <- rawdat %>%
    dplyr::filter(station %in% 32) %>%
    dplyr::filter(param %in% 'chl')
  result <- anlz_perchg(tomod, trans = 'log10', baseyr = 1990, testyr = 2016) %>% 
    dplyr::pull(pval)
  
  expect_equal(result, c(1.23768398363824e-05, 0.00141257624554702, 0.590013237142406, 0.0531372755991334))
  
})

test_that("Checking anlz_perchg, list input", {
  
  tomod <- rawdat %>%
    dplyr::filter(station %in% 32) %>%
    dplyr::filter(param %in% 'chl')
  
  # use previously fitted list of models
  trans <- 'boxcox'
  mods <- list(
    gam0 = anlz_gam(tomod, mod = 'gam0', trans = trans),
    gam1 = anlz_gam(tomod, mod = 'gam1', trans = trans),
    gam2 = anlz_gam(tomod, mod = 'gam2', trans = trans)
    )
  result <- anlz_perchg(mods = mods, baseyr = 1990, testyr = 2016) %>% 
    dplyr::pull(pval)
  
  expect_equal(result, c(1.08860890491265e-07, 0.00124610109460743, 0.489365441765695))
  
})

test_that("Checking anlz_perchg error, insufficient inputs", {
  
  expect_error(anlz_perchg(baseyr = 1996, testyr = 2016))
  
})
