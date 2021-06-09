#' Estimate seasonal rates of change based on average estimates
#'
#' Estimate seasonal rates of change based on average estimates
#' 
#' @param mod input model object as returned by \code{\link{anlz_gam}}
#' @param metfun function input for metric to calculate, e.g., \code{mean}, \code{var}, \code{max}, etc
#' @param doystr numeric indicating start Julian day for extracting averages
#' @param doyend numeric indicating ending Julian day for extracting averages
#' @param justify chr string indicating the justification for the trend window
#' @param win numeric indicating number of years to use for the trend window
#' @param nsim numeric indicating number of random draws for simulating uncertainty
#' @param ... additional arguments passed to \code{metfun}, e.g., \code{na.rm = TRUE)}
#'
#' @return A data frame of slope estimates and p-values for each year
#' @export
#'
#' @concept analyze
#'
#' @details Trends are based on the slope of the fitted linear trend within the window, where the linear trend is estimated using a meta-analysis regression model (from \code{\link{anlz_mixmeta}}) for the seasonal metrics (from \code{\link{anlz_metseason}}).
#' 
#' Note that for left and right windows, the exact number of years in \code{win} is used. For example, a left-centered window for 1990 of ten years will include exactly ten years from 1990, 1991, ... , 1999.  The same applies to a right-centered window, e.g., for 1990 it would include 1981, 1982, ..., 1990 (if those years have data). However, for a centered window, picking an even number of years will always have an extra year to center the window exactly, e.g., a ten year window for 1990 will include eleven years from 1985 to 1995 so there is the same number of years to the left and right of center. A centered window with an odd number of years will always be centered and includes the exact number of years used in \code{win}.
#'
#' @family analyze
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
#' anlz_trndseason(mod, doystr = 90, doyend = 180, justify = 'center', win = 8)
anlz_trndseason <- function(mod, metfun = mean, doystr = 1, doyend = 364, justify = c('center', 'left', 'right'), win = 5, nsim = 1e4, ...){

  justify <- match.arg(justify)

  # estimate metrics
  metseason <- anlz_metseason(mod, metfun, doystr = doystr, doyend = doyend, nsim = nsim, ...)

  tmp <- tibble::tibble(metseason)
  tmp$yrcoef <- NaN
  tmp$pval <- NaN
  
  # iterate through years to get trend
  for(i in seq_along(tmp$yr)){
    
    yr <- tmp$yr[i]

    if(justify == 'left')
      mixmet <- anlz_mixmeta(tmp, yrstr = yr, yrend = yr + win - 1)
    
    if(justify == 'right')
      mixmet <- anlz_mixmeta(tmp, yrstr = yr - win + 1, yrend = yr)

    if(justify == 'center'){
      
      yrstr <- round(yr - win / 2)
      yrend <- round(yr + win / 2)
      
      if(win %% 2 != 0){
        yrstr <- yrstr + 1
        yrend <- yrend - 1
      }
      
      mixmet <- anlz_mixmeta(tmp, yrstr = yrstr, yrend = yrend)
     
       
    }
    
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