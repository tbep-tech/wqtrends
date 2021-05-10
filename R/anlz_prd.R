#' Get predicted data from fitted GAMs across period of observation
#'
#' Get predicted data from fitted GAMs across period of observation
#' 
#' @param mod input model object as returned by \code{\link{anlz_gam}}
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
#' anlz_prd(mod)
anlz_prd <- function(mod) {

  prddat <- mod$model
  trans <- mod$trans
  
  prddat <- data.frame(
    cont_year = seq(min(prddat$cont_year), max(prddat$cont_year), length = 1000)
    ) %>%
    dplyr::mutate(
      date = lubridate::date_decimal(cont_year),
      date = as.Date(date),
      mo = lubridate::month(date, label = TRUE),
      doy = lubridate::yday(date),
      yr = lubridate::year(date)
    )

  # get predictions from terms matrix, value is sum of all plus intercept, annvalue is same minus anything with doy
  prd <- predict(mod, newdata = prddat, type = 'terms')
  int <- attr(prd, 'constant')
  value <- rowSums(prd) + int
  # annvalue <- rowSums(prd[, !grepl('doy', colnames(prd)), drop = FALSE]) + int
  
  # get annual trend
  out <- prddat %>% 
    dplyr::mutate(
      # annvalue = annvalue,
      value = value, 
      trans = mod$trans
      ) %>% 
    anlz_backtrans()

  return(out)
  
}