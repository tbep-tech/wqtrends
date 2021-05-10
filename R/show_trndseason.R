#' Plot seasonal rates of change based on average estimates
#'
#' Plot seasonal rates of change based on average estimates
#' 
#' @inheritParams anlz_trndseason
#' @param type chr string indicating if log slopes are shown (if applicable)
#' @param ylab chr string for y-axis label
#'
#' @return A \code{\link[ggplot2]{ggplot}} object
#' @export
#' 
#' @concept show
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
#' show_trndseason(mod, doystr = 90, doyend = 180, justify = 'left', win = 5,
#'      ylab = 'Slope Chlorophyll-a (ug/L/yr)')
show_trndseason <- function(mod, metfun = mean, doystr = 1, doyend = 364, type = c('log10', 'approx'), justify = c('left', 'right', 'center'), win = 5, ylab, nsim = 1e4, ...) {
  
  justify <- match.arg(justify)
  type <- match.arg(type)
  
  # get slope trends
  trndseason <- anlz_trndseason(mod = mod, metfun = metfun, doystr = doystr, doyend = doyend, justify = justify, win = win, nsim = nsim, ...) 

  # title
  dts <- as.Date(c(doystr, doyend), origin = as.Date("2000-12-31"))
  strt <- paste(lubridate::month(dts[1], label = T, abbr = T), lubridate::day(dts[1]))
  ends <- paste(lubridate::month(dts[2], label = T, abbr = T), lubridate::day(dts[2]))

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
  
  if(type == 'log10' & mod$trans == 'log10'){
    
    ttl <- paste0('Annual log-slopes (+/- 95%) for seasonal trends: ', strt, '-',  ends)
    
    p <- ggplot2::ggplot(data = toplo, ggplot2::aes(x = yr, y = yrcoef, fill = pval)) + 
      ggplot2::geom_hline(yintercept = 0) + 
      ggplot2::geom_errorbar(ggplot2::aes(ymin = yrcoef_lwr, ymax = yrcoef_upr, color = pval), width = 0) +
      ggplot2::scale_color_manual(values = c('black', 'tomato1'), drop = FALSE)
 
  }
  
  if(type == 'approx' & mod$trans == 'log10'){
    
    ttl <- paste0('Annual slopes (approximate) for seasonal trends: ', strt, '-',  ends)
    
    p <- ggplot2::ggplot(data = toplo, ggplot2::aes(x = yr, y = appr_yrcoef, fill = pval)) + 
      ggplot2::geom_hline(yintercept = 0) + 
      ggplot2::labs(
        title = ttl, 
        subtitle = subttl, 
        y = ylab
      )
    
  }
  
  if(mod$trans == 'ident'){
    
    ttl <- paste0('Annual slopes (+/- 95%) for seasonal trends: ', strt, '-',  ends)
    
    p <- ggplot2::ggplot(data = toplo, ggplot2::aes(x = yr, y = yrcoef, fill = pval)) + 
      ggplot2::geom_hline(yintercept = 0) + 
      ggplot2::geom_errorbar(ggplot2::aes(ymin = yrcoef_lwr, ymax = yrcoef_upr, color = pval), width = 0) +
      ggplot2::scale_color_manual(values = c('black', 'tomato1'), drop = FALSE)
    
  }
  
  p <- p + 
    ggplot2::geom_point(shape = 21, size = 3) +
    ggplot2::scale_fill_manual(values = c('white', 'tomato1'), drop = FALSE) +
    ggplot2::scale_x_continuous(limits = yrrng) +
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
