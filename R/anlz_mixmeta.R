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
#' # fit models with function
#' tomod <- rawdat %>%
#'   filter(station %in% 32) %>%
#'   filter(param %in% 'chl')
#' trans <- 'boxcox'
#' mods <- list(
#'   gam0 = anlz_gam(tomod, mod = 'gam0', trans = trans),
#'   gam1 = anlz_gam(tomod, mod = 'gam1', trans = trans), 
#'   gam2 = anlz_gam(tomod, mod = 'gam2', trans = trans)
#'   )
#' avgseason <- anlz_avgseason(mods = mods, doystr = 90, doyend = 180)
#' anlz_mixmeta(avgseason, yrstr = 2000, yrend = 2017)
anlz_mixmeta <- function(avgseason, yrstr = 2000, yrend = 2017){

  # input
  totrnd <- avgseason %>% 
    dplyr::mutate(S = se^2) %>% 
    dplyr::filter(yr %in% seq(yrstr, yrend))

  out <- totrnd %>%
    dplyr::group_by(model) %>%
    tidyr::nest() %>%
    dplyr::mutate(
      mixmod = purrr::map(data, function(x){
        
        if(nrow(x) != length(seq(yrstr, yrend)))
          next()
        
        mixmeta::mixmeta(predicted ~ yr, S = S, random = ~1|yr, data = x, method = 'reml')
        
      })
    ) %>% 
    dplyr::select(-data) %>% 
    tibble::deframe()
    
  return(out)

}
