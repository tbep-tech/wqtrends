#' Return summary statistics for smoothers of all GAMs
#'
#' Return summary statistics for smoothers of all GAMs
#' 
#' @param rawdat input raw data, one station and paramater
#' @param mods optional list of model objects
#' @param ... additional arguments passed to other methods
#'
#' @return a \code{data.frame} with summary statistics for smoothers in each GAM
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
#' 
#' anlz_smooth(tomod, trans = 'boxcox')
#' 
#' # use previously fitted list of models
#' trans <- 'boxcox'
#' mods <- list(
#'   gam0 = anlz_gam(tomod, mod = 'gam0', trans = trans),
#'   gam1 = anlz_gam(tomod, mod = 'gam1', trans = trans), 
#'   gam2 = anlz_gam(tomod, mod = 'gam2', trans = trans)
#'   )
#' anlz_smooth(mods = mods)
anlz_smooth <- function(rawdat = NULL, mods = NULL, ...) {
  
  if(is.null(rawdat) & is.null(mods))
    stop('Must supply one of rawdat or mods')
  
  if(is.null(mods)){
    
    mods <- list(
      gam0 = anlz_gam(rawdat, mod = 'gam0', ...),
      gam1 = anlz_gam(rawdat, mod = 'gam1', ...), 
      gam2 = anlz_gam(rawdat, mod = 'gam2', ...), 
      gam6 = anlz_gam(rawdat, mod = 'gam6', ...)
      ) 
    
   levnms <- c('gam0', 'gam1', 'gam2', 'gam6') 
   
  }
  
  if(!is.null(mods))
    levnms <- names(mods)
  
  out <- purrr::map(mods, ~ summary(.x)$s.table %>% data.frame %>% tibble::rownames_to_column('smoother')) %>% 
      tibble::enframe('model', 'value') %>% 
      dplyr::mutate(model = factor(model, levels = levnms, labels = levnms)) %>% 
      tidyr::unnest(value)
  
  return(out)

}
