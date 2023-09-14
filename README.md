
# wqtrends

[![R-CMD-check](https://github.com/tbep-tech/wqtrends/workflows/R-CMD-check/badge.svg)](https://github.com/tbep-tech/wqtrends/actions)
[![pkgdown](https://github.com/tbep-tech/wqtrends/workflows/pkgdown/badge.svg)](https://github.com/tbep-tech/wqtrends/actions)
[![Codecov test coverage](https://codecov.io/gh/tbep-tech/wqtrends/branch/master/graph/badge.svg)](https://app.codecov.io/gh/tbep-tech/wqtrends?branch=master)
[![CRAN status](https://www.r-pkg.org/badges/version/wqtrends)](https://CRAN.R-project.org/package=wqtrends)
[![](https://cranlogs.r-pkg.org/badges/grand-total/wqtrends)](https://cran.r-project.org/package=wqtrends)
[![DOI](https://zenodo.org/badge/239808241.svg)](https://zenodo.org/badge/latestdoi/239808241)

R package to assess water quality trends for long-term monitoring data in estuaries using Generalized Additive Models with error propagation from mixed-effect meta-analysis. Uses concepts in the [mgcv](https://CRAN.R-project.org/package=mgcv) and [mixmeta](https://CRAN.R-project.org/package=mixmeta) packages. Detailed information on the methods used in this package are described in the following open access article:

*Beck, M.W., de Valpine, P., Murphy, R., Wren, I., Chelsky, A., Foley, M., Senn, D.B. 2022. Multi-scale trend analysis of water quality using error propagation of Generalized Additive Models. Science of the Total Environment. 802:149927. [https://doi.org/10.1016/j.scitotenv.2021.149927](https://doi.org/10.1016/j.scitotenv.2021.149927)*

## Installation

The development version of the package can be installed from [r-universe](http://tbep-tech.r-universe.dev/ui/#builds).  The source code is available on [GitHub](https://github.com/tbep-tech/wqtrends).

```r
# Install wqtrends in R:
install.packages('wqtrends', repos = c('https://tbep-tech.r-universe.dev', 'https://cloud.r-project.org'))

# load wqtrends
library(wqtrends)
```

# Issues and suggestions

Please report any issues and suggestions on the [issues link](https://github.com/tbep-tech/wqtrends/issues) for the repository.

