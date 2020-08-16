
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

###  In this section, two functions are defined, the first visit 
###  to the wordweatheronline API and returns a raw list containing 
###  hourly weather data for a certain date and location (latitude 
###  and longitude). The second function takes this raw list and 
###  returns a dataframe with the minimum, median and maximum for 
###  each variable of interest.


getClimaticData <- function(date, lat, lng) {
  
  ApiBaseURL = 'http://api.worldweatheronline.com/premium/v1/past-weather.ashx?'
  source('./api_key.R')
  
  query <- URLencode(paste(ApiBaseURL, 
                     paste0('q=', lat, ',', lng), 
                     paste0('date=', date),
                     paste0('key=', ApiKey),
                     'format=json&includelocation=yes&tp=1', sep = '&'))

  rawData <- content(x = GET(url = query))
  
  return(rawData)
}

getStatsDaily <- function(rawData) {
  
  WeatherStation <- c(rawData$data$nearest_area[[1]]$latitude,
                      rawData$data$nearest_area[[1]]$longitude)
  
  listDaily <- lapply(rawData$data$weather[[1]]$hourly, function(lt) {
    tibble(Temperature = lt$tempC, Windspeed = lt$windspeedKmph,
           Precipitation = lt$precipMM, Humidity = lt$humidity,
           Pressure = lt$pressure, Dewpoint = lt$DewPointC)
  })
  
  tibbleStats <- listDaily %>% 
    bind_rows() %>% 
    mutate_all(.funs = list(~as.numeric(.))) %>%
    summarize(across(everything(), 
                     .fns = list(Min = ~min(.), 
                                 Median = ~median(.), 
                                 Max = ~max(.)),
                     .names = "{fn}{col}")) %>%
    mutate(StationLat = as.numeric(WeatherStation[1]), 
           StationLng = as.numeric(WeatherStation[2]))
  
  return(unlist(tibbleStats))
}

getClimateStatsData <- Vectorize(function(date, lat, lng) {
  raw <- getClimaticData(date, lat, lng)
  statsData <- getStatsDaily(raw)
  return(statsData)
})

############################################################################
############################################################################