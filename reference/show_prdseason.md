# Plot predictions for GAMs over time, by season

Plot predictions for GAMs over time, by season

## Usage

``` r
show_prdseason(
  mod,
  ylab,
  yromit = NULL,
  base_size = 11,
  xlim = NULL,
  ylim = NULL
)
```

## Arguments

- mod:

  input model object as returned by
  [`anlz_gam`](https://tbep-tech.github.io/wqtrends/reference/anlz_gam.md)

- ylab:

  chr string for y-axis label

- yromit:

  optional numeric vector for years to omit from the plot, see details

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
  filter(param %in% 'chl') %>% 
  filter(yr > 2015)
  
mod <- anlz_gam(tomod, trans = 'log10')
show_prdseason(mod, ylab = 'Chlorophyll-a (ug/L)')
```
