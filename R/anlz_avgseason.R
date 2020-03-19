#' Extract period (seasonal) averages from fitted GAM
#' 
#' Extract period (seasonal) averages from fitted GAM
#' 
#' @param moddat input raw data, one station and paramater
#' @param mods optional list of model objects
#' @param doystr numeric indicating start Julian day for extracting averages
#' @param doyend numeric indicating ending Julian day for extracting averages
#' @param ... additional arguments passed to other methods
#'
#' @return A data frame of period averages
#' @export
#'
#' @family analyze
#' 
#' @examples
#' library(dplyr)
#' 
#' # fit models with function
#' tomod <- rawdat %>%
#'   filter(station %in% 32) %>%
#'   filter(param %in% 'chl')
#' \dontrun{
#' anlz_avgseason(tomod, trans = 'boxcox', doystr = 90, doyend = 180)
#' }
#' # use previously fitted list of models
#' trans <- 'boxcox'
#' mods <- list(
#'   gam0 = anlz_gam(tomod, mod = 'gam0', trans = trans),
#'   gam1 = anlz_gam(tomod, mod = 'gam1', trans = trans), 
#'   gam2 = anlz_gam(tomod, mod = 'gam2', trans = trans)
#'   )
#' anlz_avgseason(mods = mods, doystr = 90, doyend = 180)
anlz_avgseason <- function(moddat = NULL, mods = NULL, doystr = 1, doyend = 364, ...) {

  if(is.null(moddat) & is.null(mods))
    stop('Must supply one of moddat or mods')
  
  if(is.null(mods)){
    
    mods <- list(
      gam0 = anlz_gam(moddat, mod = 'gam0', ...),
      gam1 = anlz_gam(moddat, mod = 'gam1', ...), 
      gam2 = anlz_gam(moddat, mod = 'gam2', ...), 
      gam6 = anlz_gam(moddat, mod = 'gam6', ...)
    ) 
    
    levnms <- c('gam0', 'gam1', 'gam2', 'gam6') 
    
  }
  
  if(!is.null(mods))
    levnms <- names(mods)
  
  out <- purrr::map(mods, function(mod){

    # gam model data
    gamdat <- mod$model %>% 
      dplyr::mutate(
        date = lubridate::date_decimal(dec_time), 
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
    fillData$dec_time <- fillData$yr + (fillData$doy - 1)/366
    centerYear <- mean(range(fillData$dec_time, na.rm=FALSE))
    fillData$cyr <- fillData$dec_time - centerYear
    
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
    avgs <- data.frame(predicted = means, se = ses, yr = yr)
    
    # backtransform
    if(trans == 'log10'){
      avgs$predicted <- 10^avgs$predicted
      avgs$se <- 10^avgs$se
    }
    if(is.numeric(trans)){
      avgs$predicted <- forecast::InvBoxCox(avgs$predicted, trans)
      avgs$se <- forecast::InvBoxCox(avgs$se, trans)
    }
    
    return(avgs)
    
  }) %>% 
  tibble::enframe('model', 'data') %>% 
  tidyr::unnest('data')
  
  return(out)
  
}