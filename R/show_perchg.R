#' Plot percent change trends from GAM results for selected time periods
#'
#' Plot percent change trends from GAM results for selected time periods
#' 
#' @inheritParams anlz_perchg
#' @param ylab chr string for y-axis label
#'
#' @return A \code{\link[ggplot2]{ggplot}} object
#' @export
#' 
#' @family show
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
#' show_perchg(mod, baseyr = 1990, testyr = 2016, ylab = 'Chlorophyll-a (ug/L)')
show_perchg <- function(mod, baseyr, testyr, ylab) {
  
  # get change estimates
  chg <- anlz_perchg(mod, baseyr = baseyr, testyr = testyr) %>% 
    dplyr::mutate(pval = anlz_pvalformat(pval)) %>% 
    dplyr::mutate_if(is.numeric, round, 2)
  ttl <- paste0('Base: ', chg$baseval, ', Test: ', chg$testval, ', Change: ', chg$perchg, '%, ', chg$pval)
  
  # get predictions
  prds <- anlz_prd(mod)
  
  # get transformation
  trans <- unique(prds$trans)
  
  # get raw data from model
  tobacktrans <- mod$model %>% 
    dplyr::mutate(
      trans = mod$trans
    )
  
  moddat <- anlz_backtrans(tobacktrans) %>% 
    dplyr::mutate(
      date = lubridate::date_decimal(cont_year), 
      date = as.Date(date)
    )
  
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
      axis.title.x = ggplot2::element_blank()
    ) + 
    ggplot2::labs(
      title = ttl, 
      y = ylab
    )
  
  if(trans != 'ident')
    p <- p + ggplot2::scale_y_log10()
  
  # return(suppressWarnings(print(p))
  return(p)
         
}
