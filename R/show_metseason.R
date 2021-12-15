#' Plot period (seasonal) averages from fitted GAM
#'
#' Plot period (seasonal) averages from fitted GAM
#' 
#' @param mod input model object as returned by \code{\link{anlz_gam}}
#' @param doystr numeric indicating start Julian day for extracting averages
#' @param doyend numeric indicating ending Julian day for extracting averages
#' @param metfun function input for metric to calculate, e.g., \code{mean}, \code{var}, \code{max}, etc
#' @param yrstr numeric for starting year for trend model, see details
#' @param yrend numeric for ending year for trend model, see details
#' @param ylab chr string for y-axis label
#' @param nsim numeric indicating number of random draws for simulating uncertainty
#' @param useave logical indicating if \code{anlz_avgseason} is used for the seasonal metric calculation
#' @param ... additional arguments passed to \code{metfun}, e.g., \code{na.rm = TRUE)}
#'
#' @return A \code{\link[ggplot2]{ggplot}} object
#' @export
#' 
#' @details 
#' 
#' Setting \code{yrstr} or \code{yrend} to \code{NULL} will suppress plotting of the trend line for the meta-analysis regression model.
#' 
#' Set \code{useave = T} to speed up calculations if \code{metfun = mean}.  This will use \code{\link{anlz_avgseason}} to estimate the seasonal summary metrics using a non-stochastic equation.
#' 
#' @concept show
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
#' show_metseason(mod, doystr = 90, doyend = 180, yrstr = 2000, yrend = 2019, 
#'      ylab = 'Chlorophyll-a (ug/L)')
show_metseason <- function(mod, metfun = mean, doystr = 1, doyend = 364, yrstr = 2000, yrend = 2019, ylab, nsim = 1e4, useave = FALSE, ...) {
  
  # check if metfun input is mean
  chk <- identical(deparse(metfun), deparse(mean))
  
  # make sure user wants average and useave
  if(!chk & useave)
    stop('Specify metfun = mean if useave = T')
  
  # estimate metrics
  if(useave)
    metseason <- anlz_avgseason(mod, doystr = doystr, doyend = doyend)
  if(!useave)
    metseason <- anlz_metseason(mod, metfun, doystr = doystr, doyend = doyend, nsim = nsim, ...)
  
  # transformation used
  trans <- mod$trans

  # title
  dts <- as.Date(c(doystr, doyend), origin = as.Date("2000-12-31"))
  strt <- paste(lubridate::month(dts[1], label = T, abbr = T), lubridate::day(dts[1]))
  ends <- paste(lubridate::month(dts[2], label = T, abbr = T), lubridate::day(dts[2]))
  func <- as.character(substitute(metfun))
  ttl <- paste0('Est. ', func, ' with 95% confidence intervals: ', strt, '-',  ends)

  # subtitle only if any years missing
  subttl <- NULL
  
  # plot objects
  toplo1 <- metseason
  
  # plot output
  p <- ggplot2::ggplot(data = toplo1, ggplot2::aes(x = yr, y = bt_met)) + 
    ggplot2::geom_point(colour = 'deepskyblue3') +
    ggplot2::geom_errorbar(ggplot2::aes(ymin = bt_lwr, ymax = bt_upr), colour = 'deepskyblue3') +
    ggplot2::theme_bw(base_family = 'serif', base_size = 16) + 
    ggplot2::theme(
      axis.title.x = ggplot2::element_blank()
    )
  
  # get mixmeta models and plotting results
  if(!any(is.null(yrstr) | is.null(yrend))){
    
    # get mixmeta models
    mixmet <- anlz_mixmeta(metseason, yrstr = yrstr, yrend = yrend)
  
    toplo2 <- data.frame(
      yr = seq(yrstr, yrend, length = 50)
      ) %>% 
      dplyr::mutate( 
        met = predict(mixmet, newdata = data.frame(yr = yr)), 
        se = predict(mixmet, newdata = data.frame(yr = yr), se = T)[, 2], 
        bt_lwr = met - 1.96 * se,
        bt_upr = met + 1.96 * se,
        bt_met = met
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
          met = predict(mixmet, newdata = data.frame(yr = yr)), 
          se = predict(mixmet, newdata = data.frame(yr = yr), se = T)[, 2], 
          bt_lwr = 10^((met - 1.96 * se) + log(10) * dispersion / 2),
          bt_upr = 10^((met + 1.96 * se) + log(10) * dispersion / 2),
          bt_met = 10^(met + log(10) * dispersion / 2)
        )
      
      # for subtitle
      slope <- lm(bt_met ~ yr, toplo2) %>% summary %>% coefficients %>% .[2, 1]
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

    p <- p +
      ggplot2::geom_ribbon(data = toplo2, ggplot2::aes(ymin = bt_lwr, ymax = bt_upr), fill = 'pink', alpha = 0.4) +
      ggplot2::geom_line(data = toplo2, color = 'pink')
    
  }
  
  p <- p + 
    ggplot2::labs(
      title = ttl, 
      subtitle = subttl, 
      y = ylab
    )
  
  return(p)
  
}
