# Fit a generalized additive model to a water quality time series

Fit a generalized additive model to a water quality time series

## Usage

``` r
anlz_gam(moddat, kts = NULL, ...)
```

## Arguments

- moddat:

  input raw data, one station and paramater

- kts:

  optional numeric vector for the upper limit for the number of knots in
  the term `s(cont_year)`, see details

- ...:

  additional arguments passed to other methods, i.e., `trans = 'log10'`
  (default) or `trans = 'ident'` passed to
  [`anlz_trans`](https://tbep-tech.github.io/wqtrends/reference/anlz_trans.md)

## Value

a [`gam`](https://rdrr.io/pkg/mgcv/man/gam.html) model object

## Details

The model structure is as follows:

- model S::

  chl ~ s(cont_year, k = large)

The `cont_year` vector is measured as a continuous numeric variable for
the annual effect (e.g., January 1st, 2000 is 2000.0, July 1st, 2000 is
2000.5, etc.) and `doy` is the day of year as a numeric value from 1 to
366. The function [`s`](https://rdrr.io/pkg/mgcv/man/s.html) models
`cont_year` as a smoothed, non-linear variable. The optimal amount of
smoothing on `cont_year` is determined by cross-validation as
implemented in the mgcv package and an upper theoretical upper limit on
the number of knots for `k` should be large enough to allow sufficient
flexibility in the smoothing term. The upper limit of `k` was chosen as
12 times the number of years for the input data. If insufficient data
are available to fit a model with the specified `k`, the number of knots
is decreased until the data can be modelled, e.g., 11 times the number
of years, 10 times the number of years, etc.

## Examples

``` r
library(dplyr)
tomod <- rawdat %>% 
  filter(station %in% 34) %>% 
  filter(param %in% 'chl')
anlz_gam(tomod, trans = 'log10')
#> 
#> Family: gaussian 
#> Link function: identity 
#> 
#> Formula:
#> value ~ s(cont_year, k = 348)
#> 
#> Estimated degrees of freedom:
#> 219  total = 219.93 
#> 
#> GCV score: 0.07280572     
```
