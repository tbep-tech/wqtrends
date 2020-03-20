#' Plot percent change trends from GAM results for selected time periods
#'
#' Plot percent change trends from GAM results for selected time periods
#' 
#' @inheritParams anlz_perchg
#' @param ylab chr string for y-axis label
#' @param gami Character indicating which GAM to plot, one of \code{gam0}, \code{gam1}, \code{gam2}, or \code{gam3}
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
#' show_perchg(tomod, gami = 'gam1', trans = 'boxcox', baseyr = 1990, testyr = 2016, ylab = 'Chlorophyll-a (ug/L)')
#' }
#' # use previously fitted list of models
#' trans <- 'boxcox'
#' mods <- list(
#'   gam2 = anlz_gam(tomod, mod = 'gam2', trans = trans)
#'   )
#' show_perchg(mods = mods, baseyr = 1990, testyr = 2016, ylab = 'Chlorophyll-a (ug/L)')
show_perchg <- function(moddat = NULL, mods = NULL, baseyr, testyr, ylab, gami = c('gam0', 'gam1', 'gam2', 'gam6'), ...) {
  
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
  
  # get change estimates
  chg <- anlz_perchg(moddat = moddat, mods = mods, baseyr = baseyr, testyr = testyr) %>% 
    dplyr::mutate(pval = anlz_pvalformat(pval)) %>% 
    dplyr::mutate_if(is.numeric, round, 2)
  ttl <- paste0('Base: ', chg$baseval, ', Test: ', chg$testval, ', Change: ', chg$perchg, '%, ', chg$pval)
  
  # get predictions
  prds <- anlz_prd(moddat = moddat, mods = mods, ...)
  
  # get transformation
  trans <- unique(prds$trans)
  
  # back-transform
  prds <- anlz_backtrans(prds)
  
  # get raw data from model if not provided
  if(is.null(moddat)){
    
    stopifnot(!is.null(mods))
    
    tobacktrans <- mods[[1]]$model %>% 
      dplyr::mutate(
        trans = mods[[1]]$trans
      )
    
    moddat <- anlz_backtrans(tobacktrans) %>% 
      dplyr::mutate(
        date = lubridate::date_decimal(dec_time), 
        date = as.Date(date)
      )
    
  }
  
  # boundaries for base, test years
  trndswn <- prds %>% 
    dplyr::filter(yr %in% c(baseyr, testyr)) %>% 
    dplyr::group_by(yr) %>% 
    dplyr::filter(date %in% range(date)) %>%
    dplyr::ungroup() %>%
    dplyr::mutate(
      xval = ifelse(duplicated(yr), 'xmax', 'xmin'),
      bl = dplyr::case_when(
        yr %in% baseyr ~ 'baseyr', 
        yr %in% testyr ~ 'testyr'
        )
      ) %>%
    dplyr::select(xval, yr, bl, date) %>% 
    tidyr::spread(xval, date)
  
  rctmn <- ifelse(trans == 'ident', -Inf, 0)
  
  p <- ggplot2::ggplot() + 
    ggplot2::geom_rect(data = trndswn, ggplot2::aes(xmin = xmin, xmax = xmax, ymin = rctmn, ymax = Inf, group = yr, fill = bl), alpha = 0.7) +
    ggplot2::geom_point(data = moddat, ggplot2::aes(x = date, y = value), size = 0.5) +
    ggplot2::geom_line(data = prds, ggplot2::aes(x = date, y = value), size = 0.75, alpha = 0.8) + 
    ggplot2::theme_bw(base_family = 'serif', base_size = 16) + 
    ggplot2::scale_fill_manual(values = c('lightblue', 'lightgreen')) +
    ggplot2::theme(
      legend.position = 'none', 
      legend.title = ggplot2::element_blank(),
      strip.text = ggplot2::element_blank(), 
      strip.background = ggplot2::element_blank(), 
      axis.title.x = ggplot2::element_blank()
    ) + 
    ggplot2::labs(
      title = ttl, 
      y = ylab
    )
  
  if(trans != 'ident')
    p <- p + ggplot2::scale_y_log10()
  
  return(suppressWarnings(print(p)))
  
}
