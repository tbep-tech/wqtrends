#' Plot a 3-d surface of predictions
#'
#' Plot a 3-d surface of predictions
#' 
#' @inheritParams anlz_prd
#' @param ylab chr string for y-axis label
#'
#' @return a \code{plotly} surface
#' @export
#' 
#' @family show
#'
#' @examples
#' library(dplyr)
#' 
#' # data to model
#' tomod <- rawdat %>%
#'   filter(station %in% 32) %>%
#'   filter(param %in% 'chl')
#'   
#' mod <- anlz_gam(tomod, trans = 'log10')
#' 
#' show_prd3d(mod, ylab = 'Chlorophyll-a (ug/L)')
show_prd3d <- function(mod, ylab) {
  
  # get daily predictions, differs from anlz_prd
  prds <- anlz_prdday(mod)
  
  # backtransform daily predictions
  prds <- anlz_backtrans(prds)
  
  toplo <- prds %>% 
    dplyr::select(-date, -cont_year, -trans) %>% 
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