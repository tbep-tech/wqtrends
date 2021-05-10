#' Transform response variable
#' 
#' Transform response variable prior to fitting GAM
#' 
#' @param moddat input raw data, one station and paramater
#' @param trans chr string indicating desired type of transformation, one of \code{log10} or \code{ident} (no transformation)
#'
#' @return \code{moddat} with the \code{value} column transformed as indicated
#' @export
#' 
#' @concept analyze
#' 
#' @family analyze
#' 
#' @examples
#' library(dplyr)
#' tomod <- rawdat %>% 
#'   filter(station %in% 34) %>% 
#'   filter(param %in% 'chl')
#' anlz_trans(tomod, trans = 'log10')
anlz_trans <- function(moddat, trans = c('log10', 'ident')){

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
  
  moddat <- moddat %>% 
    dplyr::mutate(
      trans = trans
    )
  
  return(moddat)
  
}