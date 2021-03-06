% Generated by roxygen2: do not edit by hand
% Please edit documentation in R/show_prddoy.R
\name{show_prddoy}
\alias{show_prddoy}
\title{Plot predictions for GAMs against day of year}
\usage{
show_prddoy(mod, ylab, size = 0.5, alpha = 1)
}
\arguments{
\item{mod}{input model object as returned by \code{\link{anlz_gam}}}

\item{ylab}{chr string for y-axis label}

\item{size}{numeric indicating line size}

\item{alpha}{numeric from 0 to 1 indicating line transparency}
}
\value{
A \code{\link[ggplot2]{ggplot}} object
}
\description{
Plot predictions for GAMs against day of year
}
\examples{
library(dplyr)

# data to model
tomod <- rawdat \%>\%
  filter(station \%in\% 34) \%>\%
  filter(param \%in\% 'chl')

mod <- anlz_gam(tomod, trans = 'log10')

show_prddoy(mod, ylab = 'Chlorophyll-a (ug/L)')
}
\concept{show}
