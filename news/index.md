# Changelog

## wqtrends 1.5.1

CRAN release: 2025-07-09

- Added `yromit` argument to
  [`show_prddoy()`](https://tbep-tech.github.io/wqtrends/reference/show_prddoy.md),
  [`show_prdseason()`](https://tbep-tech.github.io/wqtrends/reference/show_prdseason.md),
  and
  [`show_prdseries()`](https://tbep-tech.github.io/wqtrends/reference/show_prdseries.md)
  to omit years from the plots
- Added `seascol` and `trndcol` arguments to
  [`show_metseason()`](https://tbep-tech.github.io/wqtrends/reference/show_metseason.md)
  for changing the colors of the seasonal metric points and trend line,
  respectively

## wqtrends 1.5.0

CRAN release: 2024-09-04

- Added
  [`anlz_sumstats()`](https://tbep-tech.github.io/wqtrends/reference/anlz_sumstats.md)
  function to return summary statistics from a GAM and mixed-effects
  meta-analysis trend model
- [`show_trndseason()`](https://tbep-tech.github.io/wqtrends/reference/show_trndseason.md)
  has `nms`, `fils`, and `cols` arguments for trend names in legend,
  interior fill of points, and color of confidence intervals
- Fix bug for incorrect assignment of scale manual entries for color,
  fill, and shapes in
  [`show_trndseason()`](https://tbep-tech.github.io/wqtrends/reference/show_trndseason.md)
- Fix bug for incorrect use of `yromit` argument for removing years from
  plots and trend analysis
- Removed `usearrow` option from
  [`show_trndseason()`](https://tbep-tech.github.io/wqtrends/reference/show_trndseason.md)
  and replaced with item two above

## wqtrends 1.4.2

CRAN release: 2024-01-26

- [`show_trndseason()`](https://tbep-tech.github.io/wqtrends/reference/show_trndseason.md)
  has option `usearrow` to plot points as up or down arrows for trend
  direction
- [`show_metseason()`](https://tbep-tech.github.io/wqtrends/reference/show_metseason.md)
  no longer returns ambiguous error if `yrstr` or `yrend` are `NULL`
- [`show_mettrndseason()`](https://tbep-tech.github.io/wqtrends/reference/show_mettrndseason.md)
  function added to plot trend and seasonal metrics in a single plot
- All `show_*()` functions no longer have serif base font
- Added `col` argument for line color to
  [`show_prdseries()`](https://tbep-tech.github.io/wqtrends/reference/show_prdseries.md)
- Added GitHub URLs to DESCRIPTION

## wqtrends 1.4.1

CRAN release: 2023-08-17

- Initial CRAN submission.
- [`anlz_gam()`](https://tbep-tech.github.io/wqtrends/reference/anlz_gam.md)
  has try silent, shows `cat` message about knots instead
- Shortened examples in help documentation to reduce runtime
- Update tests for
  [`show_metseason()`](https://tbep-tech.github.io/wqtrends/reference/show_metseason.md)
  and
  [`anlz_gam()`](https://tbep-tech.github.io/wqtrends/reference/anlz_gam.md)
  to increase coverage
- Changed README links to pass CRAN checks
- Added CITATION file
- Added NEWS file

## wqtrends 1.4.0

- Added `annual` argument to `anlz_pred()` to return predictions only
  for the `cont_year` smoother
- Vignette clarity on the appropriate type of data for use with the
  package
- Fix to window centering and help file clarification for
  [`anlz_trndseason()`](https://tbep-tech.github.io/wqtrends/reference/anlz_trndseason.md)
- Fix for values less than zero if `trans` is `log10` in
  [`anlz_trans()`](https://tbep-tech.github.io/wqtrends/reference/anlz_trans.md)
- Returned
  [`anlz_avgseason()`](https://tbep-tech.github.io/wqtrends/reference/anlz_avgseason.md)
  function to package, this was previously removed for a more generic
  version of the function
- Added
  [`anlz_sumtrndseason()`](https://tbep-tech.github.io/wqtrends/reference/anlz_sumtrndseason.md)
  and
  [`show_sumtrndseason()`](https://tbep-tech.github.io/wqtrends/reference/show_sumtrndseason.md)
  for evaluating trends with multiple window widths in a single plot
- Added `useave` argument to `show_meatseason()` to use
  [`anlz_avgseason()`](https://tbep-tech.github.io/wqtrends/reference/anlz_avgseason.md)
  for the estimate, this decreases computation time
- Added `base_size` argument to most plot function to change the base
  font sizes
- Fix where season day of year range was hard-coded in
  [`show_sumtrndseason()`](https://tbep-tech.github.io/wqtrends/reference/show_sumtrndseason.md)
- Added `show_trndseason2()` as modification to
  [`show_trndseason()`](https://tbep-tech.github.io/wqtrends/reference/show_trndseason.md)
  to plot summaries in seasonal quarters
- Added documentation update about suppressing trend lines in
  [`show_metseason()`](https://tbep-tech.github.io/wqtrends/reference/show_metseason.md)
- Added documentatoin about the default transformation in
  [`anlz_gam()`](https://tbep-tech.github.io/wqtrends/reference/anlz_gam.md)
- Fix to
  [`anlz_prdmatrix()`](https://tbep-tech.github.io/wqtrends/reference/anlz_prdmatrix.md)
  for start of date origin when using `doystr` and `doyend`
- Added dispersion parameter to output of
  [`anlz_avgseason()`](https://tbep-tech.github.io/wqtrends/reference/anlz_avgseason.md)
  and
  [`anlz_metseason()`](https://tbep-tech.github.io/wqtrends/reference/anlz_metseason.md)
- Added `yromit` argument to omit years from the plot and trend with
  [`show_metseason()`](https://tbep-tech.github.io/wqtrends/reference/show_metseason.md)
- Added `xlim` and `ylim` argument to most plot functions

## wqtrends 1.3.0

- Removed
  [`anlz_avgseason()`](https://tbep-tech.github.io/wqtrends/reference/anlz_avgseason.md),
  all seasonal metrics estimated with
  [`anlz_metseason()`](https://tbep-tech.github.io/wqtrends/reference/anlz_metseason.md).

## wqtrends 1.2.0

- Addition of functions for calculating generic seasonal metrics

## wqtrends 1.1.0

- Update for manuscript draft

## wqtrends 1.0.0

- First release
