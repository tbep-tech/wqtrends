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
#' 
#' @return A \code{\link[ggplot2]{ggplot}} object
#' @export
#' 
#' @details
#' The optional \code{yromit} vector can be used to omit years from the plot. This may be preferred if the predicted values from the model deviate substantially from other years likely due to missing data.
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
show_prdseries <- function(mod, ylab, yromit = NULL, alpha = 0.7, base_size = 11, xlim = NULL, ylim = NULL, col = 'brown'){

  # get predictions
  prds <- anlz_prd(mod)
  
  if(!is.null(yromit))
    prds <- prds[!prds$yr %in% yromit, ]
  
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
    ggplot2::geom_line(ggplot2::aes(y = value), size = 0.75, alpha = alpha, colour = col) + 
    # ggplot2::geom_line(ggplot2::aes(y = annvalue), alpha = alpha, colour = 'tomato1') +
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
