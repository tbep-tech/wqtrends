#' Plot seasonal rates of change in quarters based on average estimates for multiple window widths
#'
#' Plot seasonal rates of change in quarters based on average estimates for multiple window widths
#' 
#' @param mod input model object as returned by \code{\link{anlz_gam}}
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
#' @details This function is similar to \code{\link{show_sumtrndseason}} but results are grouped into seasonal quarters as four separate plots with a combined color scale.
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
#' show_sumtrndseason2(mod, justify = 'center', win = 2:3)
show_sumtrndseason2 <- function(mod, justify = c('center', 'left', 'right'), 
                               win = 5:15, txtsz = 6, cols = c('lightblue', 'lightgreen'), 
                               base_size = 11){
  
  justify <- match.arg(justify)
  
  sig_cats <- c('**', '*', '')
  sig_vals <- c(-Inf, 0.005, 0.05, Inf)
  
  seas <- c('Jan - Mar', 'Apr - Jun', 'Jul - Sep' , 'Oct - Dec')

  # get ests across all window widths and quarters
  res1 <- anlz_sumtrndseason(mod, doystr = 1, doyend = 90, justify = justify, win = win) %>% 
    dplyr::mutate(seas = seas[1])
  res2 <- anlz_sumtrndseason(mod, doystr = 91, doyend = 181, justify = justify, win = win) %>% 
    dplyr::mutate(seas = seas[2])
  res3 <- anlz_sumtrndseason(mod, doystr = 182, doyend = 273, justify = justify, win = win) %>% 
    dplyr::mutate(seas = seas[3])
  res4 <- anlz_sumtrndseason(mod, doystr = 274, doyend = 365, justify = justify, win = win) %>% 
    dplyr::mutate(seas = seas[4])
  
  res <- dplyr::bind_rows(res1, res2, res3, res4) %>% 
    dplyr::mutate(seas = factor(seas, levels = !!seas)) %>% 
    tidyr::complete(yr, win, seas)

  # legend title
  legttl <- 'Change/yr'
  if(mod$trans == 'log10')
    legttl <- paste0('log-', tolower(legttl))
  
  toplo <- res %>% 
    dplyr::mutate(
      psig = cut(pval, breaks = sig_vals, labels = sig_cats, right = FALSE), 
      psig = as.character(psig)
    )

  p <- ggplot2::ggplot(toplo, ggplot2::aes(x = yr, y = win, fill = yrcoef)) +
    ggplot2::geom_tile(color = 'black') + 
    ggplot2::geom_text(ggplot2::aes(label = psig), size = txtsz, vjust = 0.5) + 
    ggplot2::facet_wrap(~seas, ncol = 1) +
    ggplot2::scale_x_continuous(expand = c(0, 0)) + 
    ggplot2::scale_y_continuous(expand = c(0, 0), breaks = win) +
    ggplot2::scale_fill_gradient2(low = cols[1], mid = 'white', high = cols[2], midpoint = 0) +
    ggplot2::theme_bw(base_size = base_size) + 
    ggplot2::theme(
      legend.position = 'top',
      strip.background = ggplot2::element_blank(), 
      strip.text = ggplot2::element_text(hjust = 0)
    ) + 
    ggplot2::guides(fill = ggplot2::guide_colourbar(barwidth = 10, barheight = 0.5)) +
    ggplot2::labs(
      fill = legttl,
      x = NULL,
      y = 'Year window', 
      caption = '* p< 0.05, ** p < 0.005'
    )
  
  return(p)
  
}
