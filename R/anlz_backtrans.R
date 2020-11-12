#' Back-transform response variable
#' 
#' Back-transform response variable after fitting GAM
#' 
#' @param dat input data with \code{trans} argument
#'
#' @return \code{dat} with the \code{value} column back-transformed using info from the \code{trans} column
#' @export
#' 
#' @details \code{dat} can be output from \code{\link{anlz_trans}} or \code{\link{anlz_prd}}
#' 
#' @family analyze
#' 
#' @examples
#' library(dplyr)
#' 
#' tomod <- rawdat %>% 
#'   filter(station %in% 32) %>% 
#'   filter(param %in% 'chl')
#' dat <- anlz_trans(tomod, trans = 'log10')
#' anlz_backtrans(dat)
#' 
#' trans <- 'log10'
#' mods <- list(
#'   gam0 = anlz_gam(tomod, mod = 'gam0', trans = trans),
#'   gam1 = anlz_gam(tomod, mod = 'gam1', trans = trans), 
#'   gam2 = anlz_gam(tomod, mod = 'gam2', trans = trans)
#'   )
#' dat <- anlz_prd(mods = mods)
#' anlz_backtrans(dat)
anlz_backtrans <- function(dat){
  
  if(!'trans' %in% names(dat))
    stop('trans info not found in dat')
  
  trans <- unique(dat$trans)

  # log
  if(trans == 'log10')
    dat <- dat %>% 
      dplyr::mutate_if(grepl('value', names(.)), ~10 ^ .)
  
  return(dat)
  
}