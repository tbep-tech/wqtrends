# Extract period (seasonal) averages from fitted GAM

Extract period (seasonal) averages from fitted GAM

## Usage

``` r
anlz_avgseason(mod, doystr = 1, doyend = 364, yromit = NULL)
```

## Arguments

- mod:

  input model object as returned by
  [`anlz_gam`](https://tbep-tech.github.io/wqtrends/reference/anlz_gam.md)

- doystr:

  numeric indicating start Julian day for extracting averages

- doyend:

  numeric indicating ending Julian day for extracting averages

- yromit:

  optional numeric vector for years to omit from the output

## Value

A data frame of period averages

## Examples

``` r
library(dplyr)
#> 
#> Attaching package: ‘dplyr’
#> The following objects are masked from ‘package:stats’:
#> 
#>     filter, lag
#> The following objects are masked from ‘package:base’:
#> 
#>     intersect, setdiff, setequal, union

# data to model
tomod <- rawdat %>%
  filter(station %in% 34) %>%
  filter(param %in% 'chl') %>% 
  filter(yr > 2015)

mod <- anlz_gam(tomod, trans = 'log10')
anlz_avgseason(mod, doystr = 90, doyend = 180)
#> # A tibble: 4 × 7
#>      yr   met     se bt_lwr bt_upr bt_met dispersion
#>   <dbl> <dbl>  <dbl>  <dbl>  <dbl>  <dbl>      <dbl>
#> 1  2016 0.766 0.0839   4.57   9.73   6.67     0.0504
#> 2  2017 0.772 0.0792   4.73   9.68   6.77     0.0504
#> 3  2018 1.03  0.0733   8.75  17.0   12.2      0.0504
#> 4  2019 0.808 0.0719   5.31  10.2    7.34     0.0504
```
