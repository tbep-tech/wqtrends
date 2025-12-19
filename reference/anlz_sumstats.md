# Retrieve summary statistics for seasonal metrics and trend results

Retrieve summary statistics for seasonal metrics and trend results

## Usage

``` r
anlz_sumstats(
  mod,
  metfun = mean,
  doystr = 1,
  doyend = 364,
  yrstr = 2000,
  yrend = 2019,
  yromit = NULL,
  nsim = 10000,
  confint = 0.95,
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

- yrstr:

  numeric for starting year for trend model, see details

- yrend:

  numeric for ending year for trend model, see details

- yromit:

  optional numeric vector for years to omit from the plot, see details

- nsim:

  numeric indicating number of random draws for simulating uncertainty

- confint:

  numeric from zero to one indicating confidence interval level for
  summarizing the mixed-effects meta-analysis model, see details

- useave:

  logical indicating if `anlz_avgseason` is used for the seasonal metric
  calculation, see details

- ...:

  additional arguments passed to `metfun`, e.g., `na.rm = TRUE`

## Value

A list object with named elements:

- `mixmet`: [`mixmeta`](https://rdrr.io/pkg/mixmeta/man/mixmeta.html)
  object of the fitted mixed-effects meta-analysis trend model

- `metseason`: tibble object of the fitted seasonal metrics as returned
  by
  [`anlz_metseason`](https://tbep-tech.github.io/wqtrends/reference/anlz_metseason.md)
  or
  [`anlz_avgseason`](https://tbep-tech.github.io/wqtrends/reference/anlz_avgseason.md)

- `summary`: summary of the `mixmet` object

- `coeffs`: tibble object of the slope estimate coefficients from the
  `mixmet` model. An approximately linear slope estimate will be
  included as `slope.approx` if `trans = 'log10'` for the GAM used in
  `mod`.

## Details

This function is primarily for convenience to return summary statistics
of a fitted GAM from
[`anlz_gam`](https://tbep-tech.github.io/wqtrends/reference/anlz_gam.md).

Note that `confint` only applies to the `summary` and `coeffs` list
outputs. It does not apply to the `metseason` list element output that
is default set to 95

Set `useave = T` to speed up calculations if `metfun = mean`. This will
use
[`anlz_avgseason`](https://tbep-tech.github.io/wqtrends/reference/anlz_avgseason.md)
to estimate the seasonal summary metrics using a non-stochastic
equation.

## Examples

``` r
library(dplyr)

# data to model
tomod <- rawdat %>%
  filter(station %in% 34) %>%
  filter(param %in% 'chl') %>% 
  filter(yr > 2015)

mod <- anlz_gam(tomod, trans = 'log10')

anlz_sumstats(mod, metfun = mean, doystr = 90, doyend = 180, yrstr = 2016, 
  yrend = 2019, nsim = 100)
#> $mixmet
#> Call:  mixmeta::mixmeta(formula = met ~ yr, S = S, data = totrnd, random = ~1 | 
#>     yr, method = "reml")
#> 
#> Fixed-effects coefficients:
#> (Intercept)           yr  
#>    -68.5797       0.0344  
#> 
#> 4 units, 1 outcome, 4 observations, 2 fixed and 1 random-effects parameters
#>  logLik      AIC      BIC  
#>  1.0657   3.8687  -0.0519  
#> 
#> 
#> $metseason
#> # A tibble: 4 × 7
#>      yr   met     se bt_lwr bt_upr bt_met dispersion
#>   <dbl> <dbl>  <dbl>  <dbl>  <dbl>  <dbl>      <dbl>
#> 1  2016 0.766 0.103    4.18  10.6    6.67     0.0504
#> 2  2017 0.772 0.0767   4.79   9.57   6.77     0.0504
#> 3  2018 1.03  0.0779   8.57  17.3   12.2      0.0504
#> 4  2019 0.808 0.0657   5.46   9.88   7.34     0.0504
#> 
#> $summary
#> Call:  mixmeta::mixmeta(formula = met ~ yr, S = S, data = totrnd, random = ~1 | 
#>     yr, method = "reml")
#> 
#> Univariate extended random-effects meta-regression
#> Dimension: 1
#> Estimation method: REML
#> 
#> Fixed-effects coefficients
#>              Estimate  Std. Error        z  Pr(>|z|)   95%ci.lb  95%ci.ub   
#> (Intercept)  -68.5797    132.4090  -0.5179    0.6045  -328.0966  190.9372   
#> yr             0.0344      0.0656   0.5243    0.6001    -0.0942    0.1630   
#> ---
#> Signif. codes:  0 ‘***’ 0.001 ‘**’ 0.01 ‘*’ 0.05 ‘.’ 0.1 ‘ ’ 1 
#> 
#> Random-effects (co)variance components
#>  Formula: ~1 | yr
#>  Structure: General positive-definite
#>   Std. Dev
#>     0.1201
#> 
#> Univariate Cochran Q-test for residual heterogeneity:
#> Q = 6.8132 (df = 2), p-value = 0.0332
#> I-square statistic = 70.6%
#> 
#> 4 units, 1 outcome, 4 observations, 2 fixed and 1 random-effects parameters
#>  logLik      AIC      BIC  
#>  1.0657   3.8687  -0.0519  
#> 
#> 
#> $coeffs
#> # A tibble: 1 × 8
#>   slope.approx  slope slope.se     z     p likelihood   ci.lb ci.ub
#>          <dbl>  <dbl>    <dbl> <dbl> <dbl>      <dbl>   <dbl> <dbl>
#> 1        0.631 0.0344   0.0656 0.524 0.600      0.700 -0.0942 0.163
#> 
```
