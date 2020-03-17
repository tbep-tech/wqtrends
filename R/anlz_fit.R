#' Return summary statistics for GAM fits
#'
#' Return summary statistics for GAM fits
#' 
#' @param moddat input raw data, one station and parameter
#' @param mods optional list of model objects
#' @param ... additional arguments passed to other methods
#'
#' @return a \code{data.frame} with summary statistics for GAM fits
#' @export
#' 
#' @family analyze
#'
#' @examples
#' \dontrun{
#' library(dplyr)
#' 
#' # fit models with function
#' tomod <- rawdat %>%
#'   filter(station %in% 32) %>%
#'   filter(param %in% 'chl')
#' 
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
  
  return(out)
  
}
