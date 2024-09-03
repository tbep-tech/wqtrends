#' Retrieve summary statistics for seasonal metrics and trend results
#'
#' @param mod input model object as returned by \code{\link{anlz_gam}}
#' @param doystr numeric indicating start Julian day for extracting averages
#' @param doyend numeric indicating ending Julian day for extracting averages
#' @param metfun function input for metric to calculate, e.g., \code{mean}, \code{var}, \code{max}, etc
#' @param yrstr numeric for starting year for trend model, see details
#' @param yrend numeric for ending year for trend model, see details
#' @param yromit optional numeric vector for years to omit from the plot, see details
#' @param nsim numeric indicating number of random draws for simulating uncertainty
#' @param confint numeric from zero to one indicating confidence interval level for summarizing the mixed-effects meta-analysis model, see details
#' @param useave logical indicating if \code{anlz_avgseason} is used for the seasonal metric calculation, see details
#' @param ... additional arguments passed to \code{metfun}, e.g., \code{na.rm = TRUE}
#'
#' @details This function is primarily for convenience to return summary statistics of a fitted GAM from \code{\link{anlz_gam}}. 
#' 
#' Note that \code{confint} only applies to the \code{summary} and \code{coeffs} list outputs.  It does not apply to the \code{metseason} list element output that is default set to 95% confidence for the trend metric intervals.
#' 
#' Set \code{useave = T} to speed up calculations if \code{metfun = mean}.  This will use \code{\link{anlz_avgseason}} to estimate the seasonal summary metrics using a non-stochastic equation.
#' 
#' @concept analyze
#'
#' @return A list object with named elements:
#' 
#' \itemize{
#'  \item \code{mixmet}: \code{\link[mixmeta]{mixmeta}} object of the fitted mixed-effects meta-analysis trend model
#'  \item \code{metseason}: tibble object of the fitted seasonal metrics as returned by \code{\link{anlz_metseason}} or \code{\link{anlz_avgseason}}
#'  \item \code{summary}: summary of the \code{mixmet} object
#'  \item \code{coeffs}: tibble object of the slope estimate coefficients from the \code{mixmet} model. An approximately linear slope estimate will be included as \code{slope.approx} if \code{trans = 'log10'} for the GAM used in \code{mod}.
#' }
#' 
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
#' 
#' anlz_sumstats(mod, metfun = mean, doystr = 90, doyend = 180, yrstr = 2016, 
#'   yrend = 2019, nsim = 100)
anlz_sumstats <- function(mod,  metfun = mean, doystr = 1, doyend = 364, yrstr = 2000, yrend = 2019, 
                          yromit = NULL, nsim = 1e4, confint = 0.95, useave = FALSE, ...) {
  
  # check if metfun input is mean
  chk <- identical(deparse(metfun), deparse(mean))
  
  # make sure user wants average and useave
  if(!chk & useave)
    stop('Specify metfun = mean if useave = T')
  
  if(useave)
    metseason <- anlz_avgseason(mod, doystr = doystr, doyend = doyend, yromit = yromit)
  if(!useave)
    metseason <- anlz_metseason(mod, metfun, doystr = doystr, doyend = doyend, nsim = nsim, yromit = yromit, ...)
  
  mixmet <- anlz_mixmeta(metseason, yrstr = yrstr, yrend = yrend)

  # Summary of the mixmeta object 
  s <- summary(mixmet, ci.level = confint)
  
  # zstat
  z <- s$coefficients["yr","z"]
  
  # Gather some key params in a convenient row of a tibble
  coeffs <- tibble::tibble(
      slope = s$coefficients["yr","Estimate"], # Original slope from summary.mixmeta
      slope.se = s$coefficients["yr","Std. Error"],
      z = z,
      p = s$coefficients["yr","Pr(>|z|)"],
      likelihood = pnorm(abs(z)),
      ci.lb = s$coefficients["yr",5],
      ci.ub = s$coefficients["yr",6]
    )
  
  if(mod$trans == 'log10'){
    
    # Back-transform the log-slope to the original units.  
    dispersion <- summary(mod)$dispersion
    
    # approximate linear slope
    prdslope <- data.frame(
        yr = seq(yrstr, yrend, length = 50)
      ) %>% 
      dplyr::mutate(
        met = predict(mixmet, newdata = data.frame(yr = yr)), 
        se = predict(mixmet, newdata = data.frame(yr = yr), se = T)[, 2], 
        bt_met = 10^(met + log(10) * dispersion/2)
      )
    
    slope.numeric <- lm(bt_met ~ yr, prdslope) %>% 
      summary %>% 
      coefficients %>% 
      .[2, 1]
    
    coeffs <- dplyr::bind_cols(
      tibble::tibble(
        slope.approx = slope.numeric
      ), 
      coeffs
    )
    
  }

  # filter yromit if provided
  if(!is.null(yromit))
    metseason <- metseason %>% 
       dplyr::filter(!yr %in% yromit)
  
  out <- list(mixmet = mixmet,
             metseason = metseason,
             summary = s,
             coeffs = coeffs)
  
  return(out)
         
}