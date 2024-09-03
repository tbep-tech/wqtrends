test_that("anlz_sumstats returns correct structure", {
  result <- anlz_sumstats(mod, metfun = mean, doystr = 90, doyend = 180, yrstr = 2016, yrend = 2019, nsim = 100)
  
  expect_type(result, "list")
  expect_named(result, c("mixmet", "metseason", "summary", "coeffs"))
})

test_that("anlz_sumstats throws error for incorrect metfun with useave = TRUE", {

  expect_error(
    anlz_sumstats(mod, metfun = max, doystr = 90, doyend = 180, yrstr = 2016, yrend = 2019, nsim = 100, useave = TRUE),
    "Specify metfun = mean if useave = T"
  )
})

test_that("anlz_sumstats includes slope.approx when trans = 'log10'", {
  result <- anlz_sumstats(mod, metfun = mean, doystr = 90, doyend = 180, yrstr = 2016, yrend = 2019, nsim = 100)
  expect_true("slope.approx" %in% names(result$coeffs))
})

test_that("anlz_sumstats omits specified years", {
  yromit <- c(2017, 2018)
  result <- anlz_sumstats(mod, metfun = mean, doystr = 90, doyend = 180, yrstr = 2016, yrend = 2019, nsim = 100, yromit = yromit)
  
  expect_false(any(result$metseason$yr %in% yromit))
})

test_that("anlz_sumstats calculates correctly with useave = TRUE and metfun = mean", {
  
  result <- anlz_sumstats(mod, metfun = mean, doystr = 90, doyend = 180, yrstr = 2016, yrend = 2019, nsim = 100, useave = TRUE)
  
  expect_type(result, "list")
  expect_named(result, c("mixmet", "metseason", "summary", "coeffs"))
})

