#' Plot seasonal rates of change based on average estimates for multiple window widths
#'
#' Plot seasonal rates of change based on average estimates for multiple window widths
#' 
#' @param mod input model object as returned by \code{\link{anlz_gam}}
#' @param doystr numeric indicating start Julian day for extracting averages
#' @param doyend numeric indicating ending Julian day for extracting averages
#' @param yromit optional numeric vector for years to omit from the plot, see details
#' @param justify chr string indicating the justification for the trend window
#' @param win numeric vector indicating number of years to use for the trend window
#' @param txtsz numeric for size of text labels inside the plot
#' @param cols vector of low/high colors for trends
#' @param base_size numeric indicating base font size, passed to \code{\link[ggplot2]{theme_bw}}
#'
#' @return A \code{\link[ggplot2]{ggplot2}} plot 
#' @export
#'
#' @concept show
#'
#' @details This function plots output from \code{\link{anlz_sumtrndseason}}.
#' 
#' The optional \code{yromit} vector can be used to omit years from the plot and trend assessment. This may be preferred if seasonal estimates for a given year have very wide confidence intervals likely due to limited data, which can skew the trend assessments.
#' 
#' @family show
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
#' show_sumtrndseason(mod, doystr = 90, doyend = 180, justify = 'center', win = 2:3)
show_sumtrndseason <- function(mod, doystr = 1, doyend = 364, yromit = NULL, 
                              justify = c('center', 'left', 'right'), 
                              win = 5:15, txtsz = 6, cols = c('lightblue', 'lightgreen'), 
                              base_size = 11){
  
  justify <- match.arg(justify)
  
  sig_cats <- c('**', '*', '')
  sig_vals <- c(-Inf, 0.005, 0.05, Inf)
  
  # get ests across all window widths
  res <- anlz_sumtrndseason(mod, doystr = doystr, doyend = doyend, justify = justify, win = win, yromit = yromit)
  
  # seasonal range for title
  dts <- as.Date(c(doystr, doyend), origin = as.Date("2000-12-31"))
  strt <- paste(lubridate::month(dts[1], label = T, abbr = T), lubridate::day(dts[1]))
  ends <- paste(lubridate::month(dts[2], label = T, abbr = T), lubridate::day(dts[2]))

  # subtitle
  subttl <- paste0('Estimates based on ', justify, ' window')
  
  # legend title, title
  legttl <- 'Change/yr'
  ttl <- paste0('Annual slopes for seasonal average trends: ', strt, '-',  ends)
  if(mod$trans == 'log10'){
    legttl <- paste0('log-', tolower(legttl))
    ttl <- paste0('Annual log-slopes for seasonal average trends: ', strt, '-',  ends)
  }
  
  toplo <- res %>% 
    dplyr::mutate(
      psig = cut(pval, breaks = sig_vals, labels = sig_cats, right = FALSE), 
      psig = as.character(psig)
    )
  
  p <- ggplot2::ggplot(toplo, ggplot2::aes(x = yr, y = win, fill = yrcoef)) +
    ggplot2::geom_tile(color = 'black', na.rm = TRUE) + 
    ggplot2::geom_text(ggplot2::aes(label = psig), size = txtsz, na.rm = TRUE) + 
    ggplot2::scale_x_continuous(expand = c(0, 0)) + 
    ggplot2::scale_y_continuous(expand = c(0, 0), breaks = win) +
    ggplot2::scale_fill_gradient2(low = cols[1], mid = 'white', high = cols[2], midpoint = 0) +
    ggplot2::theme_bw(base_size = base_size) + 
    ggplot2::theme(
      legend.position = 'top',
    ) + 
    ggplot2::guides(fill = ggplot2::guide_colourbar(barwidth = 10, barheight = 0.5)) +
    ggplot2::labs(
      fill = legttl,
      title = ttl, 
      subtitle = subttl,
      x = NULL,
      y = 'Year window', 
      caption = '* p< 0.05, ** p < 0.005'
    )
  
  return(p)
  
}
