#' Plot period (seasonal) averages from fitted GAM
#'
#' Plot period (seasonal) averages from fitted GAM
#' 
#' @inheritParams anlz_avgseason
#' @param yrstr numeric for starting year for trend model
#' @param yrend numeric for ending year for trend model
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
#' show_avgseason(tomod, trans = 'boxcox', doystr = 90, doyend = 180, yrstr = 2000, yrend = 2017, ylab = 'Chlorophyll-a (ug/L)', gami = 'gam2')
#' }
#' # use previously fitted list of models
#' trans <- 'boxcox'
#' mods <- list(
#'   gam2 = anlz_gam(tomod, mod = 'gam2', trans = trans)
#'   )
#' show_avgseason(mods = mods, trans = 'boxcox', doystr = 90, doyend = 180, yrstr = 2000, yrend = 2017, ylab = 'Chlorophyll-a (ug/L)', gami = 'gam2')
show_avgseason <- function(moddat = NULL, mods = NULL, doystr = 1, doyend = 364, yrstr = 2000, yrend = 2017, ylab, gami = c('gam0', 'gam1', 'gam2', 'gam6'), ...) {
  
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
  
  # get seasonal averages
  avgseason <- anlz_avgseason(moddat = moddat, mods = mods, doystr = doystr, doyend = doyend) 
  
  # get mixmeta models
  mixmet <- anlz_mixmeta(avgseason, yrstr = yrstr, yrend = yrend)[[1]]
  
  # title
  dts <- as.Date(c(doystr, doyend), origin = as.Date("2017-12-31"))
  strt <- paste(lubridate::month(dts[1], label = T, abbr = T), lubridate::day(dts[1]))
  ends <- paste(lubridate::month(dts[2], label = T, abbr = T), lubridate::day(dts[2]))
  ttl <- paste0('Fitted averages with 95% confidence intervals: ', strt, '-',  ends)
 
  # subtitle
  yrcoef <- mixmet$coefficients['yr'] %>% round(., 2)
  pval <- coefficients(summary(mixmet)) %>% data.frame %>% .[2, 4] %>% anlz_pvalformat()
  subttl <- paste0('Trend from ', yrstr, ' to ', yrend, ': slope ', yrcoef, ', ', pval)

  toplo1 <- avgseason
  toplo2 <- data.frame(
    yr = seq(yrstr, yrend, length = 50)
    ) %>% 
    dplyr::mutate( 
      predicted = predict(mixmet, newdata = data.frame(yr = yr)), 
      se = predict(mixmet, newdata = data.frame(yr = yr), se = T)[, 2]
    )
  
  # plot output
  p <- ggplot2::ggplot(data = toplo1, ggplot2::aes(x = yr, y = predicted)) + 
    ggplot2::geom_point(colour = 'deepskyblue3') +
    ggplot2::geom_errorbar(ggplot2::aes(ymin = predicted - (1.96 * se), ymax = predicted + (1.96 * se)), colour = 'deepskyblue3') +
    ggplot2::geom_ribbon(data = toplo2, ggplot2::aes(ymin = predicted - (1.96 * se), ymax = predicted + (1.96 * se)), fill = 'pink', alpha = 0.4) +
    ggplot2::geom_line(data = toplo2, color = 'pink') +
    ggplot2::theme_bw(base_family = 'serif', base_size = 16) + 
    ggplot2::theme(
      axis.title.x = ggplot2::element_blank()
    ) +
    ggplot2::labs(
      title = ttl, 
      subtitle = subttl, 
      y = ylab
    )
  
  return(p)
  
}
