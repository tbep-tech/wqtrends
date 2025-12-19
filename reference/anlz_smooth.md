# Return summary statistics for smoothers of GAMs

Return summary statistics for smoothers of GAMs

## Usage

``` r
anlz_smooth(mod)
```

## Arguments

- mod:

  input model object as returned by
  [`anlz_gam`](https://tbep-tech.github.io/wqtrends/reference/anlz_gam.md)

## Value

a `data.frame` with summary statistics for smoothers in each GAM

## Details

Results show the individual effects of the modelled components of each
model as the estimated degrees of freedom (`edf`), the reference degrees
of freedom (`Ref.df`), the test statistic (`F`), and significance of the
component (`p-value`). The significance of the component is in part
based on the difference between `edf` and `Ref.df`.

## Examples

``` r
library(dplyr)

# data to model
tomod <- rawdat %>%
  filter(station %in% 34) %>%
  filter(param %in% 'chl')
  
mod <- anlz_gam(tomod, trans = 'log10')
anlz_smooth(mod)
#>       smoother      edf   Ref.df        F p.value
#> 1 s(cont_year) 218.9304 262.4483 4.788546       0
```
