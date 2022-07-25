#' Get predicted data from fitted GAMs across period of observation, every day
#'
#' Get predicted data from fitted GAMs across period of observation, every day
#' 
#' @inheritParams anlz_prd
#'
#' @return a \code{data.frame} with predictions
#' @export
#' 
#' @concept analyze
#'
#' @examples
#' library(dplyr)
#' 
#' # data to model
#' tomod <- rawdat %>%
#'   filter(station %in% 34) %>%
#'   filter(param %in% 'chl')
#'
#' mod <- anlz_gam(tomod, trans = 'log10')
#' anlz_prdday(mod)
anlz_prdday <- function(mod) {
  
  data <- mod$model %>% 
    dplyr::mutate(
      date = lubridate::date_decimal(cont_year),
      doy = lubridate::yday(date),
      yr = lubridate::year(date)
    )
  prd <- predict(mod, newdata = mod$model)
  out <- data.frame(data, value = prd, trans = mod$trans, stringsAsFactors = F) %>% 
    anlz_backtrans()
  
  return(out)
      
}