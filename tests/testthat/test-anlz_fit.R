test_that("Checking anlz_fit", {
  
  tomod <- rawdat %>%
    dplyr::filter(station %in% 32) %>%
    dplyr::filter(param %in% 'chl')
  
  result <- anlz_fit(tomod, trans = 'boxcox') %>% 
    dplyr::pull(GCV)
  
  expect_equal(result, c(0.20838139957666, 0.180024757476673, 0.165008005675826, 0.124750943243962))
  
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
    gam2 = anlz_gam(tomod, mod = 'gam2', trans = trans)
  )
  
  result <- anlz_fit(mods = mods) %>% 
    dplyr::pull(GCV)
  
  expect_equal(result, c(0.20838139957666, 0.180024757476673, 0.165008005675826))
  
})

