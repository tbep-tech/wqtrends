# Plot predictions for GAMs against day of year

Plot predictions for GAMs against day of year

## Usage

``` r
show_prddoy(
  mod,
  ylab,
  yromit = NULL,
  linewidth = 0.5,
  alpha = 1,
  base_size = 11
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

- linewidth:

  numeric indicating line width

- alpha:

  numeric from 0 to 1 indicating line transparency

- base_size:

  numeric indicating base font size, passed to
  [`theme_bw`](https://ggplot2.tidyverse.org/reference/ggtheme.html)

## Value

A [`ggplot`](https://ggplot2.tidyverse.org/reference/ggplot.html) object

## Details

The optional `yromit` vector can be used to omit years from the plot.
This may be preferred if the predicted values from the model deviate
substantially from other years likely due to missing data.

## Examples

``` r
library(dplyr)

# data to model
tomod <- rawdat %>%
  filter(station %in% 34) %>%
  filter(param %in% 'chl')

mod <- anlz_gam(tomod, trans = 'log10')

show_prddoy(mod, ylab = 'Chlorophyll-a (ug/L)')
```
