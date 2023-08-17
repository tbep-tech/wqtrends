#' Extract period (seasonal) metrics from fitted GAM
#' 
#' Extract period (seasonal) metrics from fitted GAM
#' 
#' @param mod input model object as returned by \code{\link{anlz_gam}}
#' @param metfun function input for metric to calculate, e.g., \code{mean}, \code{var}, \code{max}, etc
#' @param doystr numeric indicating start Julian day for extracting averages
#' @param doyend numeric indicating ending Julian day for extracting averages
#' @param nsim numeric indicating number of random draws for simulating uncertainty
#' @param ... additional arguments passed to \code{metfun}, e.g., \code{na.rm = TRUE)}
#'
#' @return A data frame of period metrics
#' @export
#' 
#' @details This function estimates a metric of interest for a given seasonal period each year using results from a fitted GAM (i.e., from \code{\link{anlz_gam}}).  The estimates are based on the predicted values for each seasonal period, with uncertainty of the metric based on repeated sampling of the predictions following uncertainty in the model coefficients.
#'
#' @concept analyze
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
#' anlz_metseason(mod, mean, doystr = 90, doyend = 180, nsim = 100)
anlz_metseason <- function(mod, metfun = mean, doystr = 1, doyend = 364, nsim = 1e4, ...) {

  # transformation
  trans <- mod$trans
  
  # number of days in seasonal window
  numDays <- doyend - doystr + 1
  
  # prediction matrix
  fillData <- anlz_prdmatrix(mod, doystr = doystr, doyend = doyend)
  
  # basis function coefficients and var/cov matrix (uncertainty of coefs)
  gamcoefs <- coef(mod)
  vargamcoefs <- mod$Vp
  
  # random sim of coefs basedon multivariate normal
  coefrnd <- rmvn(nsim, gamcoefs, vargamcoefs) 
  
  mets <- fillData %>% 
    dplyr::group_by(yr) %>% 
    tidyr::nest() %>% 
    dplyr::mutate(
      met = purrr::map(data, function(x){
        
        Xp <- predict(mod, x, typ = 'lpmatrix') # all basis functions
        
        pred <- Xp %*% gamcoefs
        met <- metfun(pred, ...)
        
        sims <- Xp %*% t(coefrnd)
        unc <- apply(sims, 2, metfun, ...)
        ses <- sd(unc)
        
        out <- data.frame(met = met, se = ses)
        
        return(out)
        
      })
    ) %>% 
    dplyr::select(-data) %>% 
    dplyr::ungroup() %>% 
    tidyr::unnest('met')

  # backtransform, add lwr/upr confidence intervals
  dispersion <- summary(mod)$dispersion
  
  if(trans == 'log10'){
    mets$bt_lwr <- 10^((mets$met - 1.96 * mets$se) + log(10) * dispersion / 2)
    mets$bt_upr <- 10^((mets$met + 1.96 * mets$se) + log(10) * dispersion / 2)
    mets$bt_met <- 10^(mets$met + log(10) * dispersion / 2)
  }
  if(trans == 'ident'){
    mets$bt_met <- mets$met
    mets$bt_lwr <- mets$met - 1.96 * mets$se
    mets$bt_upr <- mets$met + 1.96 * mets$se
  }
  
  # add dispersion to output
  mets$dispersion <- dispersion
  
  out <- mets
  
  return(out)
  
}
