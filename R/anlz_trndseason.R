#' Estimate rates of change based on seasonal metrics
#'
#' Estimate rates of change based on seasonal metrics
#' 
#' @param mod input model object as returned by \code{\link{anlz_gam}}
#' @param metfun function input for metric to calculate, e.g., \code{mean}, \code{var}, \code{max}, etc
#' @param doystr numeric indicating start Julian day for extracting averages
#' @param doyend numeric indicating ending Julian day for extracting averages
#' @param justify chr string indicating the justification for the trend window
#' @param win numeric indicating number of years to use for the trend window, see details
#' @param nsim numeric indicating number of random draws for simulating uncertainty
#' @param yromit optional numeric vector for years to omit from the output
#' @param useave logical indicating if \code{anlz_avgseason} is used for the seasonal metric calculation
#' @param ... additional arguments passed to \code{metfun}, e.g., \code{na.rm = TRUE)}
#'
#' @return A data frame of slope estimates and p-values for each year
#' @export
#'
#' @concept analyze
#'
#' @details Trends are based on the slope of the fitted linear trend within the window, where the linear trend is estimated using a meta-analysis regression model (from \code{\link{anlz_mixmeta}}) for the seasonal metrics (from \code{\link{anlz_metseason}}).
#' 
#' Note that for left and right windows, the exact number of years in \code{win} is used. For example, a left-centered window for 1990 of ten years will include exactly ten years from 1990, 1991, ... , 1999.  The same applies to a right-centered window, e.g., for 1990 it would include 1981, 1982, ..., 1990 (if those years have data). However, for a centered window, picking an even number of years for the window width will create a slightly off-centered window because it is impossible to center on an even number of years.  For example, if \code{win = 8} and \code{justify = 'center'}, the estimate for 2000 will be centered on 1997 to 2004 (three years left, four years right, eight years total). Centering for window widths with an odd number of years will always create a symmetrical window, i.e., if \code{win = 7} and \code{justify = 'center'}, the estimate for 2000 will be centered on 1997 and 2003 (three years left, three years right, seven years total).
#' 
#' The optional \code{yromit} vector can be used to omit years from the trend assessment. This may be preferred if seasonal estimates for a given year have very wide confidence intervals likely due to limited data, which can skew the trend assessments.
#'
#' @family analyze
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
#' anlz_trndseason(mod, doystr = 90, doyend = 180, justify = 'center', win = 4)
anlz_trndseason <- function(mod, metfun = mean, doystr = 1, doyend = 364, justify = c('center', 'left', 'right'), win = 5, nsim = 1e4, yromit = NULL, useave = FALSE, ...){

  justify <- match.arg(justify)

  # check if metfun input is mean
  chk <- identical(deparse(metfun), deparse(mean))
  
  # make sure user wants average and useave
  if(!chk & useave)
    stop('Specify metfun = mean if useave = T')

  # estimate metrics
  if(useave)
    metseason <- anlz_avgseason(mod, doystr = doystr, doyend = doyend, yromit = yromit)
  if(!useave)
    metseason <- anlz_metseason(mod, metfun, doystr = doystr, doyend = doyend, nsim = nsim, yromit = yromit,...)

  tmp <- tibble::tibble(metseason)
  tmp$yrcoef <- NaN
  tmp$pval <- NaN

  # iterate through years to get trend
  for(i in seq_along(tmp$yr)){
 
    yr <- tmp$yr[i]

    if(justify == 'left'){
      yrstr <- yr
      yrend <- yr + win - 1
    
    }
    
    if(justify == 'right'){
      yrstr <- yr - win + 1
      yrend <- yr
    }
    
    if(justify == 'center'){
      yrstr <- floor(yr - win / 2) + 1
      yrend <- floor(yr + win / 2)
    }
      
    mixmet <- anlz_mixmeta(tmp, yrstr = yrstr, yrend = yrend)
    
    if(inherits(mixmet, 'logical'))
      next
    
    # get slope
    slope <- mixmet$coefficients['yr']
    slope_lwr <- summary(mixmet)$coefficients[2, 5]
    slope_upr <- summary(mixmet)$coefficients[2, 6]
    
    if(mod$trans == 'log10'){
      
      dispersion <- summary(mod)$dispersion
      bt_prd <- 10 ^ (predict(mixmet) + log(10) * dispersion / 2)
      df <- data.frame(chl = bt_prd, yr = mixmet$model$yr)
      apprslope <- lm(chl ~ yr, df) %>% summary %>% coefficients %>% .[2, 1]
    
      tmp[i, 'appr_yrcoef'] <- apprslope
      
    }
    
    tmp[i, 'yrcoef'] <- slope
    tmp[i, 'yrcoef_lwr'] <- slope_lwr
    tmp[i, 'yrcoef_upr'] <- slope_upr
    tmp[i, 'pval'] <- coefficients(summary(mixmet)) %>% data.frame %>% .[2, 4]
    
  }
  
  out <- tmp
  
  return(out)
  
}