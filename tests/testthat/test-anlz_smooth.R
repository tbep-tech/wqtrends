test_that("Checking anlz_smooth", {
  
  tomod <- rawdat %>%
    dplyr::filter(station %in% 32) %>%
    dplyr::filter(param %in% 'chl')
  
  result <- anlz_smooth(tomod, trans = 'boxcox') %>% 
    dplyr::pull(p.value)
  
  expect_equal(result, c(4.00466782830621e-51, 9.53755596319021e-21, 2.03913127920902e-62, 
                         6.36553689087831e-19, 8.6379180235765e-70, 4.21392912286391e-09, 
                         2.08098119593359e-102, 6.36109749896328e-16))
  
})

test_that("Checking anlz_smooth error", {

  expect_error(anlz_smooth(), 'Must supply one of moddat or mods')
  
})

test_that("Checking anlz_smooth list input", {
  
  tomod <- rawdat %>%
    dplyr::filter(station %in% 32) %>%
    dplyr::filter(param %in% 'chl')
  trans <- 'boxcox'
  mods <- list(
    gam0 = anlz_gam(tomod, mod = 'gam0', trans = trans),
    gam1 = anlz_gam(tomod, mod = 'gam1', trans = trans),
    gam2 = anlz_gam(tomod, mod = 'gam2', trans = trans)
    )
  
  result <- anlz_smooth(mods = mods) %>% 
    dplyr::pull(p.value)
  
  expect_equal(result, c(4.00466782830621e-51, 9.53755596319021e-21, 2.03913127920902e-62, 
                         6.36553689087831e-19, 8.6379180235765e-70, 4.21392912286391e-09))
  
})

