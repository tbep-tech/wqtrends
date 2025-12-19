# Back-transform response variable

Back-transform response variable after fitting GAM

## Usage

``` r
anlz_backtrans(dat)
```

## Arguments

- dat:

  input data with `trans` argument

## Value

`dat` with the `value` column back-transformed using info from the
`trans` column

## Details

`dat` can be output from
[`anlz_trans`](https://tbep-tech.github.io/wqtrends/reference/anlz_trans.md)
or
[`anlz_prd`](https://tbep-tech.github.io/wqtrends/reference/anlz_prd.md)

## Examples

``` r
library(dplyr)

tomod <- rawdat %>% 
  filter(station %in% 34) %>% 
  filter(param %in% 'chl')
dat <- anlz_trans(tomod, trans = 'log10')
backtrans <- anlz_backtrans(dat)
head(backtrans)
#>         date station param     value doy cont_year   yr  mo trans
#> 1 1991-02-12      34   chl  2.766667  43  1991.115 1991 Feb log10
#> 2 1992-02-27      34   chl  3.066667  58  1992.156 1992 Feb log10
#> 3 1992-03-12      34   chl  2.466667  72  1992.194 1992 Mar log10
#> 4 1992-03-23      34   chl  4.166667  83  1992.224 1992 Mar log10
#> 5 1992-04-01      34   chl  5.766667  92  1992.249 1992 Apr log10
#> 6 1992-04-08      34   chl 12.133333  99  1992.268 1992 Apr log10

mod <- anlz_gam(tomod, trans = 'log10')
dat <- anlz_prd(mod)
backtrans <- anlz_backtrans(dat)
head(backtrans)
#>   cont_year       date  mo doy   yr     value trans
#> 1  1991.115 1991-02-11 Feb  42 1991 580.94423 log10
#> 2  1991.144 1991-02-22 Feb  53 1991 330.32238 log10
#> 3  1991.173 1991-03-05 Mar  64 1991 197.91116 log10
#> 4  1991.202 1991-03-15 Mar  74 1991 124.57629 log10
#> 5  1991.231 1991-03-26 Mar  85 1991  82.11919 log10
#> 6  1991.259 1991-04-05 Apr  95 1991  56.50284 log10
```
