# Estimate percent change trends from GAM results for selected time periods

Estimate percent change trends from GAM results for selected time
periods

## Usage

``` r
anlz_perchg(mod, baseyr, testyr)
```

## Arguments

- mod:

  input model object as returned by
  [`anlz_gam`](https://tbep-tech.github.io/wqtrends/reference/anlz_gam.md)

- baseyr:

  numeric vector of starting years

- testyr:

  numeric vector of ending years

## Value

A data frame of summary results for change between the years.

## Details

Working components of this function were taken from the gamDiff function
in the baytrends package.

## Examples

``` r
library(dplyr)

# data to model
tomod <- rawdat %>%
  filter(station %in% 34) %>%
  filter(param %in% 'chl')
  
mod <- anlz_gam(tomod, trans = 'log10')
anlz_perchg(mod, baseyr = 1990, testyr = 2016)
#> # A tibble: 1 × 4
#>   baseval testval perchg  pval
#>     <dbl>   <dbl>  <dbl> <dbl>
#> 1    22.8    5.81  -74.5 0.675
```
