#
# This is a Shiny web application. You can run the application by clicking
# the 'Run App' button above.
#
# Find out more about building applications with Shiny here:
#
#    http://shiny.rstudio.com/
#

library(tidyverse)
library(lubridate)
library(wqtrends)
library(mgcv)
library(here)
library(patchwork)
library(dplyr)
library(data.table)
library(mgcViz)
library(ggplot2)
library(tidyquant)
library(gratia)
library(here)
library(rgl)
library(ggbeeswarm)

load('rawdat.RData')
load('sscdata-aggreg.rData') #import 15-minute aggregated ssc/turb data

alcatraz <- sscdata %>% 
  select(datetime, ssc.mgL,station) %>% 
  mutate(
    date = date(datetime),
    logssc.alcatraz = log10(ssc.mgL),
  ) %>%
  filter(station == "Alcatraz")%>%
  group_by(date) %>%
  summarise(across(where(is.numeric), ~ mean(.x, na.rm = TRUE))) %>%
  rename(ssc.mgL.alcatraz = ssc.mgL)

sfpier17 <- sscdata %>% 
  select(datetime, ssc.mgL,station) %>% 
  mutate(
    date = date(datetime),
    logssc.sfpier17 = log10(ssc.mgL)
  ) %>%
  filter(station == "SF Pier 17")%>%
  group_by(date) %>%
  summarise(across(where(is.numeric), ~ mean(.x, na.rm = TRUE))) %>%
  rename(ssc.mgL.sfpier17 = ssc.mgL)

richmond <- sscdata %>% 
  select(datetime, ssc.mgL,station) %>% 
  mutate(
    date = date(datetime),
    logssc.richmond = log10(ssc.mgL)
  ) %>%
  filter(station == "Richmond Bridge")%>%
  group_by(date) %>%
  summarise(across(where(is.numeric), ~ mean(.x, na.rm = TRUE))) %>%
  rename(ssc.mgL.richmond = ssc.mgL)

dumbarton <- sscdata %>% 
  select(datetime, ssc.mgL,station) %>% 
  mutate(
    date = date(datetime),
    logssc.dumbarton = log10(ssc.mgL)
  ) %>%
  filter(station == "Dumbarton (USGS)")%>%
  group_by(date) %>%
  summarise(across(where(is.numeric), ~ mean(.x, na.rm = TRUE))) %>%
  rename(ssc.mgL.dumbarton = ssc.mgL)

simpson<-read.csv('Simpson_MonthlyMax_of_5day_MovingMin.csv')%>%
  rename(date.simpson = ts,
         simpson = SimpsonNumber_MonthMaxOf_5dayMovingMin) %>%
  mutate(yearmonth = paste(month,year,sep=" "),
         log.simpson = log10(simpson)) %>%
  select(yearmonth,date.simpson,simpson,log.simpson)

coyote<-read.csv('Processed_Coyote_Creek_Q.csv') %>%
  mutate(date=as_date(ts_pst),
         log.q = log10(q_cms))%>%
  group_by(date) %>%
  summarise(across(where(is.numeric), ~ mean(.x, na.rm = TRUE))) 

sscproc<-bind_rows(alcatraz,dumbarton,richmond,sfpier17)%>%
  arrange(date)%>%
  mutate(doy = yday(date),
         cont_year = year(date)+(yday(date)/365))

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
  mutate(season = case_when(doy>=213 & doy <=305 ~ 'fall',
                            doy>=305 | doy<= 31 ~ 'winter',
                            doy>=32 & doy<=121 ~ 'spring',
                            doy>=121 & doy<=212 ~ 'summer'),
         season = factor(season,levels=c('winter','spring','summer','fall'),ordered = TRUE),
         station = factor(station,levels=c('18','21','22','24','27','30','32','34','36'),ordered=TRUE))%>%
  mutate_at("station",as.character)


