#' Return summary statistics for GAM fits
#'
#' Return summary statistics for GAM fits
#' 
#' @param mod input model object as returned by \code{\link{anlz_gam}}
#'
#' @return A \code{data.frame} with summary statistics for GAM fits
#' @export
#' 
#' @details Results show the overall summary of the model as Akaike Information Criterion (\code{AIC}), the generalized cross-validation score (\code{GCV}), and the \code{R2} values.  Lower values for \code{AIC} and \code{GCV} and higher values for \code{R2} indicate improved model fit.
#'
#' @family analyze
#'
#' @examples
#' library(dplyr)
#' 
#' # data to model
#' tomod <- rawdat %>%
#'   filter(station %in% 32) %>%
#'   filter(param %in% 'chl')
#'   
#' mod <-  anlz_gam(tomod, trans = 'log10')
#' anlz_fit(mod)
anlz_fit <- function(mod) {

  out <- data.frame(
    AIC = AIC(mod), 
    GCV = mod$gcv.ubre,
    R2 = summary(mod)$r.sq
    )

  return(out)
  
}
