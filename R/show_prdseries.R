#' Plot predictions for GAMs over time series
#'
#' Plot predictions for GAMs over time series
#' 
#' @param moddat input raw data, one station and parameter
#' @param mods optional list of model objects
#' @param ylab chr string for y-axis label
#' @param nfac numeric indicating column number for facets, passed to \code{ncol} argument of \code{\link[ggplot2]{facet_wrap}}, defaults to one
#' @param ... additional arguments passed to other methods
#' 
#' @return A \code{\link[ggplot2]{ggplot}} object
#' @export
#' 
#' @family show
#' 
#' @examples
#' library(dplyr)
#' 
#' # get predictions for all four gams
#' tomod <- rawdat %>%
#'   filter(station %in% 32) %>%
#'   filter(param %in% 'chl')
#' \dontrun{
#' show_prdseries(moddat = tomod, ylab = 'Chlorophyll-a (ug/L)', trans = 'boxcox')
#' }
#' # use previously fitted list of models
#' trans <- 'boxcox'
#' mods <- list(
#'   gam0 = anlz_gam(tomod, mod = 'gam0', trans = trans),
#'   gam1 = anlz_gam(tomod, mod = 'gam1', trans = trans),
#'   gam2 = anlz_gam(tomod, mod = 'gam2', trans = trans)
#' )
#' 
#' show_prdseries(moddat = tomod, mods = mods, ylab = 'Chlorophyll-a (ug/L)')
show_prdseries <- function(moddat, mods = NULL, ylab, nfac = NULL, ...){
  
  if(is.null(nfac))
    nfac <- 1
  
  # get predictions
  prds <- anlz_prd(moddat = moddat, mods = mods, ...)
  
  # back-transform
  prds <- anlz_backtrans(prds)
  
  p <- ggplot2::ggplot(prds, ggplot2::aes(x = date)) + 
    ggplot2::geom_point(data = moddat, ggplot2::aes(y = value), size = 0.5) +
    ggplot2::geom_line(ggplot2::aes(y = value, colour = factor(model)), size = 0.75, alpha = 0.8) + 
    ggplot2::stat_smooth(ggplot2::aes(y = value, group = model), se = F, method = "loess", color = 'black', alpha = 0.7, formula = y ~x) +
    ggplot2::facet_wrap(~model, ncol = nfac) +
    ggplot2::scale_color_viridis_d() + 
    ggplot2::theme_bw(base_family = 'serif', base_size = 16) + 
    ggplot2::theme(
      legend.position = 'top', 
      legend.title = ggplot2::element_blank(),
      strip.text = ggplot2::element_blank(), 
      strip.background = ggplot2::element_blank(), 
      axis.title.x = ggplot2::element_blank()
    ) + 
    ggplot2::scale_y_log10(ylab)
  
  return(p)
  
}