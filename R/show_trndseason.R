#' Plot seasonal rates of change based on average estimates
#'
#' Plot seasonal rates of change based on average estimates
#' 
#' @inheritParams anlz_trndseason
#' @param ylab chr string for y-axis label
#' @param gami Character indicating which GAM to plot, one of \code{gam0}, \code{gam1}, \code{gam2}, or \code{gam3}
#'
#' @return A \code{\link[ggplot2]{ggplot}} object
#' @export
#' 
#' @family show
#'
#' @examples
#' library(dplyr)
#' 
#' # get predictions for all four gams
#' tomod <- rawdat %>%
#'   filter(station %in% 32) %>%
#'   filter(param %in% 'chl')
#' \dontrun{
#' show_trndseason(tomod, trans = 'log10', doystr = 90, doyend = 180, justify = 'left', win = 5,
#'      ylab = 'Slope chlorophyll-a (ug/L)', gami = 'gam2')
#' }
#' # use previously fitted list of models
#' trans <- 'log10'
#' mods <- list(
#'   gam2 = anlz_gam(tomod, mod = 'gam2', trans = trans)
#'   )
#' show_trndseason(mods = mods, trans = 'log10', doystr = 90, doyend = 180, justify = 'left', win = 5,
#'      ylab = 'Slope Chlorophyll-a (ug/L)', gami = 'gam2')
show_trndseason <- function(moddat = NULL, mods = NULL, doystr = 1, doyend = 364, justify = c('left', 'right', 'center'), win = 5, ylab, gami = c('gam0', 'gam1', 'gam2', 'gam6'), ...) {
  
  if(is.null(moddat) & is.null(mods))
    stop('Must supply one of moddat or mods')
  
  if(is.null(mods)){
    
    # gam to fit
    gami <- match.arg(gami)
    
    mods <- list(anlz_gam(moddat, mod = gami, ...))
    names(mods) <- gami
    
  }
  
  if(!is.null(mods))
    stopifnot(length(mods) == 1)
  
  justify <- match.arg(justify)
  
  # get slope trends
  trndseason <- anlz_trndseason(moddat = moddat, mods = mods, doystr = doystr, doyend = doyend, justify = justify, win = win) 

  # title
  dts <- as.Date(c(doystr, doyend), origin = as.Date("2000-12-31"))
  strt <- paste(lubridate::month(dts[1], label = T, abbr = T), lubridate::day(dts[1]))
  ends <- paste(lubridate::month(dts[2], label = T, abbr = T), lubridate::day(dts[2]))
  ttl <- paste0('Annual Slope estimates for seasonal trends: ', strt, '-',  ends)
  
  # subtitle
  subttl <- paste0('Estimates based on ', justify , ' window of ', win, ' years')
  
  # year range
  yrrng <- range(trndseason$yr, na.rm = T)
  
  # to plot, no NA
  toplo <- trndseason %>% 
    dplyr::mutate(
      pval = dplyr::case_when(
          pval < 0.05 ~ 'p < 0.05', 
          T ~ 'ns'
        ), 
      pval = factor(pval, levels = c('ns', 'p < 0.05'))
      ) %>% 
    na.omit()
  
  # plot output
  p <- ggplot2::ggplot(data = toplo, ggplot2::aes(x = yr, y = yrcoef, fill = pval)) + 
    ggplot2::geom_point(shape = 21, size = 3) +
    ggplot2::scale_x_continuous(limits = yrrng) +
    ggplot2::scale_fill_manual(values = c(NA, 'tomato1'), drop = FALSE) +
    ggplot2::geom_hline(yintercept = 0) + 
    ggplot2::theme_bw(base_family = 'serif', base_size = 16) + 
    ggplot2::theme(
      axis.title.x = ggplot2::element_blank(), 
      legend.position = 'top', 
      legend.title = ggplot2::element_blank()
    ) +
    ggplot2::labs(
      title = ttl, 
      subtitle = subttl, 
      y = ylab
    )
  
  return(p)
  
}