# Define UI for application that draws a histogram
ui <- navbarPage("Peterson-SSC GAMs",
                 
                 tabPanel("SSC tensor",
                          sidebarPanel( #interactive leaflet map of the stations (not yet able to use it to select stations to be plotted, but that's the intention)
                            selectInput(
                              inputId = "Pete",
                              label = "Select Peterson chl-a station",
                              choices = c('18','21','22','24','27','30','32','34','36'),
                              selected = '32',
                              multiple=FALSE
                            ),
                            selectizeInput(
                              inputId = "ssc",
                              label = "Select USGS high-freq SSC station",
                              choices = c("dumbarton","alcatraz","richmond","sfpier17"),
                              selected = "dumbarton",
                              multiple=FALSE
                            ),
                            sliderInput(
                              inputId = "Date",
                              label = "Select date",
                              min = date(min(chlonly$date,na.rm=TRUE)),
                              max = date(max(chlonly$date,na.rm=TRUE)),
                              value = date(c(min(chlonly$date,na.rm=TRUE),date(max(chlonly$date,na.rm=TRUE))))
                            ),
                            numericInput(
                              inputId = "knots",
                              label = "Number of knots for continuous year term",
                              value = 100,
                              min = 1,
                              max = 1000,
                              step = 1),
                            numericInput(
                              inputId = "ssclead",
                              label = "Select leading SSC period to average (days)",
                              value = 14,
                              min = 1,
                              max = 365,
                              step = 1)),
                          mainPanel(plotOutput("tensorplot"),height=900)
                 ),
                 tabPanel("Seasonal SSC association",
                          sidebarPanel( #interactive leaflet map of the stations (not yet able to use it to select stations to be plotted, but that's the intention)
                            selectInput(
                              inputId = "Pete2",
                              label = "Select Peterson chl-a station",
                              choices = c('18','21','22','24','27','30','32','34','36'),
                              selected = '32',
                              multiple=FALSE
                            ),
                            selectizeInput(
                              inputId = "ssc2",
                              label = "Select USGS high-freq SSC station",
                              choices = c("dumbarton","alcatraz","richmond","sfpier17"),
                              selected = "dumbarton",
                              multiple=FALSE
                            ),
                            sliderInput(
                              inputId = "Date2",
                              label = "Select date",
                              min = date(min(chlonly$date,na.rm=TRUE)),
                              max = date(max(chlonly$date,na.rm=TRUE)),
                              value = date(c(min(chlonly$date,na.rm=TRUE),date(max(chlonly$date,na.rm=TRUE))))
                            ),
                            numericInput(
                              inputId = "knots2",
                              label = "Number of knots for continuous year term",
                              value = 100,
                              min = 1,
                              max = 1000,
                              step = 1),
                            numericInput(
                              inputId = "ssclead2",
                              label = "Select leading SSC period to average (days)",
                              value = 14,
                              min = 1,
                              max = 365,
                              step = 1),
                            numericInput(
                              inputId = "doy1",
                              label = "Start of period of interest",
                              value = 150,
                              min = 1,
                              max = 365,
                              step = 1),
                            numericInput(
                              inputId = "doy2",
                              label = "End of period of interest",
                              value = 275,
                              min = 1,
                              max = 365,
                              step = 1)),
                          mainPanel(plotOutput("dayslice"),height=900)
                 )
                 ,
                 tabPanel("Modeled chl-a",
                          sidebarPanel( #interactive leaflet map of the stations (not yet able to use it to select stations to be plotted, but that's the intention)
                            selectInput(
                              inputId = "Pete3",
                              label = "Select Peterson chl-a station",
                              choices = c('18','21','22','24','27','30','32','34','36'),
                              selected = '32',
                              multiple=FALSE
                            ),
                            selectizeInput(
                              inputId = "ssc3",
                              label = "Select USGS high-freq SSC station",
                              choices = c("dumbarton","alcatraz","richmond","sfpier17"),
                              selected = "dumbarton",
                              multiple=FALSE
                            ),
                            sliderInput(
                              inputId = "Date3",
                              label = "Select date",
                              min = date(min(chlonly$date,na.rm=TRUE)),
                              max = date(max(chlonly$date,na.rm=TRUE)),
                              value = date(c(min(chlonly$date,na.rm=TRUE),date(max(chlonly$date,na.rm=TRUE))))
                            ),
                            numericInput(
                              inputId = "knots3",
                              label = "Number of knots for continuous year term",
                              value = 100,
                              min = 1,
                              max = 1000,
                              step = 1),
                            numericInput(
                              inputId = "ssclead3",
                              label = "Select leading SSC period to average (days)",
                              value = 1,
                              min = 1,
                              max = 365,
                              step = 1),
                            numericInput(
                              inputId = "doy1a",
                              label = "Start of period of interest",
                              value = 150,
                              min = 1,
                              max = 365,
                              step = 1),
                            numericInput(
                              inputId = "doy2a",
                              label = "End of period of interest",
                              value = 275,
                              min = 1,
                              max = 365,
                              step = 1)),
                          mainPanel(plotOutput("chlmodel"),height=900)
                 )
)

