#' Fit a generalized additive model to a water quality time series
#'
#' Fit a generalized additive model to a water quality time series
#' 
#' @param moddat input raw data, one station and paramater 
#' @param kts optional numeric vector for the upper limit for the number of knots in the term \code{s(cont_year)}, see details
#' @param ... additional arguments passed to other methods
#' 
#' @details 
#' 
#' The model structure is as follows:
#'
#'\describe{
#'  \item{model S:}{chl ~ s(cont_year, k = large)}
#'}
#' The \code{cont_year} vector is measured as a continuous numeric variable for the annual effect (e.g., January 1st, 2000 is 2000.0, July 1st, 2000 is 2000.5, etc.) and \code{doy} is the day of year as a numeric value from 1 to 366.  The function \code{\link[mgcv]{s}} models \code{cont_year} as a smoothed, non-linear variable. The optimal amount of smoothing on \code{cont_year} is determined by cross-validation as implemented in the mgcv package and an upper theoretical upper limit on the number of knots for \code{k} should be large enough to allow sufficient flexibility in the smoothing term.  The upper limit of \code{k} was chosen as 12 times the number of years for the input data. If insufficient data are available to fit a model with the specified \code{k}, the number of knots is decreased until the data can be modelled, e.g., 11 times the number of years, 10 times the number of years, etc. 
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
#'   filter(station %in% 34) %>% 
#'   filter(param %in% 'chl')
#' anlz_gam(tomod, trans = 'log10')
anlz_gam <- function(moddat, kts = NULL, ...){

  if(length(unique(moddat$param)) > 1)
    stop('More than one parameter found in input data')
    
  if(length(unique(moddat$station)) > 1)
    stop('More than one station found in input data')
  
  # get transformation
  moddat <- anlz_trans(moddat, ...)
  
  frm <- "value ~ s(cont_year)"

  fct <- 12
  
  # get upper bounds of knots
  if(is.null(kts))
    kts <- fct * length(unique(moddat$yr))
  
  p1 <- gsub('(^.*)s\\(cont\\_year\\).*$', '\\1', frm)
  p2 <- paste0('s(cont_year, k = ', kts, ')')
  frmin <- paste0(p1, p2)
  
  out <- try(gam(as.formula(frmin),
             data = moddat,
             na.action = na.exclude,
             select = F
  ))
  
  # drops upper limit on knots until it works
  while(inherits(out, 'try-error')){
    
    fct <- fct -1
    
    # get upper bounds of knots
    kts <- fct * length(unique(moddat$yr))
    
    p1 <- gsub('(^.*)s\\(cont\\_year\\).*$', '\\1', frm)
    p2 <- paste0('s(cont_year, k = ', kts, ')')
    frmin <- paste0(p1, p2)
    
    out <- try(gam(as.formula(frmin),
                   data = moddat,
                   na.action = na.exclude,
                   select = F
    ))
    
  }
    
  out$trans <- unique(moddat$trans)
    
  return(out)

  
}
