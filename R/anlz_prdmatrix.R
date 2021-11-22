#' Get prediction matrix for a fitted GAM
#'
#' Get prediction matrix for a fitted GAM
#' 
#' @param mod input model object as returned by \code{\link{anlz_gam}}
#' @param doystr numeric indicating start Julian day for extracting averages
#' @param doyend numeric indicating ending Julian day for extracting averages
#' @param avemat logical indicating if the prediction matrix is to be passed to \code{anlz_metseason} (default) or \code{anlz_avgseason} 
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
anlz_prdmatrix <- function(mod, doystr = 1, doyend = 364, avemat = FALSE){

  # create uniform matrix if metric is average
  if(avemat){
    
    # date range
    dtrng <- range(mod$model$cont_year, na.rm = T) %>% 
      lubridate::date_decimal() %>% 
      as.Date
    
    # number of days in season subset
    numDays <- doyend - doystr + 1
    
    # prediction data, daily time step, subset by doystr, doyend
    out <- data.frame(date = seq.Date(dtrng[1], dtrng[2], by = 'day')) %>% 
      dplyr::mutate(
        yr = lubridate::year(date), 
        doy = lubridate::yday(date),
        cont_year = lubridate::decimal_date(date)
      ) %>% 
      dplyr::filter(doy >= doystr & doy <= doyend) %>% 
      dplyr::group_by(yr) %>% 
      dplyr::mutate(
        dayCounts = dplyr::n()
      ) %>% 
      dplyr::ungroup() %>% 
      dplyr::filter(dayCounts == numDays) %>% 
      dplyr::select(-dayCounts)
    
  }
  
  # create exact matrix if not average
  if(!avemat){
    
    # date range
    dtrng <- range(mod$model$cont_year, na.rm = T) %>% 
      lubridate::date_decimal() %>% 
      as.Date %>% 
      lubridate::year(.) 
    dtrng <- c(as.Date(doystr, origin = paste0(dtrng[1], '-01-01')), as.Date(doyend, origin = paste0(dtrng[2], '-01-01')))
    
    # prediction data, daily time step, subset by doystr, doyend
    out <- data.frame(date = seq.Date(dtrng[1], dtrng[2], by = 'day')) %>% 
      dplyr::mutate(
        yr = lubridate::year(date), 
        doy = lubridate::yday(date),
        cont_year = lubridate::decimal_date(date)
      ) %>% 
      dplyr::filter(doy >= doystr & doy <= doyend)
    
  }
  
  return(out)

}
