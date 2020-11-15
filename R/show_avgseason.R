#' Plot period (seasonal) averages from fitted GAM
#'
#' Plot period (seasonal) averages from fitted GAM
#' 
#' @inheritParams anlz_avgseason
#' @param yrstr numeric for starting year for trend model
#' @param yrend numeric for ending year for trend model
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
#' show_avgseason(mod, doystr = 90, doyend = 180, yrstr = 2000, yrend = 2019, 
#'      ylab = 'Chlorophyll-a (ug/L)')
show_avgseason <- function(mod, doystr = 1, doyend = 364, yrstr = 2000, yrend = 2019, ylab) {
  
  # transformation used
  trans <- mod$trans
  
  # get seasonal averages
  avgseason <- anlz_avgseason(mod, doystr = doystr, doyend = doyend) 
  
  # get mixmeta models
  mixmet <- anlz_mixmeta(avgseason, yrstr = yrstr, yrend = yrend)

  # title
  dts <- as.Date(c(doystr, doyend), origin = as.Date("2000-12-31"))
  strt <- paste(lubridate::month(dts[1], label = T, abbr = T), lubridate::day(dts[1]))
  ends <- paste(lubridate::month(dts[2], label = T, abbr = T), lubridate::day(dts[2]))
  ttl <- paste0('Fitted averages with 95% confidence intervals: ', strt, '-',  ends)
  
  # backtrans
  toplo1 <- avgseason
  toplo2 <- data.frame(
    yr = seq(yrstr, yrend, length = 50)
    ) %>% 
    dplyr::mutate( 
      avg = predict(mixmet, newdata = data.frame(yr = yr)), 
      se = predict(mixmet, newdata = data.frame(yr = yr), se = T)[, 2], 
      lwr = avg - 1.96 * se,
      upr = avg + 1.96 * se
    )

  # subtitle
  slope <-  coefficients(summary(mixmet)) %>% .[2, 1] %>% round(2)
  pval <- coefficients(summary(mixmet)) %>% data.frame %>% .[2, 4] %>% anlz_pvalformat()
  subttl <- paste0('Trend from ', yrstr, ' to ', yrend, ': slope ', slope, ', ', pval)
  
  # plot output
  p <- ggplot2::ggplot(data = toplo1, ggplot2::aes(x = yr, y = avg)) + 
    ggplot2::geom_point(colour = 'deepskyblue3') +
    ggplot2::geom_errorbar(ggplot2::aes(ymin = lwr, ymax = upr), colour = 'deepskyblue3') +
    ggplot2::geom_ribbon(data = toplo2, ggplot2::aes(ymin = lwr, ymax = upr), fill = 'pink', alpha = 0.4) +
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
