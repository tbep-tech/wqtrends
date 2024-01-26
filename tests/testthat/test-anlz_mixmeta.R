test_that("Checking anlz_mixmeta", {

  avgseason <- anlz_metseason(mod, doystr = 90, doyend = 180)
  result <- anlz_mixmeta(avgseason, yrstr = 2016, yrend = 2019)
  
  expect_is(result, 'mixmeta')
  
})
