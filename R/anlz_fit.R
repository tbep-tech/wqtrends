#' Return summary statistics for GAM fits
#'
#' Return summary statistics for GAM fits
#' 
#' @param moddat input raw data, one station and parameter
#' @param mods optional list of model objects
#' @param ... additional arguments passed to other methods
#'
#' @return A \code{data.frame} with summary statistics for GAM fits
#' @export
#' 
#' @details Results show the overall summary of the model as Akaike Information Criterion (\code{AIC}), the generalized cross-validation score (\code{GCV}), and the \code{R2} values.  Lower values for \code{AIC} and \code{GCV} and higher values for \code{R2} indicate improved model fit. The \code{k} column shows the upper limit for the number of knots on the \code{year} term, when appropriate (i.e., not gam0).  ANOVA F-tests are also used to compare multiple models, where results are appended as \code{F} statistics and probability values in the final two columns.  The ANOVA comparisons are row-specific, where the values show a comparison between the current row and one preceeding.  See \code{\link[mgcv]{anova.gam}} for additional info.
#'
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
#' anlz_fit(tomod, trans = 'boxcox')
#' }
#' 
#' # use previously fitted list of models
#' trans <- 'boxcox'
#' mods <- list(
#'   gam0 = anlz_gam(tomod, mod = 'gam0', trans = trans),
#'   gam1 = anlz_gam(tomod, mod = 'gam1', trans = trans), 
#'   gam2 = anlz_gam(tomod, mod = 'gam2', trans = trans)
#'   )
#' anlz_fit(mods = mods)
anlz_fit <- function(moddat = NULL, mods = NULL, ...) {
  
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

  out <- purrr::map(mods, ~ data.frame(
    AIC = AIC(.x), 
    GCV = .x$gcv.ubre,
    R2 = summary(.x)$r.sq, 
    k = gsub('^.*k = ([0-9]+)\\).*$', '\\1', as.character(.x$formula)[3])
    )) %>% 
    tibble::enframe() %>% 
    dplyr::rename(model = name) %>% 
    dplyr::mutate(
      model = factor(model, levels = levnms, labels = levnms)
    ) %>% 
    tidyr::unnest(value) %>% 
    dplyr::mutate(
      k = gsub('^[a-z].*$', '', k), 
      k= as.numeric(k)
    )

  # get pval from anova ftest 
  aovfval <- NA
  aovpval <- NA
  
  if(length(mods) == 2)
    aovcmp <- mgcv::anova.gam(mods[[1]], mods[[2]], test = 'F')
 
  if(length(mods) == 3)
    aovcmp <- mgcv::anova.gam(mods[[1]], mods[[2]], mods[[3]], test = 'F')

  if(length(mods) == 4)
    aovcmp <- mgcv::anova.gam(mods[[1]], mods[[2]], mods[[3]], mods[[4]], test = 'F')
  
  if(exists('aovcmp')){
    aovfval <- aovcmp$F
    aovpval <- aovcmp$`Pr(>F)`
  }
  
  out$F <- aovfval
  out$p.value <- aovpval

  return(out)
  
}
