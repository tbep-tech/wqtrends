#' Get predicted data from fitted GAMs across period of observation
#'
#' Get predicted data from fitted GAMs across period of observation
#' 
#' @param moddat input raw data, one station and parameter
#' @param mods optional list of model objects
#' @param ... additional arguments passed to other methods
#'
#' @return a \code{data.frame} with predictions
#' @export
#' 
#' @family analyze
#'
#' @examples
#' library(dplyr)
#' 
#' # get predictions for all four gams
#' tomod <- rawdat %>%
#'   filter(station %in% 32) %>%
#'   filter(param %in% 'chl')
#' \dontrun{
#' anlz_prd(tomod, trans = 'boxcox')
#' }
#' # use previously fitted list of models
#' trans <- 'boxcox'
#' mods <- list(
#'   gam0 = anlz_gam(tomod, mod = 'gam0', trans = trans),
#'   gam1 = anlz_gam(tomod, mod = 'gam1', trans = trans), 
#'   gam2 = anlz_gam(tomod, mod = 'gam2', trans = trans)
#'   )
#' anlz_prd(mods = mods)
anlz_prd <- function(moddat = NULL, mods = NULL, ...) {

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
    
    prddat <- mod$model
    trans <- mod$trans
    
    prddat <- data.frame(
      dec_time = seq(min(prddat$dec_time), max(prddat$dec_time), length = 1000)
      ) %>%
      dplyr::mutate(
        date = lubridate::date_decimal(dec_time),
        date = as.Date(date),
        mo = lubridate::month(date, label = TRUE),
        doy = lubridate::yday(date),
        yr = lubridate::year(date)
      )
    
    prd <- predict(mod, newdata = prddat)
    
    prddat <- prddat %>% 
      dplyr::mutate(
        value = prd,
        trans = trans
        )
    
    return(prddat)
    
    }) %>% 
    tibble::enframe('model', 'data') %>% 
    tidyr::unnest('data')
    
  return(out)
  
}