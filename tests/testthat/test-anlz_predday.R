test_that("Checking anlz_predday", {
  
  tomod <- rawdat %>%
    dplyr::filter(station %in% 32) %>%
    dplyr::filter(param %in% 'chl')
  
  result <- anlz_predday(tomod, trans = 'boxcox') %>% 
    dplyr::pull(value) %>% 
    .[1:4]
  
  expect_equal(result, c(0.798580659753883, 0.797499400311982, 0.796513743884596, 0.795641482340693))
  
})

test_that("Checking anlz_predday error", {
  
  expect_error(anlz_predday(), 'Must supply one of moddat or mods')
  
})

test_that("Checking anlz_predday list input", {
  
  tomod <- rawdat %>%
    dplyr::filter(station %in% 32) %>%
    dplyr::filter(param %in% 'chl')
  trans <- 'boxcox'
  mods <- list(
    gam0 = anlz_gam(tomod, mod = 'gam0', trans = trans),
    gam1 = anlz_gam(tomod, mod = 'gam1', trans = trans),
    gam2 = anlz_gam(tomod, mod = 'gam2', trans = trans)
  )
  
  result <- anlz_predday(mods = mods) %>% 
    dplyr::pull(value) %>% 
    .[1:4]
  
  expect_equal(result, c(0.798580659753883, 0.797499400311982, 0.796513743884596, 0.795641482340693))
  
})

