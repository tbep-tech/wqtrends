#' Plot a 3-d surface of predictions
#'
#' Plot a 3-d surface of predictions
#' 
#' @inheritParams anlz_prd
#' @param ylab chr string for y-axis label
#' @param modi Character indicating which GAM to plot, one of \code{gam0}, \code{gam1}, \code{gam2}, or \code{gam3}
#'
#' @return a \code{plotly} surface
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
#' show_prd3d(tomod, gami = 'gam2', trans = 'boxcox', ylab = 'Chlorophyll-a')
#' }
#' # use previously fitted list of models
#' trans <- 'boxcox'
#' mods <- list(
#'   gam1 = anlz_gam(tomod, trans = trans)
#'   )
#' show_prd3d(mods = mods, ylab = 'Chlorophyll-a')
show_prd3d <- function(moddat = NULL, mods = NULL, ylab, gami = c('gam0', 'gam1', 'gam2', 'gam6'), ...) {

  if(is.null(moddat) & is.null(mods))
    stop('Must supply one of moddat or mods')

  if(is.null(mods)){

    # gam to fit
    gami <- match.arg(gami)
    
    mods <- list(anlz_gam(moddat, mod = gami, ...))
    names(mods) <- gami
    
  }
  
  if(!is.null(mods))
    stopifnot(length(mods) == 1)
  
  # get daily predictions, differs from anlz_prd
  prds <- anlz_prdday(mods = mods)
  
  # backtransform daily predictions
  prds <- anlz_backtrans(prds)
  
  toplo <- prds %>% 
    dplyr::select(-date, -dec_time, -trans, -model) %>% 
    dplyr::filter(!yr %in% 2018) %>% 
    tidyr::spread(yr, value) %>% 
    dplyr::select(-doy) %>% 
    as.matrix
  
  scene <- list(
    aspectmode = 'manual', 
    aspectratio = list(x = 1, y = 1, z = 0.75), 
    xaxis = list(title = 'Years from time zero'), 
    yaxis = list(title = 'Day of year'), 
    zaxis = list(title = ylab),
    roughness = .01,
    ambient = 0.9
  )
  
  p <- plotly::plot_ly(z = ~toplo, height = 600) %>% 
    plotly::add_surface(colors = viridisLite::viridis(12)) %>% 
    plotly::layout(scene = scene)
  
  return(p)

}