#' Fit a generalized additive model to a water quality time series
#'
#' Fit a generalized additive model to a water quality time series
#' 
#' @param moddat input raw data, one station and paramater 
#' @param mod chr string indicating one of \code{gam0}, \code{gam1}, \code{gam2}, or \code{gam6}, see details, 
#' @param ... additional arguments passed to other methods
#' 
#' @details 
#' 
#' One of four forms for the Generalized additive models (GAMs) can be selected to describes trends at the stations of interest.  The four models descibe the time components differently and represent increasing levels of complexity to describe the chlorophyll trend:
#'
#'\describe{
#'  \item{gam0:}{chl ~ year + s(doy)}
#'  \item{gam1:}{chl ~ year + s(doy) + s(year)}
#'  \item{gam2:}{chl ~ year + s(doy) + s(year) + ti(doy, year)}
#'  \item{gam6:}{chl ~ year + s(doy) + s(year, k = large)}
#'}
#' For all models, \code{year} is measured as a continuous numeric variable for the annual effect (e.g., January 1st, 2000 is 2000.0, July 1st, 2000 is 2000.5, etc.) and \code{doy} is the day of year as a numeric value from 1 to 366.  All models include \code{year} as a linear effect.  The functions \code{\link[mgcv]{s}} model either \code{year} or \code{doy} as a smoothed, non-linear variable and \code{\link[mgcv]{ti}} models the interaction between the two.  The fourth model, \code{gam6}, is the same as \code{gam1} with the exception that the optimal amount of smoothing on \code{year} is not constrained by increasing the theoretical upper limit on the number of knots for \code{k}.  The upper limit of \code{k} was chosen as 12 times the number of years for the input data.
#' 
#' @return a \code{\link[mgcv]{gam}} model object
#' @import mgcv
#' @export
#' 
#' @family analyze
#' 
#' @examples
#' library(dplyr)
#' tomod <- rawdat %>% 
#'   filter(station %in% 32) %>% 
#'   filter(param %in% 'chl')
#' anlz_gam(tomod, mod = 'gam2', trans = 'boxcox')
anlz_gam <- function(moddat, mod = c('gam0', 'gam1', 'gam2', 'gam6'), ...){

  if(length(unique(moddat$param)) > 1)
    stop('More than one parameter found in input data')
    
  if(length(unique(moddat$station)) > 1)
    stop('More than one station found in input data')
  
  mod <- match.arg(mod)
  
  # get transformation
  moddat <- anlz_trans(moddat, ...)
  
  frms <- c(
    'gam0' = "value ~ dec_time + s(doy, bs = 'cc')",  
    'gam1' = "value ~ dec_time + s(dec_time) + s(doy, bs = 'cc')",
    'gam2' = "value ~ dec_time + s(dec_time) + s(doy, bs = 'cc') + ti(dec_time, doy, bs = c('tp', 'cc'))",
    'gam6' = "value ~ dec_time + s(dec_time) + s(doy, bs = 'cc')"
  ) 

  frm <- frms[mod]
  kts <- NA
  
  # insert upper gamk1 rule for gam1
  if(mod %in% c('gam1', 'gam2')){
    
    # get upper bounds of knots
    kts <- moddat$yr %>%
      unique %>%
      length 
    kts <- round(kts * (2/3), 0)
    kts <- pmax(10, kts)
    
    p1 <- gsub('(^.*)s\\(dec\\_time\\).*$', '\\1', frm)
    p3 <-  gsub('^.*s\\(dec\\_time\\)(.*)$', '\\1', frm)
    p2 <- paste0('s(dec_time, k = ', kts, ')')
    frm <- paste0(p1, p2, p3)
    
  }

  # insert upper gamk1* rule for gamk1*
  if(mod %in% 'gam6'){
    
    fct <- 12
    
    # get upper bounds of knots
    kts <- fct * length(unique(moddat$yr))
    
    p1 <- gsub('(^.*)s\\(dec\\_time\\).*$', '\\1', frm)
    p3 <-  gsub('^.*s\\(dec\\_time\\)(.*)$', '\\1', frm)
    p2 <- paste0('s(dec_time, k = ', kts, ')')
    frm <- paste0(p1, p2, p3)
    
    out <- try(gam(as.formula(frm),
               knots = list(doy = c(1, 366)),
               data = moddat,
               na.action = na.exclude,
               select = T
    ))
    
    # drops upper limit on knots until it works
    while(inherits(out, 'try-error')){
      
      fct <- fct -1
      
      # get upper bounds of knots
      kts <- fct * length(unique(moddat$yr))
      
      p1 <- gsub('(^.*)s\\(dec\\_time\\).*$', '\\1', frm)
      p3 <-  gsub('^.*s\\(dec\\_time\\)(.*)$', '\\1', frm)
      p2 <- paste0('s(dec_time, k = ', kts, ')')
      frm <- paste0(p1, p2, p3)
      
      out <- try(gam(as.formula(frm),
                     knots = list(doy = c(1, 366)),
                     data = moddat,
                     na.action = na.exclude,
                     select = T
      ))
      
    }
    
    out$trans <- unique(modddat$trans)
    
    return(out)
    
  }

  out <- gam(as.formula(frm),
             knots = list(doy = c(1, 366)),
             data = moddat,
             na.action = na.exclude,
             select = T
  )
  
  # add transformation to gam object
  out$trans <- unique(moddat$trans)
  
  return(out)
  
}