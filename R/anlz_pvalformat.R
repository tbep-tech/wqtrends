#' Format p-values for show functions
#'
#' @param x numeric input p-value
#'
#' @return p-value formatted as a text string, one of \code{p < 0.001}, \code{'p < 0.01'}, \code{p < 0.05}, or \code{ns} for not significant
#' @export
#'
#' @concept analyze
#'
#' @examples
#' anlz_pvalformat(0.05)
anlz_pvalformat <- function(x){
  
  sig_cats <- c('p < 0.001', 'p < 0.01', 'p < 0.05', 'ns')
  sig_vals <- c(-Inf, 0.001, 0.01, 0.05, Inf)
  
  out <- cut(x, breaks = sig_vals, labels = sig_cats, right = FALSE)
  out <- as.character(out)
  
  return(out)
  
}