#' Plot predictions for GAMs against day of year
#'
#' Plot predictions for GAMs against day of year
#' 
#' @param mod input model object as returned by \code{\link{anlz_gam}}
#' @param ylab chr string for y-axis label
#' @param yromit optional numeric vector for years to omit from the plot, see details
#' @param size numeric indicating line size
#' @param alpha numeric from 0 to 1 indicating line transparency
#' @param base_size numeric indicating base font size, passed to \code{\link[ggplot2]{theme_bw}}
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
#' show_prddoy(mod, ylab = 'Chlorophyll-a (ug/L)')
show_prddoy <- function(mod, ylab, yromit = NULL, size = 0.5, alpha = 1, base_size = 11){

  # get predictions
  prds <- anlz_prd(mod)

  if(!is.null(yromit))
    prds <- prds[!prds$yr %in% yromit, ]
  
  # get transformation
  trans <- unique(prds$trans)
  
  p <- ggplot2::ggplot(prds, ggplot2::aes(x = doy, group = factor(yr), colour = yr)) + 
    ggplot2::geom_line(ggplot2::aes(y = value), size = size, alpha = alpha) + 
    ggplot2::theme_bw(base_size = base_size) + 
    ggplot2::theme(
      legend.position = 'top', 
      legend.title = ggplot2::element_blank()
    ) + 
    ggplot2::scale_color_viridis_c() + 
    ggplot2::guides(colour = ggplot2::guide_colourbar(barheight = 1, barwidth = 20)) +
    ggplot2::labs(
      x = "Day of year",
      y = ylab
    )
  
  if(trans != 'ident')
    p <- p + ggplot2::scale_y_log10()
  
  return(p)
  
}
