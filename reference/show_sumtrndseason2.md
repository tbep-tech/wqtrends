# Plot seasonal rates of change in quarters based on average estimates for multiple window widths

Plot seasonal rates of change in quarters based on average estimates for
multiple window widths

## Usage

``` r
show_sumtrndseason2(
  mod,
  yromit = NULL,
  justify = c("center", "left", "right"),
  win = 5:15,
  txtsz = 6,
  cols = c("lightblue", "lightgreen"),
  base_size = 11
)
```

## Arguments

- mod:

  input model object as returned by
  [`anlz_gam`](https://tbep-tech.github.io/wqtrends/reference/anlz_gam.md)

- yromit:

  optional numeric vector for years to omit from the plot, see details

- justify:

  chr string indicating the justification for the trend window

- win:

  numeric vector indicating number of years to use for the trend window

- txtsz:

  numeric for size of text labels inside the plot

- cols:

  vector of low/high colors for trends

- base_size:

  numeric indicating base font size, passed to
  [`theme_bw`](https://ggplot2.tidyverse.org/reference/ggtheme.html)

## Value

A
[`ggplot2`](https://ggplot2.tidyverse.org/reference/ggplot2-package.html)
plot

## Details

This function is similar to
[`show_sumtrndseason`](https://tbep-tech.github.io/wqtrends/reference/show_sumtrndseason.md)
but results are grouped into seasonal quarters as four separate plots
with a combined color scale.

The optional `yromit` vector can be used to omit years from the plot and
trend assessment. This may be preferred if seasonal estimates for a
given year have very wide confidence intervals likely due to limited
data, which can skew the trend assessments.

## See also

Other show:
[`show_sumtrndseason()`](https://tbep-tech.github.io/wqtrends/reference/show_sumtrndseason.md)

## Examples

``` r
library(dplyr)

# data to model
tomod <- rawdat %>%
  filter(station %in% 34) %>%
  filter(param %in% 'chl') %>% 
  filter(yr > 2015)

mod <- anlz_gam(tomod, trans = 'log10')
show_sumtrndseason2(mod, justify = 'center', win = 2:3)
```
