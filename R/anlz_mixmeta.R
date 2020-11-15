#' Fit a mixed meta-analysis regression model of trends
#' 
#' Fit a mixed meta-analysis regression model of trends
#' 
#' @param avgseason output from \code{\link{anlz_avgseason}}
#' @param yrstr numeric for starting year
#' @param yrend numeric for ending year
#'
#' @return A list of \code{\link[mixmeta]{mixmeta}} fitted model objects
#' @export
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
#' avgseason <- anlz_avgseason(mod, doystr = 90, doyend = 180)
#' anlz_mixmeta(avgseason, yrstr = 2000, yrend = 2019)
anlz_mixmeta <- function(avgseason, yrstr = 2000, yrend = 2019){

  # input
  totrnd <- avgseason %>% 
    dplyr::mutate(S = se^2) %>% 
    dplyr::filter(yr %in% seq(yrstr, yrend))

  if(nrow(totrnd) != length(seq(yrstr, yrend)))
    return(NA)
  
  out <- mixmeta::mixmeta(avg ~ yr, S = S, random = ~1|yr, data = totrnd, method = 'reml')
    
  return(out)

}
