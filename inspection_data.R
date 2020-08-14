
############################################################################
############################################################################
###                                                                      ###
###                         LOAD INSPECTION DATA                         ###
###                                                                      ###
############################################################################
############################################################################


###  This .R archive makes a load of the two files in ./files 
###  and preprocess the hive and apiary for get the data final 
###  of inspections.                


##---------------------------------------------------------------
##                          Libraries                          --
##---------------------------------------------------------------

library(tidyverse) # Data Manipulation
library(readODS)   # Read .ods Files


##---------------------------------------------------------------
##                        Load Datasets                        --
##---------------------------------------------------------------

###  The inspection files are obtained through 2 spreadsheets in 
###  .ods format, one containing the inspections of all apiaries 
###  in the years 2016 and 2017 and the other containing the 
###  inspections in the year 2018.

inspec1617 <- read_ods('data/inspection/2016-2017_Inspection_Table.ods', 
                      skip = 1, col_names = T)
inspec18 <- read_ods('data/inspection/2018_Inspection_Table.ods')

##----------------------------------------------------------------

############################################################################
############################################################################

