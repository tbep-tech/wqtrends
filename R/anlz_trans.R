#' Transform response variable
#' 
#' Transform response variable prior to fitting GAM
#' 
#' @param moddat input raw data, one station and paramater
#' @param trans chr string indicating desired type of transformation, one of \code{boxcox}, \code{log10}, or \code{ident} (no transformation)
#'
#' @return \code{moddat} with the \code{value} column transformed as indicated
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
anlz_trans <- function(moddat, trans = c('boxcox', 'log10', 'ident')){

  if(length(unique(moddat$param)) > 1)
    stop('More than one parameter found in input data')
  
  if(length(unique(moddat$station)) > 1)
    stop('More than one station found in input data')
  
  trans <- match.arg(trans)
  
  if(trans == 'log10')
    moddat <- moddat %>% 
      dplyr::mutate(
        value = log10(value)
      )

  if(trans == 'boxcox'){
    bc <- boxcox(value ~ 1, data = moddat, lambda = seq(-4, 4, 1/100), plotit = FALSE)
    lamb <- bc$x[which.max(bc$y)]
  
    trans <- lamb
    moddat <- moddat %>% 
      dplyr::mutate(
        # value = (value ^ lamb - 1)/lamb,
        value = forecast::BoxCox(value, lamb)
      )
    
  }
  
  moddat <- moddat %>% 
    dplyr::mutate(
      trans = trans
    )
  
  return(moddat)
  
}