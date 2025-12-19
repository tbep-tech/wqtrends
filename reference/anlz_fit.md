# Return summary statistics for GAM fits

Return summary statistics for GAM fits

## Usage

``` r
anlz_fit(mod)
```

## Arguments

- mod:

  input model object as returned by
  [`anlz_gam`](https://tbep-tech.github.io/wqtrends/reference/anlz_gam.md)

## Value

A `data.frame` with summary statistics for GAM fits

## Details

Results show the overall summary of the model as Akaike Information
Criterion (`AIC`), the generalized cross-validation score (`GCV`), and
the `R2` values. Lower values for `AIC` and `GCV` and higher values for
`R2` indicate improved model fit.

## Examples

``` r
library(dplyr)

# data to model
tomod <- rawdat %>%
  filter(station %in% 34) %>%
  filter(param %in% 'chl')
  
mod <-  anlz_gam(tomod, trans = 'log10')
anlz_fit(mod)
#>             AIC        GCV        R2
#> GCV.Cp -3.16689 0.07280572 0.6842621
```
