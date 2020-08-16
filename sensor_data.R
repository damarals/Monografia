
############################################################################
############################################################################
###                                                                      ###
###                           LOAD SENSOR DATA                           ###
###                                                                      ###
############################################################################
############################################################################

###  This .R file loads all .csv files into ./data/sensors and 
###  attaches them making it a single data set. After that, a series 
###  of methods are applied for cleaning the data and finally the 
###  minimum, median and maximum of each variable are taken per day.


##---------------------------------------------------------------
##                          Libraries                          --
##---------------------------------------------------------------

library(tidyverse) # Data Manipulation
library(lubridate) # Date Manipulation


##---------------------------------------------------------------
##               Load .csv files and attach them               --
##---------------------------------------------------------------

###  The code below lists all files in the ./data/sensors directory 
###  and reads them. Then, all files read are attached.

setwd('./data/sensor')
fileList <- list.files(pattern = "*.csv", recursive = T)

for (file in fileList){
  
  # if the merged sesnsor dataset doesn't exist, create it
  if (!exists("sensors")){
    sensors <- read_csv(file)
  }
  
  # if the merged sensor dataset does exist, append to it
  if (exists("sensors")){
    sensorsTemp <- read_csv(file)
    sensors <- bind_rows(sensors, sensorsTemp)
    rm(sensorsTemp)
  }
  
}


############################################################################
############################################################################