
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
##                        Load data sets                        --
##---------------------------------------------------------------

###  The inspection files are obtained through 2 spreadsheets in 
###  .ods format, one containing the inspections of all apiaries 
###  in the years 2016 and 2017 and the other containing the 
###  inspections in the year 2018.

inspec1617 <- read_ods('data/inspection/2016-2017_Inspection_Table.ods', 
                      skip = 1, col_names = T)
inspec18 <- read_ods('data/inspection/2018_Inspection_Table.ods')


##---------------------------------------------------------------
##                        Data cleaning                        --
##---------------------------------------------------------------

###  The data file for the years 2016/17 has several apiaries, 
###  however, we will restrict ourselves to apiaries BBCC, Juniper, 
###  Beesboro, TBH and Lakeview. After, we select the variables 
###  of interest for modeling and in the end we restrict the 
###  inspection variables to be binary (0 or 1).

inspec1617 <- inspec1617 %>%
  filter(((ApiaryID == "BBCC") & (`Hive ID / Hive Tag ID` %in% c("HT102", "HT103", "HT105", "HT106", "HT107", "HT109"))) |
           ((ApiaryID == "Juniper Level") & (`Hive ID / Hive Tag ID` %in% c("HT108", "HT202", "HT205", "HT241"))) |
           ((ApiaryID == "Beesboro") & (`Hive ID / Hive Tag ID` %in% c("HT110", "HT211", "HT216", "HT219", "HT222", "HT223", "HT236", "HT242"))) |
           ((ApiaryID == "BBTS") & (`Hive ID / Hive Tag ID` %in% c("H628", "H869"))) |
           ((ApiaryID == "The Bee Hive") & (`Hive ID / Hive Tag ID` %in% c("H01", "H02", "H03", "H04"))) |
           ((ApiaryID == "Lakeview, UT") & (`Hive ID / Hive Tag ID` %in% c("H11", "H4", "H5")))) %>%
  transmute(Date = `Date (m/d/y)`,
            Apiary = if_else(ApiaryID == 'Lakeview, UT', 'Lakeview', ApiaryID), 
            Hive = `Hive ID / Hive Tag ID`, 
            Brood = `C1-All Stages Brood Present (1=Y, 0=N)`,
            Bees = `C2-Sufficient Adult Bees and Age Structure (1=Y, 0=N)`,
            Queen = `C3-Young Laying Queen Present (1=Y, 0=N)`,
            Food = `C4-Adequate Forage & Stores (1=Y, 0=N)`,
            Stressors = as.numeric(`C5-No Apparent Stressors Impacting Colony (1=Y, 0=N)`),
            Space = `C6-Hive Space Appropriate for Colony Size & Expected Needs (1=Y, 0=N)`) %>%
  filter(Brood %in% c(0, 1), Bees %in% c(0, 1), Queen %in% c(0, 1), Food %in% c(0, 1),
         Stressors %in% c(0, 1), Space %in% c(0, 1))

##----------------------------------------------------------------

###  The data file for the year 2018 has several apiaries, however, 
###  we will restrict ourselves to apiaries BBCC, Juniper, Beesboro, 
###  TBH and Lakeview. Some of these apiaries doesn't have the correct 
###  default name so we'll fix that. Afterwards, we select the variables 
###  of interest for the modeling and in the end we restrict the 
###  inspection variables to be binary (0 or 1).

inspec18 <- inspec18 %>%
  filter(((Apiary == "BBCC-RTP") & (HiveTag_ID %in% c("102", "103", "105", "106", "107", "109"))) |
           ((Apiary == "Juniper Level") & (HiveTag_ID %in% c("108", "202", "205", "241"))) |
           ((Apiary == "Beesboro") & (HiveTag_ID %in% c("110", "211", "216", "219", "222", "223", "236", "242"))) |
           ((Apiary == "BBTS") & (HiveTag_ID %in% c("628", "869"))) |
           ((Apiary == "The Bee Hive") & (HiveTag_ID %in% c("1", "2", "3", "4"))) |
           ((Apiary == "Lakeview") & (HiveTag_ID %in% c("11", "4", "5")))) %>%
  mutate(Date = InsptDate,
         Apiary = if_else(Apiary == 'BBCC-RTP', 'BBCC', Apiary), 
         Hive = if_else(Apiary %in% c('BBCC', 'Juniper Level', 'Beesboro'), 
                        paste0('HT', HiveTag_ID ),
                        if_else(Apiary %in% c('BBTS', 'Lakeview'), 
                                paste0('H', HiveTag_ID),
                                paste0('H0', HiveTag_ID)))) %>%
  select(Date, Apiary, Hive, Brood, Bees, Queen, Food, Stressors, Space) %>%
  filter(Brood %in% c(0, 1), Bees %in% c(0, 1), Queen %in% c(0, 1), Food %in% c(0, 1),
         Stressors %in% c(0, 1), Space %in% c(0, 1))


##---------------------------------------------------------------
##                      Combine data sets                      --
##---------------------------------------------------------------

### Let's concatenate the two data sets one below the other

inspec <- bind_rows(inspec1617, inspec18)


##---------------------------------------------------------------
##                    Export to a .csv file                    --
##---------------------------------------------------------------

write_csv(inspec, 'inspection.csv')

############################################################################
############################################################################

