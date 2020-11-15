#' Return summary statistics for smoothers of GAMs
#'
#' Return summary statistics for smoothers of GAMs
#' 
#' @param mod input model object as returned by \code{\link{anlz_gam}}
#'
#' @return a \code{data.frame} with summary statistics for smoothers in each GAM
#' @export
#' 
#' @details Results show the individual effects of the modelled components of each model as the estimated degrees of freedom (\code{edf}), the reference degrees of freedom (\code{Ref.df}), the test statistic (\code{F}), and significance of the component (\code{p-value}).  The significance of the component is in part based on the difference between \code{edf} and \code{Ref.df}. 
#' 
#' @family analyze
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
#' anlz_smooth(mod)
anlz_smooth <- function(mod) {

  out <- summary(mod)$s.table %>% 
    data.frame %>% 
    tibble::rownames_to_column('smoother')
  
  return(out)
  
}
