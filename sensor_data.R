
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


##----------------------------------------------------------------
##                       Summarize by day                       --
##----------------------------------------------------------------

###  We will summarize the data so that each hive contains only the 
###  summary measures: Minimum, Median and Maximum for each day. 
###  That is, given a specific day, obtain these summary measures 
###  for each hive.

sensors %>%
  mutate(Date = date(`Date Time`),
         TemperatureInt = (`Temperature [F]` - 32)*(5/9),
         Weight = `Weight [lbs]`/2.2046,
         Apiary = if_else(Apiary == 'The_Bee_Hive', 'The Bee Hive', Apiary)) %>%
  group_by(Apiary, Hive, Date) %>%
  summarize(across(TemperatureInt:Weight, 
                   .fns = list(Min = ~min(.), 
                               Median = ~median(.), 
                               Max = ~max(.)),
                   .names = "{fn}{col}"))


############################################################################
############################################################################