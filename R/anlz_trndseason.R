#' Estimate seasonal rates of change based on average estimates
#'
#' Estimate seasonal rates of change based on average estimates
#' 
#' @param moddat input raw data, one station and paramater
#' @param mods optional list of model objects
#' @param doystr numeric indicating start Julian day for extracting averages
#' @param doyend numeric indicating ending Julian day for extracting averages
#' @param justify chr string indicating the justification for the trend window
#' @param win numeric indicating number of years to use for the trend window
#' @param ... additional arguments passed to other methods
#'
#' @return A data frame of slope estimates and p-values for each year
#' @export
#'
#' @details Trends are based on the slope of the fitted linear trend within the window, where the linear trend is estimated using a meta-analysis regression model (from \code{\link{anlz_mixmeta}}) for the seasonal averages (from \code{\link{anlz_avgseason}})
#' @family analyze
#' 
#' @examples
#' library(dplyr)
#' 
#' # fit models with function
#' tomod <- rawdat %>%
#'   filter(station %in% 32) %>%
#'   filter(param %in% 'chl')
#' \dontrun{
#' anlz_trndseason(tomod, trans = 'boxcox', doystr = 90, doyend = 180, justify = 'left', win = 5)
#' }
#' # use previously fitted list of models
#' trans <- 'boxcox'
#' mods <- list(
#'   gam0 = anlz_gam(tomod, mod = 'gam0', trans = trans),
#'   gam1 = anlz_gam(tomod, mod = 'gam1', trans = trans), 
#'   gam2 = anlz_gam(tomod, mod = 'gam2', trans = trans)
#'   )
#' anlz_trndseason(mods = mods, trans = 'boxcox', doystr = 90, doyend = 180, justify = 'left', win = 5)
anlz_trndseason <- function(moddat = NULL, mods = NULL, doystr = 1, doyend = 364, justify = c('left', 'right', 'center'), win = 5, ...){
  
  # get seasonal averages
  avgseason <- anlz_avgseason(moddat = moddat, mods = mods, doystr = doystr, doyend = doyend) 

  justify <- match.arg(justify)

  # iterate through each model
  out <- avgseason %>% 
    dplyr::group_by(model) %>% 
    tidyr::nest() %>% 
    dplyr::mutate(
      data = purrr::pmap(list(model, data), function(model, data){
  
        tmp <- tibble::tibble(model = model, data)
        tmp$yrcoef <- NaN
        tmp$pval <- NaN
        
        # iterate through years to get trend
        for(i in seq_along(tmp$yr)){
          
          yr <- tmp$yr[i]
   
          if(justify == 'left')
            mixmet <- try(anlz_mixmeta(tmp, yrstr = yr, yrend = yr + win - 1)[[1]], silent = TRUE)
          
          if(justify == 'right')
            mixmet <- try(anlz_mixmeta(tmp, yrstr = yr - win + 1, yrend = yr)[[1]], silent = TRUE)
          
          if(justify == 'center')
            mixmet <- try(anlz_mixmeta(tmp, yrstr = round(yr - win / 2), yrend = round(yr + win / 2))[[1]], silent = TRUE)
          
          if(inherits(mixmet, 'try-error'))
            next
          
          tmp[i, 'yrcoef'] <- mixmet$coefficients['yr']
          tmp[i, 'pval'] <- coefficients(summary(mixmet)) %>% data.frame %>% .[2, 4]
          
        }
        
        tmp <- tmp %>% 
          dplyr::select(-model)
        
        return(tmp)
        
      })
    ) %>% 
    tidyr::unnest('data')

  return(out)
  
}