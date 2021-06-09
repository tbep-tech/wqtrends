#' Get prediction matrix for a fitted GAM
#'
#' Get prediction matrix for a fitted GAM
#' 
#' @param mod input model object as returned by \code{\link{anlz_gam}}
#' @param doystr numeric indicating start Julian day for extracting averages
#' @param doyend numeric indicating ending Julian day for extracting averages
#'
#' @return a \code{data.frame} with predictors to use with the fitted GAM
#' @export
#' 
#' @details Used internally by \code{\link{anlz_metseason}}, not to be used by itself
#' 
#' @concept analyze
#'
#' @examples
#' library(dplyr)
#' 
#' # data to model
#' tomod <- rawdat %>%
#'   filter(station %in% 34) %>%
#'   filter(param %in% 'chl')
#'
#' mod <- anlz_gam(tomod, trans = 'log10')
#' anlz_prdmatrix(mod, doystr = 90, doyend = 180)
anlz_prdmatrix <- function(mod, doystr = 1, doyend = 364){

  # date range
  dtrng <- range(mod$model$cont_year, na.rm = T) %>% 
    lubridate::date_decimal() %>% 
    as.Date %>% 
    lubridate::year(.) 
  dtrng <- c(as.Date(doystr, origin = paste0(dtrng[1], '-01-01')), as.Date(doyend, origin = paste0(dtrng[2], '-01-01')))
  
  # prediction data, daily time step, subset by doystr, doyend
  fillData <- data.frame(date = seq.Date(dtrng[1], dtrng[2], by = 'day')) %>% 
    dplyr::mutate(
      yr = lubridate::year(date), 
      doy = lubridate::yday(date),
      cont_year = lubridate::decimal_date(date)
    ) %>% 
    dplyr::filter(doy >= doystr & doy <= doyend)
  
  out <- fillData
  
  return(out)

}
