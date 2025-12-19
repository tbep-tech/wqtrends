# Estimate rates of change based on seasonal metrics

Estimate rates of change based on seasonal metrics

## Usage

``` r
anlz_trndseason(
  mod,
  metfun = mean,
  doystr = 1,
  doyend = 364,
  justify = c("center", "left", "right"),
  win = 5,
  nsim = 10000,
  yromit = NULL,
  useave = FALSE,
  ...
)
```

## Arguments

- mod:

  input model object as returned by
  [`anlz_gam`](https://tbep-tech.github.io/wqtrends/reference/anlz_gam.md)

- metfun:

  function input for metric to calculate, e.g., `mean`, `var`, `max`,
  etc

- doystr:

  numeric indicating start Julian day for extracting averages

- doyend:

  numeric indicating ending Julian day for extracting averages

- justify:

  chr string indicating the justification for the trend window

- win:

  numeric indicating number of years to use for the trend window, see
  details

- nsim:

  numeric indicating number of random draws for simulating uncertainty

- yromit:

  optional numeric vector for years to omit from the output

- useave:

  logical indicating if `anlz_avgseason` is used for the seasonal metric
  calculation, see details

- ...:

  additional arguments passed to `metfun`, e.g., `na.rm = TRUE`

## Value

A data frame of slope estimates and p-values for each year

## Details

Trends are based on the slope of the fitted linear trend within the
window, where the linear trend is estimated using a meta-analysis
regression model (from
[`anlz_mixmeta`](https://tbep-tech.github.io/wqtrends/reference/anlz_mixmeta.md))
for the seasonal metrics (from
[`anlz_metseason`](https://tbep-tech.github.io/wqtrends/reference/anlz_metseason.md)).
Set `useave = T` to speed up calculations if `metfun = mean`. This will
use
[`anlz_avgseason`](https://tbep-tech.github.io/wqtrends/reference/anlz_avgseason.md)
to estimate the seasonal summary metrics using a non-stochastic
equation.

Note that for left and right windows, the exact number of years in `win`
is used. For example, a left-centered window for 1990 of ten years will
include exactly ten years from 1990, 1991, ... , 1999. The same applies
to a right-centered window, e.g., 1990 would include 1981, 1982, ...,
1990 (if those years have data). However, for a centered window, picking
an even number of years for the window width will create a slightly
off-centered window because it is impossible to center on an even number
of years. For example, if `win = 8` and `justify = 'center'`, the
estimate for 2000 will be centered on 1997 to 2004 (three years left,
four years right, eight years total). Centering for window widths with
an odd number of years will always create a symmetrical window, i.e., if
`win = 7` and `justify = 'center'`, the estimate for 2000 will be
centered on 1997 and 2003 (three years left, three years right, seven
years total).

The optional `yromit` vector can be used to omit years from the trend
assessment. This may be preferred if seasonal estimates for a given year
have very wide confidence intervals likely due to limited data, which
can skew the trend assessments.

## See also

Other analyze:
[`anlz_sumtrndseason()`](https://tbep-tech.github.io/wqtrends/reference/anlz_sumtrndseason.md),
[`anlz_trans()`](https://tbep-tech.github.io/wqtrends/reference/anlz_trans.md)

## Examples

``` r
library(dplyr)

# data to model
tomod <- rawdat %>%
  filter(station %in% 34) %>%
  filter(param %in% 'chl') %>% 
  filter(yr > 2015)

mod <- anlz_gam(tomod, trans = 'log10')
anlz_trndseason(mod, doystr = 90, doyend = 180, justify = 'center', win = 4)
#> # A tibble: 4 × 12
#>      yr   met     se bt_lwr bt_upr bt_met dispersion   yrcoef    pval
#>   <dbl> <dbl>  <dbl>  <dbl>  <dbl>  <dbl>      <dbl>    <dbl>   <dbl>
#> 1  2016 0.766 0.0832   4.58   9.70   6.67     0.0504 NaN      NaN    
#> 2  2017 0.772 0.0798   4.72   9.70   6.77     0.0504   0.0372   0.563
#> 3  2018 1.03  0.0726   8.78  16.9   12.2      0.0504 NaN      NaN    
#> 4  2019 0.808 0.0719   5.31  10.2    7.34     0.0504 NaN      NaN    
#> # ℹ 3 more variables: appr_yrcoef <dbl>, yrcoef_lwr <dbl>, yrcoef_upr <dbl>
```
