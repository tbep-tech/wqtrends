# Plot rates of change based on seasonal metrics

Plot rates of change based on seasonal metrics

## Usage

``` r
show_trndseason(
  mod,
  metfun = mean,
  doystr = 1,
  doyend = 364,
  type = c("log10", "approx"),
  justify = c("left", "right", "center"),
  win = 5,
  ylab,
  nsim = 10000,
  yromit = NULL,
  useave = FALSE,
  base_size = 11,
  nms = NULL,
  fils = NULL,
  cols = NULL,
  xlim = NULL,
  ylim = NULL,
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

- type:

  chr string indicating if log slopes are shown (if applicable)

- justify:

  chr string indicating the justification for the trend window

- win:

  numeric indicating number of years to use for the trend window, see
  details

- ylab:

  chr string for y-axis label

- nsim:

  numeric indicating number of random draws for simulating uncertainty

- yromit:

  optional numeric vector for years to omit from the output

- useave:

  logical indicating if `anlz_avgseason` is used for the seasonal metric
  calculation, see details

- base_size:

  numeric indicating base font size, passed to
  [`theme_bw`](https://ggplot2.tidyverse.org/reference/ggtheme.html)

- nms:

  optional character vector for trend names

- fils:

  optional character vector for the fill of interior point colors

- cols:

  optional character vector for confidence interval colors

- xlim:

  optional numeric vector of length two for x-axis limits

- ylim:

  optional numeric vector of length two for y-axis limits

- ...:

  additional arguments passed to `metfun`, e.g., `na.rm = TRUE`

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
show_trndseason(mod, doystr = 90, doyend = 180, justify = 'left', win = 4,
     ylab = 'Slope Chlorophyll-a (ug/L/yr)')
```
