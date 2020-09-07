
###########################################################################
###########################################################################
###                                                                     ###
###                         FEATURE ENGINEERING                         ###
###                                                                     ###
###########################################################################
###########################################################################

##  


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

merged_data <- read_csv('./data/mergedata.csv')


##----------------------------------------------------------------
##                       Create variables                       --
##----------------------------------------------------------------

##  Vamos criar seguintes as variáveis:
##  1. Season (Estação do ano):

getSeason <- function(input.date){
  numeric.date <- 100*month(input.date)+day(input.date)
  ## input Seasons upper limits in the form MMDD in the "break =" option:
  cuts <- base::cut(numeric.date, breaks = c(0,319,0620,0921,1220,1231)) 
  # rename the resulting groups (could've been done within cut(...levels=) 
  #   if "Winter" wasn't double
  levels(cuts) <- c("Winter","Spring","Summer","Fall","Winter")
  return(cuts)
}

final_data <- merged_data %>%
  mutate(Season = getSeason(Date), .after = Date) %>%
  select(-Date)


##---------------------------------------------------------------
##                    Export to a .csv file                    --
##---------------------------------------------------------------

write_csv(final_data, './data/finaldata.csv')


############################################################################
############################################################################