server <- function(input, output, session) {
  
  chlgam <-reactive({
    frmla<-paste0("logchl~te(logssc.",input$ssc,",doy,bs=c('cs','cc')) + s(cont_year,k=",input$knots,")")
    chlsub<-chlonly %>%
      mutate_at(paste0("logssc.",input$ssc),frollmean,n=input$ssclead,align="right",na.rm=F)%>%
      filter(station == input$Pete & between(date,input$Date[1],input$Date[2])==TRUE)%>%
      gam(as.formula(frmla),data=.)
    
    return(chlsub)
  })
  
  slicep<-reactive({
    frmla<-paste0("logchl~te(logssc.",input$ssc2,",doy,bs=c('cs','cc')) + s(cont_year,k=",input$knots2,")")
    chlsub<-chlonly %>%
      mutate_at(paste0("logssc.",input$ssc2),frollmean,n=input$ssclead2,align="right",na.rm=F)%>%
      filter(station == input$Pete2 & between(date,input$Date2[1],input$Date2[2])==TRUE)
    gamsub<-gam(as.formula(frmla),data=chlsub)
    chlsub$pred<-predict.gam(gamsub,chlsub,terms=paste0("te(logssc.",input$ssc,",doy)"))
    
    chlsub<-chlsub %>%
      filter(doy >=input$doy1 & doy <= input$doy2)
    return(chlsub)
  })
  
  
  
  observe({
    updateSelectInput(
      session,
      "Pete2",
      selected = input$Pete
    )
    
  })
  
  observe({
    updateSelectInput(
      session,
      "ssc2",
      selected = input$ssc
    )
    
  })
  
  observe({
    updateSelectInput(
      session,
      "Date2",
      selected = input$Date
    )
    
  })
  
  observe({
    updateSelectInput(
      session,
      "knots2",
      selected = input$knots
    )
    
  })
  
  observe({
    updateSelectInput(
      session,
      "ssclead2",
      selected = input$ssclead
    )
    
  })
    
  slicep2<-reactive({
    frmla<-paste0("logchl~te(logssc.",input$ssc3,",doy,bs=c('cs','cc')) + s(cont_year,k=",input$knots3,")")
    chlsub<-chlonly %>%
      mutate_at(paste0("logssc.",input$ssc3),frollmean,n=input$ssclead3,align="right",na.rm=F)%>%
      filter(station == input$Pete3 & between(date,input$Date3[1],input$Date3[2])==TRUE)
    gamsub<-gam(as.formula(frmla),data=chlsub)
    chlsub$pred<-predict.gam(gamsub,chlsub,terms=paste0("te(logssc.",input$ssc,",doy)"))
    
    
    chlsub<-chlsub %>%
      filter(doy >=input$doy1a & doy <= input$doy2a)
    return(chlsub)
  })
  
  sscslice<-reactive({
    frmla<-paste0("logchl~te(logssc.",input$ssc3,",doy,bs=c('cs','cc')) + s(cont_year,k=",input$knots3,")")
    chlsub<-chlonly %>%
      mutate_at(paste0("logssc.",input$ssc3),frollmean,n=input$ssclead3,align="right",na.rm=F)%>%
      filter(station == input$Pete3 & between(date,input$Date3[1],input$Date3[2])==TRUE)
    gamsub<-gam(as.formula(frmla),data=chlsub)
    
    
    sscsub<-sscproc %>%
      mutate_at(paste0("logssc.",input$ssc3),frollmean,n=input$ssclead3,align="right",na.rm=F)%>%
      filter(between(date,input$Date3[1],input$Date3[2])==TRUE)%>%
      filter(doy >=input$doy1a & doy <= input$doy2a)
    sscsub$pred<-predict.gam(gamsub,sscsub,terms=paste0("te(logssc.",input$ssc3,",doy)"))
    
    chlsub<-chlsub %>%
      filter(doy >=input$doy1a & doy <= input$doy2a)
    return(chlsub)
  }) 
  
  observe({
    updateSelectInput(
      session,
      "Pete3",
      selected = input$Pete2
    )
    
  })
  
  observe({
    updateSelectInput(
      session,
      "ssc3",
      selected = input$ssc2
    )
    
  })
  
  observe({
    updateSelectInput(
      session,
      "Date3",
      selected = input$Date2
    )
    
  })
  
  observe({
    updateSelectInput(
      session,
      "knots2",
      selected = input$knots
    )
    
  })
  
  observe({
    updateSelectInput(
      session,
      "ssclead3",
      selected = input$ssclead2
    )
  })
  
  observe({
    updateSelectInput(
      session,
      "doy1a",
      selected = input$doy1
    )
    
  })
  
  observe({
    updateSelectInput(
      session,
      "doy2a",
      selected = input$doy2
    )
    
  })
  
  output$tensorplot <- renderPlot({
    
    x <- chlgam()
    
    p<- draw(x) & theme_bw(base_size = 18)

    p
  },height=900)
  
  output$dayslice<- renderPlot(
    {
      x=slicep()
      p<-ggplot(data= x, aes_string(paste0("logssc.",input$ssc),"pred",col="doy"))+
        geom_smooth(method="lm")+ 
        geom_point(size=4)+
        ylab("Partial effect: Log10(chl-a)")+
        scale_color_continuous(type="viridis")+
        xlab("Log10(ssc)")+
        theme_bw(base_size = 18)
      p
    },height=900
  )
  
  output$dayslice<- renderPlot(
    {
      x=slicep()
      p<-ggplot(data= x, aes_string(paste0("logssc.",input$ssc),"pred",col="doy"))+
        geom_smooth(method="lm")+ 
        geom_point(size=4)+
        ylab("Partial effect: Log10(chl-a)")+
        scale_color_continuous(type="viridis")+
        xlab("Log10(ssc)")+
        theme_bw(base_size = 18)
      p
    },height=900
  )
  
  output$chlmodel<-renderPlot(
    {
      x=slicep2()
      y=sscslice()
      p<-ggplot(data=x, aes(as.factor(year(date)),logchl))+
        geom_boxplot()+
        geom_beeswarm()+
        ylab("log10(Chl-a)")+
        xlab(element_blank())+
        theme_bw(base_size = 18)+
        labs(title = "Observed Peterson Chl-a")
      q<-ggplot(data=x)+
        geom_bar(aes(as.factor(year(date)),pred),stat="summary",fun.y = mean,width=1)+
        ylab("Partial effect on log(chl-a)")+
        xlab(element_blank())+
        theme_bw(base_size = 18)+
        labs(title = "Modeled SSC Partial Effect")
      r<-ggplot(data=y, aes_string('as.factor(year(date))',paste0("logssc.",input$ssc3)))+
        geom_boxplot()+
        geom_jitter()+
        ylab("log10(SSC)")+
        xlab(element_blank())+
        theme_bw(base_size = 18)+
        labs(title = "Observed high-frequency SSC (mean)")

      p/q/r
    },height=900
  )
  
}


shinyApp(ui, server)
