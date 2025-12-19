# Fit a mixed meta-analysis regression model of trends

Fit a mixed meta-analysis regression model of trends

## Usage

``` r
anlz_mixmeta(metseason, yrstr = 2000, yrend = 2019)
```

## Arguments

- metseason:

  output from
  [`anlz_metseason`](https://tbep-tech.github.io/wqtrends/reference/anlz_metseason.md)

- yrstr:

  numeric for starting year

- yrend:

  numeric for ending year

## Value

A list of [`mixmeta`](https://rdrr.io/pkg/mixmeta/man/mixmeta.html)
fitted model objects

## Details

Parameters are not back-transformed if the original GAM used a
transformation of the response variable

## Examples

``` r
library(dplyr)

# data to model
tomod <- rawdat %>%
  filter(station %in% 34) %>%
  filter(param %in% 'chl') %>% 
  filter(yr > 2015)

mod <- anlz_gam(tomod, trans = 'log10')
metseason <- anlz_metseason(mod, doystr = 90, doyend = 180)
anlz_mixmeta(metseason, yrstr = 2016, yrend = 2019)
#> Call:  mixmeta::mixmeta(formula = met ~ yr, S = S, data = totrnd, random = ~1 | 
#>     yr, method = "reml")
#> 
#> Fixed-effects coefficients:
#> (Intercept)           yr  
#>    -73.8398       0.0370  
#> 
#> 4 units, 1 outcome, 4 observations, 2 fixed and 1 random-effects parameters
#>  logLik      AIC      BIC  
#>  1.0756   3.8488  -0.0718  
#> 
```
