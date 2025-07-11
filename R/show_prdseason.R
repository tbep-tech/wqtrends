#' Plot predictions for GAMs over time, by season
#'
#' Plot predictions for GAMs over time, by season
#' 
#' @inheritParams show_prdseries
#' 
#' @return A \code{\link[ggplot2]{ggplot}} object
#' @export
#' 
#' @concept show
#' 
#' @examples
#' library(dplyr)
#' 
#' # data to model
#' tomod <- rawdat %>%
#'   filter(station %in% 34) %>%
#'   filter(param %in% 'chl') %>% 
#'   filter(yr > 2015)
#'   
#' mod <- anlz_gam(tomod, trans = 'log10')
#' show_prdseason(mod, ylab = 'Chlorophyll-a (ug/L)')
show_prdseason <- function(mod, ylab, yromit = NULL, base_size = 11, xlim = NULL, ylim = NULL){
  
  # get daily predictions, differs from anlz_prd
  prds <- anlz_prdday(mod)
  
  if(!is.null(yromit))
    prds <- prds[!prds$yr %in% yromit, ]
  
  # get transformation
  trans <- unique(prds$trans)
  
  # get raw data from model if not provided
  tobacktrans <- mod$model %>% 
    dplyr::mutate(
      trans = mod$trans
    )
  
  moddat <- anlz_backtrans(tobacktrans) %>% 
    dplyr::mutate(
      date = lubridate::date_decimal(cont_year), 
      date = as.Date(date)
    )
  
  toplo <- prds %>% 
    dplyr::mutate(day = lubridate::day(date)) %>% 
    dplyr::filter(day %in% c(1)) %>%
    dplyr::mutate(month = lubridate::month(date, label = T))
  
  # plot
  p <- ggplot2::ggplot(toplo, ggplot2::aes(x = date)) + 
    ggplot2::geom_point(data = moddat, ggplot2::aes(y = value), size = 0.5) +
    ggplot2::geom_line(ggplot2::aes(y = value, group = month, colour = month), size = 1, alpha = 0.7) + 
    ggplot2::theme_bw(base_size = base_size) +
    ggplot2::theme(
      legend.position = 'top', 
      axis.title.x = ggplot2::element_blank(), 
      legend.title = ggplot2::element_blank()
    ) +
    ggplot2::guides(col = ggplot2::guide_legend(nrow = 2)) +
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
