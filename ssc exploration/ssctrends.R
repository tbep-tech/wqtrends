library(mixmeta)
library(wqtrends)
library(mgcv)
library(tidyverse)
library(lubridate)
library(mgcv)
library(patchwork)
library(dplyr)
library(data.table)
library(ggplot2)
library(gratia)

#your root directory
load('rawdat.RData') #import trends raw chl-a data
load('sscdata-aggreg.rData') #import 15-minute aggregated ssc/turb data
#generate new sscdat, create a new log(ssc) column and a new set of columns with varying right-aligned moving averages of log-transformed data

#the next series of blocks create SSC datasets for alcatraz, SF pier 17, dumbarton and richmond
#transforms ssc to log10 scale, gropus by date and averages across numeric columns. creates a new column specific to that usgs station for the later merge
alcatraz <- sscdata %>% 
  dplyr::select(datetime, ssc.mgL,station) %>% 
  mutate(
    date = date(datetime),
    logssc.alcatraz = log10(ssc.mgL),
  ) %>%
  filter(station == "Alcatraz")%>%
  group_by(date) %>%
  summarise(across(where(is.numeric), ~ mean(.x, na.rm = FALSE))) %>%
  rename(ssc.mgL.alcatraz = ssc.mgL)

sfpier17 <- sscdata %>% 
  dplyr::select(datetime, ssc.mgL,station) %>% 
  mutate(
    date = date(datetime),
    logssc.sfpier17 = log10(ssc.mgL)
  ) %>%
  filter(station == "SF Pier 17")%>%
  group_by(date) %>%
  summarise(across(where(is.numeric), ~ mean(.x, na.rm = TRUE))) %>%
  rename(ssc.mgL.sfpier17 = ssc.mgL)

richmond <- sscdata %>% 
  dplyr::select(datetime, ssc.mgL,station) %>% 
  mutate(
    date = date(datetime),
    logssc.richmond = log10(ssc.mgL)
  ) %>%
  filter(station == "Richmond Bridge")%>%
  group_by(date) %>%
  summarise(across(where(is.numeric), ~ mean(.x, na.rm = TRUE))) %>%
  rename(ssc.mgL.richmond = ssc.mgL)

dumbarton <- sscdata %>% 
  dplyr::select(datetime, ssc.mgL,station) %>% 
  mutate(
    date = date(datetime),
    logssc.dumbarton = log10(ssc.mgL)
  ) %>%
  filter(station == "Dumbarton (USGS)")%>%
  group_by(date) %>%
  summarise(across(where(is.numeric), ~ mean(.x, na.rm = TRUE))) %>%
  rename(ssc.mgL.dumbarton = ssc.mgL)

#the simpson number data represents the monthly maximum of 5-day moving minimum data. it is an approximate measure of the stratification of the system
simpson<-read.csv('Simpson_MonthlyMax_of_5day_MovingMin.csv')%>%
  rename(date.simpson = ts,
         simpson = SimpsonNumber_MonthMaxOf_5dayMovingMin) %>%
  mutate(yearmonth = paste(month,year,sep=" "),
         log.simpson = log10(simpson)) %>%
  dplyr::select(yearmonth,date.simpson,simpson,log.simpson)

#flow data from Coyote Creek, averaged by day
coyote<-read.csv('Processed_Coyote_Creek_Q.csv') %>%
  mutate(date=as_date(ts_pst),
         log.q = log10(q_cms))%>%
  group_by(date) %>%
  summarise(across(where(is.numeric), ~ mean(.x, na.rm = TRUE))) 

#create a combined dataset binding together the previous files
sscproc<-bind_rows(alcatraz,dumbarton,richmond,sfpier17)%>%
  arrange(date)%>%
  mutate(doy = yday(date))

#merge the raw trends data with each of the SSC datasets, merged by date of observation
chlonly <- rawdat%>%
  merge(alcatraz,by="date",all.x = TRUE)%>%
  merge(sfpier17,by="date",all.x = TRUE)%>%
  merge(richmond,by="date",all.x = TRUE)%>%
  merge(dumbarton,by="date",all.x = TRUE)%>%
  mutate(yearmonth = paste(month(date),year(date),sep = " "))%>%
  merge(simpson,by="yearmonth",all.x = TRUE)%>%
  merge(coyote,by="date",all.x = TRUE)%>%
  filter(param == "chl")%>%
  mutate(logchl = log10(value),
         doy = yday(date))%>%
  mutate(season = case_when(doy>=213 & doy <=305 ~ 'fall', #create a season column
                            doy>=305 | doy<= 31 ~ 'winter',
                            doy>=32 & doy<=121 ~ 'spring',
                            doy>=121 & doy<=212 ~ 'summer'),
         season = factor(season,levels=c('winter','spring','summer','fall'),ordered = TRUE),
         station = factor(station,levels=c('18','21','22','24','27','30','32','34','36'),ordered=TRUE))

