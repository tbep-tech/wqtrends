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

  # gam model data
  gamdat <- mod$model %>% 
    dplyr::mutate(
      date = lubridate::date_decimal(cont_year), 
      date = as.Date(date)
    )
  
  # transformation
  trans <- mod$trans
  
  # prep prediciton data
  numDays <- doyend - doystr + 1
  gamdat$julian <- julian(gamdat$date)
  fillData <- data.frame(julian = min(gamdat$julian):max(gamdat$julian))
  fillData$date <- as.Date(fillData$julian, origin = as.Date("1970-01-01"))
  fillData$yr <- lubridate::year(fillData$date)
  fillData$fyr <- factor(fillData$yr)
  fillData$doy <- fillData$julian - julian(update(fillData$date, month = 1, mday = 1))
  fillData$cont_year <- fillData$yr + (fillData$doy - 1)/366
  centerYear <- mean(range(fillData$cont_year, na.rm=FALSE))
  fillData$cyr <- fillData$cont_year - centerYear
  
  ## Exclude days not in the desired range
  fillData <- subset(fillData, doy >= doystr & doy <= doyend)
  
  ## Exclude years that do not include all relevant days (i.e. start or end year)
  dayCounts <- table(fillData$yr)
  incompleteYear <- as.integer(names(dayCounts)[dayCounts != numDays])
  numYears <- length(dayCounts)-length(incompleteYear)
  fillData <- subset(fillData, !(yr %in% incompleteYear))
  yr <- as.integer(names(dayCounts)[dayCounts == numDays])
  
  ## See Examples section of help(predict.gam)
  Xp <- predict(mod, newdata = fillData, type = "lpmatrix")
  coefs <- coef(mod)
  A <- kronecker(diag(numYears), matrix(rep(1/numDays, numDays), nrow = 1))
  Xs <- A %*% Xp
  means <- as.numeric(Xs %*% coefs)
  ses <- sqrt(diag(Xs %*% mod$Vp %*% t(Xs)))
  avgs <- data.frame(avg = means, se = ses, yr = yr)

  # backtransform, add lwr/upr confidence intervals
  dispersion <- summary(mod)$dispersion
  
  if(trans == 'log10'){
    avgs$bt_lwr <- 10^((avgs$avg - 1.96 * avgs$se) + log(10) * dispersion / 2)
    avgs$bt_upr <- 10^((avgs$avg + 1.96 * avgs$se) + log(10) * dispersion / 2)
    avgs$bt_avg <- 10^(avgs$avg + log(10) * dispersion / 2)
  }
  if(trans == 'ident'){
    avgs$bt_avg <- avgs$avg
    avgs$bt_lwr <- avgs$avg - 1.96 * avgs$se
    avgs$bt_upr <- avgs$avg + 1.96 * avgs$se
  }
  
  out <- avgs
  
  return(out)
    
}