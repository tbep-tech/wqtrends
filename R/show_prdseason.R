#' Plot predictions for GAMs over time, by season
#'
#' Plot predictions for GAMs over time, by season
#' 
#' @inheritParams show_prdseries
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
#' show_prdseason(moddat = tomod, ylab = 'Chlorophyll-a (ug/L)', trans = 'boxcox')
#' }
#' # use previously fitted list of models
#' trans <- 'boxcox'
#' mods <- list(
#'   gam0 = anlz_gam(tomod, mod = 'gam0', trans = trans),
#'   gam1 = anlz_gam(tomod, mod = 'gam1', trans = trans),
#'   gam2 = anlz_gam(tomod, mod = 'gam2', trans = trans)
#' )
#' 
#' show_prdseason(moddat = tomod, mods = mods, ylab = 'Chlorophyll-a (ug/L)')
show_prdseason <- function(moddat = NULL, mods = NULL, ylab, nfac = NULL, faclev = NULL, faclab = NULL, ...){
  
  if(is.null(nfac))
    nfac <- 1
  
  # get models if not provided
  if(is.null(mods)){
    
    mods <- list(
      gam0 = anlz_gam(moddat, mod = 'gam0', ...),
      gam1 = anlz_gam(moddat, mod = 'gam1', ...), 
      gam2 = anlz_gam(moddat, mod = 'gam2', ...), 
      gam6 = anlz_gam(moddat, mod = 'gam6', ...)
    ) 
    
    levnms <- c('gam0', 'gam1', 'gam2', 'gam6') 
    
  }
 
  # get daily predictions, differs from anlz_prd
  prds <- anlz_prdday(mods = mods)
  
  # changing model factors
  if(is.null(faclev))
    faclev <- prds %>% 
      dplyr::pull(model) %>% 
      unique
    
  if(is.null(faclab))
    faclab <- faclev
  
  # get transformation
  trans <- unique(prds$trans)
  
  # backtransform daily predictions
  prds <- anlz_backtrans(prds) %>% 
    dplyr::mutate(
      model = factor(model, levels = faclev, labels = faclab)
    )
  
  # get raw data from model if not provided
  if(is.null(moddat)){
    
    stopifnot(!is.null(mods))
    
    tobacktrans <- mods[[1]]$model %>% 
      dplyr::mutate(
        trans = mods[[1]]$trans
      )
    
    moddat <- anlz_backtrans(tobacktrans) %>% 
      dplyr::mutate(
        date = lubridate::date_decimal(cont_year), 
        date = as.Date(date)
      )
    
  }
  
  toplo <- prds %>% 
    dplyr::mutate(day = lubridate::day(date)) %>% 
    dplyr::filter(day %in% c(1)) %>%
    dplyr::mutate(month = lubridate::month(date, label = T))
  
  # plot
  p <- ggplot2::ggplot(toplo, ggplot2::aes(x = date)) + 
    ggplot2::geom_point(data = moddat, ggplot2::aes(y = value), size = 0.5) +
    ggplot2::geom_line(ggplot2::aes(y = value, group = month, colour = month), size = 1, alpha = 0.7) + 
    ggplot2::theme_bw(base_family = 'serif', base_size = 16) + 
    ggplot2::facet_wrap(~model, ncol = nfac) + 
    ggplot2::theme(
      legend.position = 'top', 
      axis.title.x = ggplot2::element_blank(), 
      strip.background = ggplot2::element_blank(), 
      legend.title = ggplot2::element_blank()
    ) +
    ggplot2::guides(col = ggplot2::guide_legend(nrow = 2)) +
    ggplot2::labs(
      y = ylab
    )
 
  if(trans != 'ident')
    p <- p + ggplot2::scale_y_log10()

  return(p)
  
}