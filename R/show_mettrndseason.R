#' Plot seasonal metrics and rates of change
#'
#' Plot seasonal metrics and rates of change
#' 
#' @inheritParams anlz_trndseason
#' @param yromit optional numeric vector for years to omit from the plot, see details
#' @param ylab chr string for y-axis label
#' @param width numeric for width of error bars
#' @param size numeric for point size
#' @param nms optional character vector for trend names, see details
#' @param cols optional character vector for point colors, see details
#' @param cmbn logical indicating if the no trend and on estimate colors should be combined, see details
#' @param base_size numeric indicating base font size, passed to \code{\link[ggplot2]{theme_bw}}
#' @param xlim optional numeric vector of length two for x-axis limits
#' @param ylim optional numeric vector of length two for y-axis limits
#'
#' @details
#' The plot is the same as that returned by \code{\link{show_metseason}} with the addition of points for the seasonal metrics colored by the trends estimated from \code{\link{anlz_trndseason}} for the specified window and justification.  
#' 
#' Four colors are used to define increasing, decreasing, no trend, or no estimate (i.e., too few points for the window).  The names and the colors can be changed using the \code{nms} and \code{cols} arguments, respectively.  The \code{cmbn} argument can be used to combine the no trend and no estimate colors into one color and label. Although this may be desired for aesthetic reasons, the colors and labels may be misleading with the default names since no trend is shown for points where no estimates were made.
#' 
#' The optional \code{yromit} vector can be used to omit years from the plot and trend assessment. This may be preferred if seasonal estimates for a given year have very wide confidence intervals likely due to limited data, which can skew the trend assessments.
#' 
#' @concept show
#' 
#' @return A \code{\link[ggplot2]{ggplot}} object
#' @export
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
#' show_mettrndseason(mod, metfun = mean, doystr = 90, doyend = 180, justify = 'center', 
#'   win = 4, ylab = 'Chlorophyll-a (ug/L)')
show_mettrndseason <- function(mod, metfun = mean, doystr = 1, doyend = 364, justify = c('center', 'left', 'right'), win = 5, nsim = 1e4, useave = FALSE, yromit = NULL, ylab, width = 0.9, size = 3, nms = NULL, cols = NULL, cmbn = F, base_size = 11, xlim = NULL, ylim = NULL, ...){
  
  # get seasonal metrics and trends
  trndseason <- anlz_trndseason(mod = mod, metfun, doystr = doystr, doyend = doyend, justify = justify, win = win, useave = useave, yromit = yromit)

  # handle nms and cols args if not combine (keep no trend and no estimate)
  if(!cmbn){
    
    if(is.null(nms)) nms <- c("Increasing", "Decreasing", "No trend", "No estimate")
    if(is.null(cols)) cols <- c('tomato1', 'deepskyblue3', 'white', 'darkgrey')
  
    if(length(cols) != 4 | length(nms) != 4)
      stop('Four names or colors must be provided')
    
    # plot objects, add column for trend
    trndseason <- trndseason %>% 
      dplyr::mutate(
        trnd = dplyr::case_when(
          yrcoef > 0 & pval < 0.05 ~ cols[1], 
          yrcoef < 0 & pval < 0.05 ~ cols[2],
          pval >= 0.05 ~ cols[3],
          is.na(yrcoef) ~ cols[4]
        ), 
        trnd = factor(trnd, levels = cols, labels = nms)
      )
    
  }
  
  # handle nms and cols args if combine (combine no trend and no estimate)
  if(cmbn){
    
    if(is.null(nms)) nms <- c("Increasing", "Decreasing", "No trend")
    if(is.null(cols)) cols <- c('tomato1', 'deepskyblue3', 'white')
       
    if(length(cols) != 3 | length(nms) != 3)
      stop('Three names or colors must be provided')

    # plot objects, add column for trend
    trndseason <- trndseason %>% 
      dplyr::mutate(
        trnd = dplyr::case_when(
          yrcoef > 0 & pval < 0.05 ~ cols[1], 
          yrcoef < 0 & pval < 0.05 ~ cols[2],
          pval >= 0.05 | is.na(yrcoef) ~ cols[3]
        ), 
        trnd = factor(trnd, levels = cols, labels = nms)
      )
    
  }
  
  names(cols) <- nms
  
  # title
  dts <- as.Date(c(doystr, doyend), origin = as.Date("2000-12-31"))
  strt <- paste(lubridate::month(dts[1], label = T, abbr = T), lubridate::day(dts[1]))
  ends <- paste(lubridate::month(dts[2], label = T, abbr = T), lubridate::day(dts[2]))
  func <- as.character(substitute(metfun))
  ttl <- paste0('Est. ', func, ' with 95% confidence intervals: ', strt, '-',  ends)
  
  # subtitle for trend window
  subttl <- paste0('Points colored by trend for ', win, '-year, ', justify, '-justified window')
  
  toplo <- trndseason

  # plot output
  p <- ggplot2::ggplot(data = toplo, ggplot2::aes(x = yr, y = bt_met)) + 
    ggplot2::geom_errorbar(ggplot2::aes(ymin = bt_lwr, ymax = bt_upr), colour = 'black', width = width, na.rm = TRUE) +
    ggplot2::geom_point(ggplot2::aes(fill = trnd), pch = 21, color = 'black', size = size, na.rm = TRUE) +
    ggplot2::theme_bw(base_size = base_size) +
    ggplot2::scale_fill_manual(values = cols, drop = F) +
    ggplot2::theme(
      axis.title.x = ggplot2::element_blank(), 
      legend.position = 'top'
    ) + 
    ggplot2::labs(
      title = ttl, 
      subtitle = subttl, 
      y = ylab, 
      fill = NULL
    ) + 
    ggplot2::coord_cartesian(
      xlim = xlim, 
      ylim = ylim
    )
  
  return(p)
  
}
