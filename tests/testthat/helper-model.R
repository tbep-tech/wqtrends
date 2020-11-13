library(wqtrends)

# data to model
tomod <- subset(rawdat, rawdat$station == 32 & rawdat$param == 'chl')

# test model
mod <- anlz_gam(tomod, trans = 'log10')