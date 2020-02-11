test_that("Checking anlz_smooth", {
  
  tomod <- rawdat %>%
    filter(station %in% 32) %>%
    filter(param %in% 'chl')
  
  result <- anlz_smooth(tomod, trans = 'boxcox') %>% 
    pull(p.value)
  
  expect_equal(result, c(1.32020868122307e-20, 1.99791202122216e-06, 3.9907884821717e-22, 
                         1.73830208627285e-06, 2.9035617099093e-22, 0.00499890176854272, 
                         1.47911288547221e-31, 1.54611825691792e-08))
})

test_that("Checking anlz_smooth error", {

  expect_error(anlz_smooth(), 'Must supply one of rawdat or mods')
  
})

test_that("Checking anlz_smooth list input", {
  
  tomod <- rawdat %>%
    filter(station %in% 32) %>%
    filter(param %in% 'chl')
  trans <- 'boxcox'
  mods <- list(
    gam0 = anlz_gam(tomod, mod = 'gam0', trans = trans),
    gam1 = anlz_gam(tomod, mod = 'gam1', trans = trans),
    gam2 = anlz_gam(tomod, mod = 'gam2', trans = trans)
    )
  
  result <- anlz_smooth(mods = mods) %>% 
    pull(p.value)
  
  expect_equal(result, c(1.32020868122307e-20, 1.99791202122216e-06, 3.9907884821717e-22, 
                         1.73830208627285e-06, 2.9035617099093e-22, 0.00499890176854272)
               )
})

