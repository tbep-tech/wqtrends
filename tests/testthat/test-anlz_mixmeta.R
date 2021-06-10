test_that("Checking anlz_mixmeta", {

  avgseason <- anlz_metseason(mod, doystr = 90, doyend = 180)
  result <- anlz_mixmeta(avgseason, yrstr = 2000, yrend = 2017)
  
  expect_is(result, 'mixmeta')
  
})
