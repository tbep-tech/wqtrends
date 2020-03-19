test_that("Checking anlz_pvalformat", {
  
  result <- anlz_pvalformat(0.05)
  expect_equal(result, 'ns')
  
  result <- anlz_pvalformat(0.0001)
  expect_equal(result, 'p < 0.001')
  
})
