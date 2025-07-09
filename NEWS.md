# wqtrends 1.5.1

* Added `yromit` argument to `show_prddoy()`, `show_prdseason()`, and `show_prdseries()` to omit years from the plots
* Added `seascol` and `trndcol` arguments to `show_metseason()` for changing the colors of the seasonal metric points and trend line, respectively 

# wqtrends 1.5.0

* Added `anlz_sumstats()` function to return summary statistics from a GAM and mixed-effects meta-analysis trend model
* `show_trndseason()` has `nms`, `fils`, and `cols` arguments for trend names in legend, interior fill of points, and color of confidence intervals
* Fix bug for incorrect assignment of scale manual entries for color, fill, and shapes in `show_trndseason()`
* Fix bug for incorrect use of `yromit` argument for removing years from plots and trend analysis
* Removed `usearrow` option from `show_trndseason()` and replaced with item two above

# wqtrends 1.4.2

* `show_trndseason()` has option `usearrow` to plot points as up or down arrows for trend direction
* `show_metseason()` no longer returns ambiguous error if `yrstr` or `yrend` are `NULL`
* `show_mettrndseason()` function added to plot trend and seasonal metrics in a single plot
* All `show_*()` functions no longer have serif base font
* Added `col` argument for line color to `show_prdseries()`
* Added GitHub URLs to DESCRIPTION

# wqtrends 1.4.1

* Initial CRAN submission.
* `anlz_gam()` has try silent, shows `cat` message about knots instead
* Shortened examples in help documentation to reduce runtime
* Update tests for `show_metseason()` and `anlz_gam()` to increase coverage
* Changed README links to pass CRAN checks
* Added CITATION file
* Added NEWS file

# wqtrends 1.4.0

* Added `annual` argument to `anlz_pred()` to return predictions only for the `cont_year` smoother
* Vignette clarity on the appropriate type of data for use with the package
* Fix to window centering and help file clarification for `anlz_trndseason()`
* Fix for values less than zero if `trans` is `log10` in `anlz_trans()`
* Returned `anlz_avgseason()` function to package, this was previously removed for a more generic version of the function
* Added `anlz_sumtrndseason()` and `show_sumtrndseason()` for evaluating trends with multiple window widths in a single plot
* Added `useave` argument to `show_meatseason()` to use `anlz_avgseason()` for the estimate, this decreases computation time
* Added `base_size` argument to most plot function to change the base font sizes
* Fix where season day of year range was hard-coded in `show_sumtrndseason()`
* Added `show_trndseason2()` as modification to `show_trndseason()` to plot summaries in seasonal quarters
* Added documentation update about suppressing trend lines in `show_metseason()`
* Added documentatoin about the default transformation in `anlz_gam()`
* Fix to `anlz_prdmatrix()` for start of date origin when using `doystr` and `doyend`
* Added dispersion parameter to output of `anlz_avgseason()` and `anlz_metseason()`
* Added `yromit` argument to omit years from the plot and trend with `show_metseason()`
* Added `xlim` and `ylim` argument to most plot functions

# wqtrends 1.3.0

* Removed `anlz_avgseason()`, all seasonal metrics estimated with `anlz_metseason()`.

# wqtrends 1.2.0

* Addition of functions for calculating generic seasonal metrics

# wqtrends 1.1.0

* Update for manuscript draft

# wqtrends 1.0.0

* First release
