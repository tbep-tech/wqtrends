#' Estimate seasonal rates of change based on average estimates
#'
#' Estimate seasonal rates of change based on average estimates
#' 
#' @param mod input model object as returned by \code{\link{anlz_gam}}
#' @param doystr numeric indicating start Julian day for extracting averages
#' @param doyend numeric indicating ending Julian day for extracting averages
#' @param justify chr string indicating the justification for the trend window
#' @param win numeric indicating number of years to use for the trend window
#'
#' @return A data frame of slope estimates and p-values for each year
#' @export
#'
#' @details Trends are based on the slope of the fitted linear trend within the window, where the linear trend is estimated using a meta-analysis regression model (from \code{\link{anlz_mixmeta}}) for the seasonal averages (from \code{\link{anlz_avgseason}})
#' @family analyze
#' 
#' @examples
#' library(dplyr)
#' 
#' # data to model
#' tomod <- rawdat %>%
#'   filter(station %in% 32) %>%
#'   filter(param %in% 'chl')
#'
#' mod <- anlz_gam(tomod, trans = 'log10')
#' anlz_trndseason(mod, doystr = 90, doyend = 180, justify = 'center', win = 5)
anlz_trndseason <- function(mod, doystr = 1, doyend = 364, justify = c('center', 'left', 'right'), win = 5){
  
  # get seasonal averages
  avgseason <- anlz_avgseason(mod, doystr = doystr, doyend = doyend) 

  justify <- match.arg(justify)

  tmp <- tibble::tibble(avgseason)
  tmp$yrcoef <- NaN
  tmp$pval <- NaN
  
  # iterate through years to get trend
  for(i in seq_along(tmp$yr)){
    
    yr <- tmp$yr[i]

    if(justify == 'left')
      mixmet <- anlz_mixmeta(tmp, yrstr = yr, yrend = yr + win - 1)
    
    if(justify == 'right')
      mixmet <- anlz_mixmeta(tmp, yrstr = yr - win + 1, yrend = yr)
    
    if(justify == 'center')
      mixmet <- anlz_mixmeta(tmp, yrstr = round(yr - win / 2), yrend = round(yr + win / 2))
    
    if(inherits(mixmet, 'logical'))
      next

    # get slope estimate
    # dispersion <- summary(mod)$dispersion
    # bt_slo <- mixmet$model %>% 
    #   dplyr::select(yr) %>% 
    #   dplyr::mutate(
    #     avg = predict(mixmet), 
    #     bt_avg = 10^(avg + log(10) * dispersion / 2)
    #     )
    # bt_slo <- (bt_slo$bt_avg[nrow(bt_slo)] - bt_slo$bt_avg[1]) / (bt_slo$yr[nrow(bt_slo)] - bt_slo$yr[1])
    # 
    # tmp[i, 'yrcoef'] <- bt_slo
    tmp[i, 'yrcoef'] <- mixmet$coefficients['yr']
    tmp[i, 'pval'] <- coefficients(summary(mixmet)) %>% data.frame %>% .[2, 4]
    
  }
  
  out <- tmp
  
  return(out)
  
}