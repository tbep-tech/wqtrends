test_that("Checking show_prdseries class", {
  
  result <- show_prdseries(mod, ylab = 'Chlorophyll-a (ug/L)')
  
  expect_is(result, 'ggplot')
  
})

test_that("Checking show_series yromit argument works", {
  
  # normal year omit
  result <- show_prdseries(mod, ylab = 'Chlorophyll-a (ug/L)', yromit = 2016)
  
  chk <- result$data[result$data$yr == 2016, 'value',]
  expect_true(all(is.na(chk)))
  
  # year omit outside of range
  result <- show_prdseries(mod, ylab = 'Chlorophyll-a (ug/L)', yromit = 2014)
  
  chk <- result$data[result$data$yr == 2014, 'value',]
  expect_true(length(chk) == 0)

  # edge case model full missing years
  tomod <- subset(rawdat, rawdat$station == 34 & rawdat$param == 'chl' & yr > 2014)
  tomod <- subset(tomod, tomod$cont_year < 2016 | tomod$cont_year >= 2019)
  mod <- anlz_gam(tomod, trans = 'log10')

  result <- show_prdseries(mod, ylab = 'Chlorophyll-a (ug/L)', yromit = 2017)

  chk <- na.omit(result$data[result$data$yr == 2017, 'value',])
  expect_true(length(chk) == 0)

  # edge case model partial missing years
  tomod <- subset(rawdat, rawdat$station == 34 & rawdat$param == 'chl' & yr > 2014)
  tomod <- subset(tomod, tomod$cont_year < 2016 | tomod$cont_year >= 2018.6)
  mod <- anlz_gam(tomod, trans = 'log10')

  result <- show_prdseries(mod, ylab = 'Chlorophyll-a (ug/L)', yromit = 2018)

  chk <- na.omit(result$data[result$data$yr == 2018, 'value',])
  expect_true(length(chk) > 0)
  
})
