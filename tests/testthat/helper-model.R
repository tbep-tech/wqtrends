library(wqtrends)

# data to model
tomod <- subset(rawdat, rawdat$station == 34 & rawdat$param == 'chl' & yr > 2015)

# test model
mod <- anlz_gam(tomod, trans = 'log10')

# test model ident
modident <- anlz_gam(tomod, trans = 'ident')