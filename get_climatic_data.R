
###########################################################################
###########################################################################
###                                                                     ###
###                          GET CLIMATIC DATA                          ###
###                                                                     ###
###########################################################################
###########################################################################

###  This .R file creates a function that when called with a date
###  and coordinates (lat/lng) returns the median of the climatic 
###  data obtained on the date in question.


##---------------------------------------------------------------
##                          Libraries                          --
##---------------------------------------------------------------

library(tidyverse) # Data Manipulation
library(lubridate) # Date Manipulation
library(httr)      # Work with URLs and HTTP
library(rjson)     # JSON Manipulation


##---------------------------------------------------------------
##                        Core Function                        --
##---------------------------------------------------------------

getClimaticData <- function(date, lat, lng) {
  
  ApiBaseURL = 'http://api.worldweatheronline.com/premium/v1/past-weather.ashx?'
  source('./api_key.R')
  
  query <- URLencode(paste(ApiBaseURL, 
                     paste0('q=', lat, ',', lng), 
                     paste0('date=', date),
                     paste0('key=', ApiKey),
                     'format=json&includelocation=yes&tp=1', sep = '&'))

  getData <- GET(url = query)
  
  return(getData)
}


############################################################################
############################################################################