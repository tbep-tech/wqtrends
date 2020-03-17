test_that("Checking anlz_pred", {
  
  tomod <- rawdat %>%
    dplyr::filter(station %in% 32) %>%
    dplyr::filter(param %in% 'chl')
  
  result <- anlz_pred(tomod, trans = 'boxcox') %>% 
    dplyr::pull(value) %>% 
    .[1:4]
  
  expect_equal(result, c(0.809897757339221, 0.860686411752397, 0.968283680776105, 1.14836942356245))
  
})

test_that("Checking anlz_pred error", {
  
  expect_error(anlz_pred(), 'Must supply one of moddat or mods')
  
})

test_that("Checking anlz_pred list input", {
  
  tomod <- rawdat %>%
    dplyr::filter(station %in% 32) %>%
    dplyr::filter(param %in% 'chl')
  trans <- 'boxcox'
  mods <- list(
    gam0 = anlz_gam(tomod, mod = 'gam0', trans = trans),
    gam1 = anlz_gam(tomod, mod = 'gam1', trans = trans),
    gam2 = anlz_gam(tomod, mod = 'gam2', trans = trans)
  )
  
  result <- anlz_pred(mods = mods) %>% 
    dplyr::pull(value) %>% 
    .[1:4]
  
  
  expect_equal(result, c(0.809897757339221, 0.860686411752397, 0.968283680776105, 1.14836942356245))
  
})

