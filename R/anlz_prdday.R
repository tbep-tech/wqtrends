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
#'   filter(param %in% 'chl') %>% 
#'   filter(yr > 2015)
#'
#' mod <- anlz_gam(tomod, trans = 'log10')
#' anlz_prdday(mod)
anlz_prdday <- function(mod) {
  
  # get daily predictions, differs from anlz_prd
  rng <- mod$model$cont_year %>%
    range(na.rm  = T) %>% 
    lubridate::date_decimal() %>% 
    as.Date
  data <- seq.Date(lubridate::floor_date(rng[1], 'year'), lubridate::ceiling_date(rng[2], 'year'), by = 'days') %>%
    tibble::tibble(date = .) %>%
    dplyr::mutate(
      doy = lubridate::yday(date),
      cont_year = lubridate::decimal_date(date),
      yr = lubridate::year(date)
    )
  prd <- predict(mod, newdata = data)
  out <- data.frame(data, value = prd, trans = mod$trans, stringsAsFactors = F) %>% 
    anlz_backtrans()
  
  return(out)
      
}