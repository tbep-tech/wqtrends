#' Extract period (seasonal) averages from fitted GAM
#' 
#' Extract period (seasonal) averages from fitted GAM
#' 
#' @param mod input model object as returned by \code{\link{anlz_gam}}
#' @param doystr numeric indicating start Julian day for extracting averages
#' @param doyend numeric indicating ending Julian day for extracting averages
#'
#' @return A data frame of period averages
#' @export
#'
#' @concept analyze
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
#' anlz_avgseason(mod, doystr = 90, doyend = 180)
anlz_avgseason <- function(mod, doystr = 1, doyend = 364) {
  
  # transformation
  trans <- mod$trans
  
  # number of days in seasonal window
  numDays <- doyend - doystr + 1
  
  # prediction matrix
  fillData <- anlz_prdmatrix(mod, doystr = doystr, doyend = doyend, avemat = TRUE)
  
  # yr vector
  yr <- fillData %>% dplyr::pull(yr) %>% unique
  
  ## See Examples section of help(predict.gam)
  Xp <- predict(mod, newdata = fillData, type = "lpmatrix")
  coefs <- coef(mod)
  A <- kronecker(diag(length(yr)), matrix(rep(1/numDays, numDays), nrow = 1))
  Xs <- A %*% Xp
  means <- as.numeric(Xs %*% coefs)
  ses <- sqrt(diag(Xs %*% mod$Vp %*% t(Xs)))
  avgs <- data.frame(met = means, se = ses, yr = yr)
  
  # backtransform, add lwr/upr confidence intervals
  dispersion <- summary(mod)$dispersion
  
  if(trans == 'log10'){
    avgs$bt_lwr <- 10^((avgs$met - 1.96 * avgs$se) + log(10) * dispersion / 2)
    avgs$bt_upr <- 10^((avgs$met + 1.96 * avgs$se) + log(10) * dispersion / 2)
    avgs$bt_met <- 10^(avgs$met + log(10) * dispersion / 2)
  }
  if(trans == 'ident'){
    avgs$bt_met <- avgs$met
    avgs$bt_lwr <- avgs$met - 1.96 * avgs$se
    avgs$bt_upr <- avgs$met + 1.96 * avgs$se
  }
  
  out <- avgs %>% 
    tibble::tibble() %>% 
    dplyr::select(yr, met, se, bt_lwr, bt_upr, bt_met)
  
  return(out)
  
}