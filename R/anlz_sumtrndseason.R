#' Estimate seasonal rates of change based on average estimates for multiple window widths
#'
#' Estimate seasonal rates of change based on average estimates for multiple window widths
#' 
#' @param mod input model object as returned by \code{\link{anlz_gam}}
#' @param doystr numeric indicating start Julian day for extracting averages
#' @param doyend numeric indicating ending Julian day for extracting averages
#' @param justify chr string indicating the justification for the trend window
#' @param win numeric vector indicating number of years to use for the trend window
#' @param yromit optional numeric vector for years to omit from the plot, see details
#'
#' @return A data frame of slope estimates and p-values for each year
#' @export
#'
#' @details
#'  
#' The optional \code{yromit} vector can be used to omit years from the plot and trend assessment. This may be preferred if seasonal estimates for a given year have very wide confidence intervals likely due to limited data, which can skew the trend assessments.
#' 
#' @concept analyze
#'
#' @details This function is a wrapper to \code{\link{anlz_trndseason}} to loop across values in \code{win}, using \code{useave = TRUE} for quicker calculation of average seasonal metrics.  It does not work with any other seasonal metric calculations.
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
#' anlz_sumtrndseason(mod, doystr = 90, doyend = 180, justify = 'center', win = 2:3)
anlz_sumtrndseason <- function(mod, doystr = 1, doyend = 364, justify = c('center', 'left', 'right'), win = 5:15, 
                               yromit = NULL){
  
  justify <- match.arg(justify)
  
  tmp <- NULL
  for(i in win){
    res <- anlz_trndseason(mod, metfun = mean, doystr = doystr, doyend = doyend, justify = justify, win = i, useave = T, yromit = yromit)
    res$win <- i
    tmp <- rbind(tmp, res)
  }

  out <- tmp %>% 
    dplyr::select(yr, yrcoef, pval, win)
  
  return(out)
  
}
  