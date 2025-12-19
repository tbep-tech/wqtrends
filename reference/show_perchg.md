# Plot percent change trends from GAM results for selected time periods

Plot percent change trends from GAM results for selected time periods

## Usage

``` r
show_perchg(
  mod,
  baseyr,
  testyr,
  ylab,
  base_size = 11,
  xlim = NULL,
  ylim = NULL
)
```

## Arguments

- mod:

  input model object as returned by
  [`anlz_gam`](https://tbep-tech.github.io/wqtrends/reference/anlz_gam.md)

- baseyr:

  numeric vector of starting years

- testyr:

  numeric vector of ending years

- ylab:

  chr string for y-axis label

- base_size:

  numeric indicating base font size, passed to
  [`theme_bw`](https://ggplot2.tidyverse.org/reference/ggtheme.html)

- xlim:

  optional numeric vector of length two for x-axis limits

- ylim:

  optional numeric vector of length two for y-axis limits

## Value

A [`ggplot`](https://ggplot2.tidyverse.org/reference/ggplot.html) object

## Examples

``` r
library(dplyr)

# data to model
tomod <- rawdat %>%
  filter(station %in% 34) %>%
  filter(param %in% 'chl')
  
mod <- anlz_gam(tomod, trans = 'log10')

show_perchg(mod, baseyr = 1995, testyr = 2016, ylab = 'Chlorophyll-a (ug/L)')
#> Warning: log-10 transformation introduced infinite values.
```
