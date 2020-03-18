#' Plot predictions for GAMs against day of year
#'
#' Plot predictions for GAMs against day of year
#' 
#' @param predin data frame input to plot, output from \code{\link{anlz_pred}}
#' @param ylab chr string for y-axis label
#' @param nfac numeric indicating column number for facets, passed to \code{ncol} argument of \code{\link[ggplot2]{facet_wrap}}, defaults to number of model outputs in \code{predin}
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
#' prds <- anlz_pred(tomod, trans = 'boxcox')
#' show_prddoy(prds, ylab = 'Chlorophyll-a (ug/L)')
#' }
#' # use previously fitted list of models
#' trans <- 'boxcox'
#' mods <- list(
#'   gam0 = anlz_gam(tomod, mod = 'gam0', trans = trans),
#'   gam1 = anlz_gam(tomod, mod = 'gam1', trans = trans),
#'   gam2 = anlz_gam(tomod, mod = 'gam2', trans = trans)
#' )
#' 
#' prds <- anlz_pred(mods = mods)
#' 
#' show_prddoy(prds, ylab = 'Chlorophyll-a (ug/L)')
show_prddoy <- function(predin, ylab, nfac = NULL){
  
  if(is.null(nfac))
    nfac <- predin %>%
      dplyr::pull(model) %>% 
      unique %>% 
      length

  # back-transform
  prds <- anlz_backtrans(prds)
  
  p <- ggplot2::ggplot(prds, ggplot2::aes(x = doy, group = factor(yr), colour = yr)) + 
    ggplot2::geom_line(ggplot2::aes(y = value)) + 
    ggplot2::theme_bw(base_family = 'serif', base_size = 16) + 
    ggplot2::theme(
      legend.position = 'top', 
      legend.title = element_blank(), 
      strip.background = element_blank()
    ) + 
    ggplot2::scale_color_viridis_c() + 
    ggplot2::facet_wrap(~ model, ncol = nfac) +
    ggplot2::guides(colour = ggplot2::guide_colourbar(barheight = 1, barwidth = 20)) +
    scale_y_log10(ylab) + 
    ggplot2::labs(
      x = "Day of year"
    )
  
  return(p)
  
}