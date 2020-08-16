
###########################################################################
###########################################################################
###                                                                     ###
###             MERGE DATA: INSPECTIONS + CLIMATE + SENSORS             ###
###                                                                     ###
###########################################################################
###########################################################################

###  This .R file reads the 2 data sets in ./data and merges. 
###  First, the climatic data are obtained through the inspection 
###  data and later aggregated. After that, an inner join is 
###  performed between the results data from the first stage and 
###  the sensor data.


##---------------------------------------------------------------
##                          Libraries                          --
##---------------------------------------------------------------

library(tidyverse) # Data Manipulation
library(lubridate) # Date Manipulation


##---------------------------------------------------------------
##                        Load data sets                       --
##---------------------------------------------------------------

###  The data files are obtained through 2 spreadsheets in the
###  format .csv, containing inspections of all apiaries in the 
###  years 2016, 2017 and 2018 and the sensor data summarized 
###  by day.

inspections <- read_csv('./data/inspections.csv')
sensors <- read_csv('./data/sensors.csv')


##----------------------------------------------------------------
##             Combine inspections and climate data             --
##----------------------------------------------------------------

###  The function below adds columns to the inspection data through 
###  the functions of obtaining climatic data present in the file 
###  get_climatic_data.R through the information contained in the date, 
###  latitude and longitude columns.

source('./get_climatic_data.R')  # Load Functions

inspclimData <- inspections %>%
  do(bind_cols(., data.frame(t(getClimateStatsData(date = .$Date, 
                                                   lat = .$Latitude, 
                                                   lng = .$Longitude)))))


##---------------------------------------------------------------
##        Combine inspections, climate and sensors data        --
##---------------------------------------------------------------

###  The code below performs an inner join between the climate data 
###  and inspection dataset with the sensor data set, having as key 
###  variables: Apiary, Hive and Data.

inspclimsensData <- inspclimData %>%
  inner_join(sensors, by = c('Date' = 'Date', 'Apiary' = 'Apiary', 'Hive' = 'Hive'))