#anlz_gam function, retooled to apply to ssc, select:
#the peterson station argument influences what matched SSC data are present. choices are 27 30 21 22 24 32 34 36 18
#the SSC station choices are dumbarton, richmond, alcatraz, sfpier17
#knots should default to maximum but I encounter an endless loop when I try to leave null. so I set usually to 300

anlz_ssc <- function(petersonstation, sscstation,kts = NULL,   ...){
  
  # get transformation
  moddat<- chlonly %>%
    dplyr::filter(station==petersonstation)
  moddat <- anlz_trans(moddat, ...)
  
  
  if(length(unique(moddat$param)) > 1)
    stop('More than one parameter found in input data')
  
  if(length(unique(moddat$station)) > 1)
    stop('More than one station found in input data')
  
  
  fct <- 12
  
  # get upper bounds of knots
  if(is.null(kts))
    kts <- fct * length(unique(moddat$yr))
  
  p1 <- paste0('logssc.',sscstation,' ~ ')
  p2 <- paste0('s(cont_year, k = ', kts, ')')
  
  frmin <- paste0(p1, p2)
  
  out <- try(gam(as.formula(frmin),
                 data = moddat,
                 na.action = na.exclude,
                 select = F
  ))
  
  # drops upper limit on knots until it works
  while(inherits(out, 'try-error')){
    
    fct <- fct -1
    
    # get upper bounds of knots
    kts <- fct * length(unique(moddat$yr))
    
    p1 <- paste0('logssc.',sscstation,' ~ ')
    p2 <- paste0('s(cont_year, k = ', kts, ')')
    
    out <- try(gam(as.formula(frmin),
                   data = moddat,
                   na.action = na.exclude,
                   select = F
    ))
    
  }
  
  out$trans <- unique(moddat$trans)
  
  return(out)
  
  
}

#create ssc trend gam object for station 32 compared to dumbarton SSC, kts=300
ssctrend<-anlz_ssc("30","dumbarton",kts=300)
#use show_metseason from wqtrends package to extract trend from previous GAM object between August 1st-Oct 1st, 2005-2014
show_metseason(ssctrend,doystr=213,doyend = 304,yrstr=2005,yrend=2014,ylab = "SSC (mg/L)")
#extract 10-year trends for the Aug-Oct season from the SSC trend gam object
show_trndseason(ssctrend,metfun = mean,win=10,doystr=213,doyend = 304,ylab = "SSC (mg/L)",justify = "right")

#generate tensor gam from chosen peterson, ssc station, with chosen knot number for cont_year. 
#ssc.ma applies a right-justified average to SSC for a period length of your choice in days
ssc.gam<-function(peterson.stn,ssc.stn,knots,ssc.ma){
  chltrans<-chlonly%>%
    mutate_at(paste0("logssc.",ssc.stn),frollmean,n=ssc.ma,align="right",na.rm=F)
  frmla<-paste0("value~te(logssc.",ssc.stn,",doy,bs=c('cs','cc')) + s(cont_year,k=",knots,")")
  tensorgam<-chltrans %>%
    filter(station == peterson.stn)%>%
    gam(as.formula(frmla),data=.)
  tensorgam
}

#generate a tensor plot from gratia package for a chlorophyll-SSC gam object
tensorplot<-function(sscgam){
  draw(sscgam)&theme_bw()
}

#predict ssc and chlorophyll values for chosen interval of year
#ssc.ma applies a right-justified average to SSC for a period length of your choice in days
predict.ssc<-function(input,peterson.stn,ssc.stn,day1,day2,ssc.ma){
  sscnew<-chlonly%>%
    mutate_at(paste0("logssc.",ssc.stn),frollmean,n=ssc.ma,align="right",na.rm=F)%>%
    filter(station == peterson.stn & doy >=day1 & doy <= day2)
  sscnew$pred <- predict.gam(input,sscnew,terms=paste0("te(logssc.",ssc.stn,",doy)"))
  
  slice<-ggplot(data= sscnew, aes_string(paste0("logssc.",ssc.stn),"pred",col="doy"))+
    geom_smooth(method="lm")+ 
    geom_point()+
    ylab("Partial effect: Log10(chl-a)")+
    scale_color_continuous(type="viridis")+
    xlab("Log10(ssc)")+
    theme_bw(base_size = 15)
  print(slice)
}


#create gam with SSC-doy tensor comparing station 32 to dumbarton bridge
ssctensor<-ssc.gam("32","dumbarton",200,14)
#plot up the previous gam object with gratia
tensorplot(ssctensor)
#extract the predicted partial effects on chl-a from the tensor term for a chosen day of year range (in this case the summer between days 150 and 225)
predict.ssc(ssctensor,"32","dumbarton",150,225,14)

