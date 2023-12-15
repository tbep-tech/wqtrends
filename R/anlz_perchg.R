#' Estimate percent change trends from GAM results for selected time periods
#' 
#' Estimate percent change trends from GAM results for selected time periods
#'
#' @param mod input model object as returned by \code{\link{anlz_gam}}
#' @param baseyr numeric vector of starting years
#' @param testyr numeric vector of ending years
#' 
#' @export
#' @return A data frame of summary results for change between the years.
#' 
#' @details Working components of this function were taken from the gamDiff function in the baytrends package. 
#' 
#' @concept analyze
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
#' anlz_perchg(mod, baseyr = 1990, testyr = 2016)
anlz_perchg <- function(mod, baseyr, testyr){

  # input data used to create model
  gamdat <- mod$model
  
  # transformation used
  trans <- mod$trans
  
  # estimated values are on the fifteenth of every month for each year of comparisons
  doyset <- c(15, 46, 75, 106, 136, 167, 197, 228, 259, 289, 320, 350)
  
  # set up base and test years
  nbaseyr <- length(baseyr)  
  ntestyr <- length(testyr)
  yrset <- c(baseyr, testyr)
  
  # calculate total predictions in base period, test period
  nbase <- length(doyset) * nbaseyr  
  ntest <- length(doyset) * ntestyr 
  
  # create a data frame with Nrow rows where Nrow= (nbase*Ndoy) + (ntest*Ndoy)...
  # nbase yrs of Ndoy baseline dates and ntest-yrs
  # of Ndoy current dates. Include: doy, year, logical field (bl) indicating baseline
  # and current, and centered decimal year (cont_year) using same centering value
  # computed from data set (centerYear)
  pdat <- expand.grid(doyset, yrset)       # make df with all comb. of doyset and yrset
  names(pdat) <- c('doy','year')                   # rename variables
  pdat$bl <- pdat$year <= baseyr[nbaseyr] # create logical field indicating baseline
  pdat$cont_year <- (pdat$year + (pdat$doy-1)/366) # compute cont_year
  
  # JBH(24Nov2017): extension of above xa and avg.per.mat
  #   keeping weight the same--just extending number of values by "*nrow(pdatWgt)"
  xa <- c(rep(1/nbase,nbase),
          rep(0,ntest),
          rep(0,nbase),
          rep(1/ntest,ntest)) # construct a matrix to average baseline and current periods
  avg.per.mat <- matrix(xa,nrow=2,ncol=(nbase+ntest), byrow=TRUE)
  
  # construct matrix to get difference of current minus baseline
  diff.mat <- c(-1,1)
  
  # Extract coefficients (number of terms depends on complexity of GAM formula)
  beta    <- mod$coefficients        # coefficients vector
  VCmat   <- mod$Vp                  # variance-covariance matrix of coefficents
  
  # Begin calculations to compute differences ####
  # extract matrix of linear predicters
  Xpc     <- predict(mod, newdata = pdat,type="lpmatrix")
  
  # Compute predictions based on linear predictors (Nrow x 1 matrix)
  pdep    <- Xpc%*%beta               # equivalent to "predict(gamRslt,newdata=pdatLong)"
  
  # Calc. average baseline and average current; stores as a 2x1 matrix
  period.avg <- avg.per.mat %*% pdep
  
  # Calc. average current - average baseline; stores as a 1x1 matrix
  diff.avg  <- diff.mat %*% period.avg # pre-multiply by differencing matrix to check results
  
  # Calc standard errors and confidence intervals on difference predictions
  xpd       <- diff.mat%*%avg.per.mat%*%Xpc # premultiply linear predictors by averaging and differencing matrices.
  diff.est  <- xpd%*%beta                   # compute estimate of difference
  diff.se   <- sqrt(xpd%*%VCmat%*%t(xpd))   # compute Std. Err. by usual rules
  diff.t    <- diff.est / diff.se
  pval <- 2*pt(abs(diff.t), mod$df.null, 0, lower.tail = FALSE)
  pval <- as.numeric(pval)
  
  #compute CI for differnce
  alpha <- 0.05
  halpha    <- alpha/2
  diff.ci   <- c(diff.est - qnorm(1-halpha) * diff.se,diff.est + qnorm(1-halpha) *diff.se)

  # observed units, backtransform
  per.mn.obs <- period.avg
  dispersion <- summary(mod)$dispersion
  if(trans == 'log10')
    per.mn.obs <- 10^(per.mn.obs + log(10) * dispersion / 2)

  # calculate percent change (03Nov)
  perchg <- 100*((per.mn.obs[2] - per.mn.obs[1])/per.mn.obs[1])
  
  # results
  out <- tibble::tibble(
    baseval = per.mn.obs[1, 1], # average value in observed units, base period
    testval = per.mn.obs[2, 1], # average value in observed units, test period
    perchg = perchg, # percent change, back-transformed
    pval = pval # p value
  )
  
  return(out)
  
}