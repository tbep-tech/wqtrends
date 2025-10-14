#' Plot rates of change based on seasonal metrics 
#'
#' Plot rates of change based on seasonal metrics
#' 
#' @inheritParams anlz_trndseason
#' @param type chr string indicating if log slopes are shown (if applicable)
#' @param ylab chr string for y-axis label
#' @param nms optional character vector for trend names
#' @param fils optional character vector for the fill of interior point colors
#' @param cols optional character vector for confidence interval colors
#' @param base_size numeric indicating base font size, passed to \code{\link[ggplot2]{theme_bw}}
#' @param xlim optional numeric vector of length two for x-axis limits
#' @param ylim optional numeric vector of length two for y-axis limits
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
#' show_trndseason(mod, doystr = 90, doyend = 180, justify = 'left', win = 4,
#'      ylab = 'Slope Chlorophyll-a (ug/L/yr)')
show_trndseason <- function(mod, metfun = mean, doystr = 1, doyend = 364, type = c('log10', 'approx'), 
                            justify = c('left', 'right', 'center'), win = 5, ylab, nsim = 1e4,
                            yromit = NULL, useave = FALSE, base_size = 11, nms = NULL, fils = NULL,
                            cols = NULL, xlim = NULL, ylim = NULL, ...) {
  
  justify <- match.arg(justify)
  type <- match.arg(type)
  
  # get slope trends
  trndseason <- anlz_trndseason(mod = mod, metfun = metfun, doystr = doystr, doyend = doyend, justify = justify, win = win, nsim = nsim, yromit = yromit, useave = useave, ...) 

  # title
  dts <- as.Date(c(doystr, doyend), origin = as.Date("2000-12-31"))
  strt <- paste(lubridate::month(dts[1], label = T, abbr = T), lubridate::day(dts[1]))
  ends <- paste(lubridate::month(dts[2], label = T, abbr = T), lubridate::day(dts[2]))

  # subtitle
  subttl <- paste0('Estimates based on ', justify , ' window of ', win, ' years')
  
  # year range
  yrrng <- range(trndseason$yr, na.rm = T)

  # setup names, colors, and fills
  if(is.null(nms)) nms <- c("Increasing", "Decreasing", "No trend")
  if(is.null(fils)) fils <- c('tomato1', 'deepskyblue3', 'white')
  if(is.null(cols)) cols <- c('tomato1', 'deepskyblue3', 'black')
  
  if(length(nms) != 3 | length(fils) !=  3 | length(cols) != 3)
    stop('Three names, fills, or colors must be provided')
    
  shps <- c(21, 21, 21)
  names(fils) <- nms
  names(cols) <- nms
  names(shps) <- nms
  
  # to plot, no NA
  toplo <- trndseason %>% 
    dplyr::mutate(
      pval = dplyr::case_when(
          pval < 0.05 & yrcoef > 0 ~ nms[1],
          pval < 0.05 & yrcoef < 0 ~ nms[2],
          T ~ nms[3]
        ), 
      pval = factor(pval, levels = nms)
      ) %>% 
    na.omit()

  if(type == 'log10' & mod$trans == 'log10'){
    
    ttl <- paste0('Annual log-slopes (+/- 95%) for seasonal trends: ', strt, '-',  ends)
    
    p <- ggplot2::ggplot(data = toplo, ggplot2::aes(x = yr, y = yrcoef, fill = pval)) + 
      ggplot2::geom_hline(yintercept = 0) + 
      ggplot2::geom_errorbar(ggplot2::aes(ymin = yrcoef_lwr, ymax = yrcoef_upr, color = pval), 
        width = 0, na.rm = TRUE, show.legend = TRUE) +
      ggplot2::scale_color_manual(values = cols, drop = FALSE)
 
  }
  
  if(type == 'approx' & mod$trans == 'log10'){
    
    ttl <- paste0('Annual slopes (approximate) for seasonal trends: ', strt, '-',  ends)
    
    p <- ggplot2::ggplot(data = toplo, ggplot2::aes(x = yr, y = appr_yrcoef, fill = pval)) + 
      ggplot2::geom_hline(yintercept = 0) + 
      ggplot2::labs(
        title = ttl, 
        subtitle = subttl, 
        y = ylab
      )
    
  }
  
  if(mod$trans == 'ident'){
    
    ttl <- paste0('Annual slopes (+/- 95%) for seasonal trends: ', strt, '-',  ends)
    
    p <- ggplot2::ggplot(data = toplo, ggplot2::aes(x = yr, y = yrcoef, fill = pval)) + 
      ggplot2::geom_hline(yintercept = 0) + 
      ggplot2::geom_errorbar(ggplot2::aes(ymin = yrcoef_lwr, ymax = yrcoef_upr, color = pval), 
        width = 0, na.rm = TRUE, show.legend = TRUE) +
      ggplot2::scale_color_manual(values = cols, drop = FALSE)
    
  }

  p <- p + 
    ggplot2::geom_point(ggplot2::aes(shape = pval), size = 3, na.rm = TRUE, show.legend = TRUE) +
    ggplot2::scale_fill_manual(values = fils, drop = FALSE) +
    ggplot2::scale_shape_manual(values = shps, drop = FALSE) +
    ggplot2::scale_x_continuous(limits = yrrng) +
    ggplot2::theme_bw(base_size = base_size) + 
    ggplot2::theme(
      axis.title.x = ggplot2::element_blank(), 
      legend.position = 'top', 
      legend.title = ggplot2::element_blank()
    ) +
    ggplot2::labs(
      title = ttl, 
      subtitle = subttl, 
      y = ylab
    ) + 
    ggplot2::coord_cartesian(
      xlim = xlim, 
      ylim = ylim
    )
  
  return(p)
  
}
