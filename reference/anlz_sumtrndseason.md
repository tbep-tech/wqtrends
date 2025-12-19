# Estimate seasonal rates of change based on average estimates for multiple window widths

Estimate seasonal rates of change based on average estimates for
multiple window widths

## Usage

``` r
anlz_sumtrndseason(
  mod,
  doystr = 1,
  doyend = 364,
  justify = c("center", "left", "right"),
  win = 5:15,
  yromit = NULL
)
```

## Arguments

- mod:

  input model object as returned by
  [`anlz_gam`](https://tbep-tech.github.io/wqtrends/reference/anlz_gam.md)

- doystr:

  numeric indicating start Julian day for extracting averages

- doyend:

  numeric indicating ending Julian day for extracting averages

- justify:

  chr string indicating the justification for the trend window

- win:

  numeric vector indicating number of years to use for the trend window

- yromit:

  optional numeric vector for years to omit from the plot, see details

## Value

A data frame of slope estimates and p-values for each year

## Details

The optional `yromit` vector can be used to omit years from the plot and
trend assessment. This may be preferred if seasonal estimates for a
given year have very wide confidence intervals likely due to limited
data, which can skew the trend assessments.

This function is a wrapper to
[`anlz_trndseason`](https://tbep-tech.github.io/wqtrends/reference/anlz_trndseason.md)
to loop across values in `win`, using `useave = TRUE` for quicker
calculation of average seasonal metrics. It does not work with any other
seasonal metric calculations.

## See also

Other analyze:
[`anlz_trans()`](https://tbep-tech.github.io/wqtrends/reference/anlz_trans.md),
[`anlz_trndseason()`](https://tbep-tech.github.io/wqtrends/reference/anlz_trndseason.md)

## Examples

``` r
library(dplyr)

# data to model
tomod <- rawdat %>%
  filter(station %in% 34) %>%
  filter(param %in% 'chl') %>% 
  filter(yr > 2015)

mod <- anlz_gam(tomod, trans = 'log10')
anlz_sumtrndseason(mod, doystr = 90, doyend = 180, justify = 'center', win = 2:3)
#> # A tibble: 8 × 4
#>      yr    yrcoef     pval   win
#>   <dbl>     <dbl>    <dbl> <int>
#> 1  2016   0.00659   0.958      2
#> 2  2017   0.255     0.0289     2
#> 3  2018  -0.220     0.0497     2
#> 4  2019 NaN       NaN          2
#> 5  2016 NaN       NaN          3
#> 6  2017   0.134     0.0605     3
#> 7  2018   0.0166    0.904      3
#> 8  2019 NaN       NaN          3
```
