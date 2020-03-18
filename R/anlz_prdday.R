#' Get predicted data from fitted GAMs across period of observation, every day
#'
#' Get predicted data from fitted GAMs across period of observation, every day
#' 
#' @inheritParams anlz_prd
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
#' anlz_prdday(tomod, trans = 'boxcox')
#' }
#' # use previously fitted list of models
#' trans <- 'boxcox'
#' mods <- list(
#'   gam0 = anlz_gam(tomod, mod = 'gam0', trans = trans),
#'   gam1 = anlz_gam(tomod, mod = 'gam1', trans = trans), 
#'   gam2 = anlz_gam(tomod, mod = 'gam2', trans = trans)
#'   )
#' anlz_prdday(mods = mods)
anlz_prdday <- function(moddat = NULL, mods = NULL, ...) {
  
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
  
  # get daily predictions, differs from anlz_prd
  out <- mods %>%
    tibble::enframe('model', 'modv') %>% 
    dplyr::mutate(prddat = purrr::map(modv, function(modv){

      rng <- modv$model$dec_time %>%
        range(na.rm  = T) %>% 
        lubridate::date_decimal() %>% 
        as.Date
      data <- seq.Date(lubridate::floor_date(rng[1], 'year'), lubridate::ceiling_date(rng[2], 'year'), by = 'days') %>%
        tibble::tibble(date = .) %>%
        dplyr::mutate(
          doy = lubridate::yday(date),
          dec_time = lubridate::decimal_date(date),
          yr = lubridate::year(date)
        )
      prd <- predict(modv, newdata = data)
      prddat <- data.frame(data, value = prd, trans = modv$trans, stringsAsFactors = F)
      
      return(prddat)
      
    })
    ) %>%
    dplyr::select(model, prddat) %>%
    tidyr::unnest(prddat)
  
  return(out)
  
}