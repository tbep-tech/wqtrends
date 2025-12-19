# Format p-values for show functions

Format p-values for show functions

## Usage

``` r
anlz_pvalformat(x)
```

## Arguments

- x:

  numeric input p-value

## Value

p-value formatted as a text string, one of `p < 0.001`, `'p < 0.01'`,
`p < 0.05`, or `ns` for not significant

## Examples

``` r
anlz_pvalformat(0.05)
#> [1] "ns"
```
