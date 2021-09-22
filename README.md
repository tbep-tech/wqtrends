
# wqtrends

[![R-CMD-check](https://github.com/tbep-tech/wqtrends/workflows/R-CMD-check/badge.svg)](https://github.com/tbep-tech/wqtrends/actions)
[![pkgdown](https://github.com/tbep-tech/wqtrends/workflows/pkgdown/badge.svg)](https://github.com/tbep-tech/wqtrends/actions)
[![Codecov test coverage](https://codecov.io/gh/tbep-tech/wqtrends/branch/master/graph/badge.svg)](https://codecov.io/gh/tbep-tech/wqtrends?branch=master)
[![DOI](https://zenodo.org/badge/239808241.svg)](https://zenodo.org/badge/latestdoi/239808241)

R package to assess water quality trends for long-term monitoring data in estuaries using Generalized Additive Models with error propagation from mixed-effect meta-analysis. Uses concepts in the [mgcv](https://cran.r-project.org/web/packages/mgcv/index.html) and [mixmeta](https://cran.r-project.org/web/packages/mixmeta/index.html) packages. Detailed information on the methods used in this package are described in the following open access article:

*Beck, M.W., de Valpine, P., Murphy, R., Wren, I., Chelsky, A., Foley, M., Senn, D.B. 2022. Multi-scale trend analysis of water quality using error propagation of Generalized Additive Models. Science of the Total Environment. 802:149927. [https://doi.org/10.1016/j.scitotenv.2021.149927](https://doi.org/10.1016/j.scitotenv.2021.149927)*

## Installation

The package can be installed from [r-universe](https://tbep-tech.r-universe.dev/ui#builds).  The source code is available on [GitHub](https://github.com/tbep-tech/wqtrends).

```r
# enable repos
options(repos = c(
    tbeptech = 'https://tbep-tech.r-universe.dev',
    CRAN = 'https://cloud.r-project.org'))

# install wqtrends
install.packages('wqtrends')

# load wqtrends
library(wqtrends)
```

# Issues and suggestions

Please report any issues and suggestions on the [issues link](https://github.com/tbep-tech/wqtrends/issues) for the repository. A guide to posting issues can be found [here](.github/ISSUE_TEMPLATE.md).

# Contributing

Please view our [contributing](.github/CONTRIBUTING.md) guidelines for any changes or pull requests.

