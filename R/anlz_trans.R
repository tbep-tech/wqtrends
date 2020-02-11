#' Transform response variable
#' 
#' Transform response variable prior to fitting GAM
#' 
#' @param rawdat input raw data, one station and paramater
#' @param trans chr string indicating desired type of transformation, one of \code{boxcox}, \code{log10}, or \code{ident} (no transformation)
#'
#' @return \code{rawdat} with the \code{value} column transformed as indicated
#' @export
#'
#' @importFrom MASS boxcox
#' 
#' @family analyze
#' 
#' @examples
#' library(dplyr)
#' tomod <- rawdat %>% 
#'   filter(station %in% 32) %>% 
#'   filter(param %in% 'chl')
#' anlz_trans(tomod, trans = 'boxcox')
anlz_trans <- function(rawdat, trans = c('boxcox', 'log10', 'ident')){

  if(length(unique(rawdat$param)) > 1)
    stop('More than one parameter found in input data')
  
  if(length(unique(rawdat$station)) > 1)
    stop('More than one station found in input data')
  
  trans <- match.arg(trans)
  
  if(trans == 'log10')
    rawdat <- rawdat %>% 
      dplyr::mutate(
        value = log10(value)
      )
  
  if(trans == 'box'){
    bc <- boxcox(value ~ 1, data = rawdat, lambda = seq(-4, 4, 1/10), plotit = FALSE)
    lamb <- bc$x[which.max(bc$y)]
  
    rawdat <- rawdat %>% 
      dplyr::mutate(
        value = (value ^ lamb - 1)/lamb
      )
    
  }
  
  return(rawdat)
  
}