# Extract period (seasonal) metrics from fitted GAM

Extract period (seasonal) metrics from fitted GAM

## Usage

``` r
anlz_metseason(
  mod,
  metfun = mean,
  doystr = 1,
  doyend = 364,
  nsim = 10000,
  yromit = NULL,
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

- nsim:

  numeric indicating number of random draws for simulating uncertainty

- yromit:

  optional numeric vector for years to omit from the output

- ...:

  additional arguments passed to `metfun`, e.g., `na.rm = TRUE`

## Value

A data frame of period metrics

## Details

This function estimates a metric of interest for a given seasonal period
each year using results from a fitted GAM (i.e., from
[`anlz_gam`](https://tbep-tech.github.io/wqtrends/reference/anlz_gam.md)).
The estimates are based on the predicted values for each seasonal
period, with uncertainty of the metric based on repeated sampling of the
predictions following uncertainty in the model coefficients.

## Examples

``` r
library(dplyr)

# data to model
tomod <- rawdat %>%
  filter(station %in% 34) %>%
  filter(param %in% 'chl') %>% 
  filter(yr > 2015)

mod <- anlz_gam(tomod, trans = 'log10')
anlz_metseason(mod, mean, doystr = 90, doyend = 180, nsim = 100)
#> # A tibble: 4 × 7
#>      yr   met     se bt_lwr bt_upr bt_met dispersion
#>   <dbl> <dbl>  <dbl>  <dbl>  <dbl>  <dbl>      <dbl>
#> 1  2016 0.766 0.0859   4.52   9.82   6.67     0.0504
#> 2  2017 0.772 0.0808   4.70   9.75   6.77     0.0504
#> 3  2018 1.03  0.0760   8.64  17.2   12.2      0.0504
#> 4  2019 0.808 0.0654   5.47   9.86   7.34     0.0504
```
