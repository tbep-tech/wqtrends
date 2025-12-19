#' Plot predictions for GAMs over time series
#'
#' Plot predictions for GAMs over time series
#' 
#' @param mod input model object as returned by \code{\link{anlz_gam}}
#' @param ylab chr string for y-axis label
#' @param yromit optional numeric vector for years to omit from the plot, see details
#' @param alpha numeric from 0 to 1 indicating line transparency
#' @param base_size numeric indicating base font size, passed to \code{\link[ggplot2]{theme_bw}}
#' @param xlim optional numeric vector of length two for x-axis limits
#' @param ylim optional numeric vector of length two for y-axis limits
#' @param col optional chr string for line color
#' @param minomit numeric indicating number of observations in the observed data to exclude it in the predicted series for a given year if provided to \code{yromit}
#' 
#' @return A \code{\link[ggplot2]{ggplot}} object
#' @export
#' 
#' @details
#' The optional \code{yromit} vector can be used to omit years from the plot. This may be preferred if the predicted values from the model deviate substantially from other years likely due to missing data.
#' 
#' The \code{yromit} argument behaves differently for this function compared to others because of a mismatch in the timestep for the predicted time series and the observed data. The function will attempt to find "bookends" in the observed data that match with the predicted time series for each year in \code{yromit}.  For example, if there is a gap in the observed data that spans multiple years and a single year value is included with \code{yromit} that is within the gap, the predicted time series will not be shown for the entire gap in the observed data even if additional years within the gap were not provided to \code{yromit}.
#'  
#' Entire years where observed data are present can also be removed from the predicted time series if they exceed a minimum number of observations defined by \code{minomit}. For example, if a year has at least 8 observations and \code{yromit} includes that year, the predicted time series for that entire year will be removed.
#' 
#' @concept show
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
#' 
#' show_prdseries(mod, ylab = 'Chlorophyll-a (ug/L)')
show_prdseries <- function(mod, ylab, yromit = NULL, alpha = 0.7, base_size = 11, xlim = NULL, ylim = NULL, col = 'brown', minomit = 8){

  # get predictions
  prds <- anlz_prd(mod)

  if(!is.null(yromit)){

    # date range from model data that include yromit
    moddat <- mod$model %>%
      dplyr::filter(!is.na(value)) %>% 
      dplyr::mutate(
        date = as.Date(lubridate::date_decimal(cont_year)),
        yr = lubridate::year(date)
      )
    
    for(yr in yromit){
      # omit the full year if there is "lots" of data
      if(length(moddat[moddat$yr == yr, 'value']) >= minomit){
        prds[prds$yr == yr, 'value'] <- NA_real_
      
      # otherwise, find bookends
      } else {

        # if year completely missing
        if(!yr %in% moddat$yr){

          if(yr > max(moddat$yr) | yr < min(moddat$yr))
            next()
          
          strdt <- moddat %>% 
            dplyr::filter(yr < !!yr) %>% 
            dplyr::pull(date) %>% 
            max()
          enddt <- moddat %>% 
            dplyr::filter(yr > !!yr) %>% 
            dplyr::pull(date) %>% 
            min()

        # if year is included, find the gap
        } else {
          
          yr <- yr + 0.5 # start in the middle
          strdt <- moddat %>% 
            dplyr::filter(cont_year < !!yr) %>% 
            dplyr::pull(date) %>% 
            max()
          enddt <- moddat %>% 
            dplyr::filter(cont_year > !!yr) %>% 
            dplyr::pull(date) %>% 
            min()

        }

        prds <- prds %>% 
            dplyr::mutate(
              value = dplyr::case_when(
                date >= strdt & date <= enddt ~ NA_real_, 
                TRUE ~ value
              )
            )
        
      }
    }
    
  }
  
  # get transformation
  trans <- unique(prds$trans)

  # raw data
  tobacktrans <- mod$model %>% 
    dplyr::mutate(
      trans = mod$trans
    )
  
  moddat <- anlz_backtrans(tobacktrans) %>% 
    dplyr::mutate(
      date = lubridate::date_decimal(cont_year), 
      date = as.Date(date)
    )

  p <- ggplot2::ggplot(prds, ggplot2::aes(x = date)) + 
    ggplot2::geom_point(data = moddat, ggplot2::aes(y = value), size = 0.5) +
    ggplot2::geom_path(ggplot2::aes(y = value), size = 0.75, alpha = alpha, colour = col) + 
    ggplot2::theme_bw(base_size = base_size) + 
    ggplot2::theme(
      legend.position = 'top', 
      legend.title = ggplot2::element_blank(),
      axis.title.x = ggplot2::element_blank()
    ) + 
    ggplot2::labs(
      y = ylab
    ) + 
    ggplot2::coord_cartesian(
      xlim = xlim, 
      ylim = ylim
    )
  
  if(trans != 'ident')
    p <- p + ggplot2::scale_y_log10()
  
  return(p)
  
}
