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
#' mod <- anlz_gam(tomod, trans = 'ident')
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

  # plot objects
  toplo1 <- avgseason
  
  toplo2 <- data.frame(
    yr = seq(yrstr, yrend, length = 50)
    ) %>% 
    dplyr::mutate( 
      avg = predict(mixmet, newdata = data.frame(yr = yr)), 
      se = predict(mixmet, newdata = data.frame(yr = yr), se = T)[, 2], 
      bt_lwr = avg - 1.96 * se,
      bt_upr = avg + 1.96 * se,
      bt_avg = avg
    )
  
  # subtitle info
  pval <- coefficients(summary(mixmet)) %>% data.frame %>% .[2, 4] %>% anlz_pvalformat()
  
  # backtransform if log10
  if(mod$trans == 'log10'){
    
    dispersion <- summary(mod)$dispersion
  
    # backtransform mixmeta predictions
    toplo2 <- data.frame(
      yr = seq(yrstr, yrend, length = 50)
      ) %>% 
      dplyr::mutate( 
        avg = predict(mixmet, newdata = data.frame(yr = yr)), 
        se = predict(mixmet, newdata = data.frame(yr = yr), se = T)[, 2], 
        bt_lwr = 10^((avg - 1.96 * se) + log(10) * dispersion / 2),
        bt_upr = 10^((avg + 1.96 * se) + log(10) * dispersion / 2),
        bt_avg = 10^(avg + log(10) * dispersion / 2)
      )
    
    # for subtitle
    slope <- lm(bt_avg ~ yr, toplo2) %>% summary %>% coefficients %>% .[2, 1]
    slope <- round(slope, 2)
    logslope <- summary(mixmet)$coefficients[2, c(1, 5, 6)]
    logslope <- round(logslope, 2)
    logslope <- paste0(logslope[1], ' (', logslope[2], ', ', logslope[3], ')')
    subttl <- paste0('Trend from ', yrstr, ' to ', yrend, ': approximate slope ', slope, ', log-slope ', logslope, ', ', pval)
    
  }
  
  if(mod$trans == 'ident'){
    
    slope <- summary(mixmet)$coefficients[2, c(1, 5, 6)]
    slope <- round(slope, 2)
    slope <- paste0(slope[1], ' (', slope[2], ', ', slope[3], ')')
    subttl <- paste0('Trend from ', yrstr, ' to ', yrend, ': slope ', slope, ', ', pval)
    
  }

  # plot output
  p <- ggplot2::ggplot(data = toplo1, ggplot2::aes(x = yr, y = bt_avg)) + 
    ggplot2::geom_point(colour = 'deepskyblue3') +
    ggplot2::geom_errorbar(ggplot2::aes(ymin = bt_lwr, ymax = bt_upr), colour = 'deepskyblue3') +
    ggplot2::geom_ribbon(data = toplo2, ggplot2::aes(ymin = bt_lwr, ymax = bt_upr), fill = 'pink', alpha = 0.4) +
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
