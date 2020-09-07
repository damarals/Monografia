
############################################################################
############################################################################
###                                                                      ###
###                        CLUSTERING WITH DBSCAN                        ###
###                                                                      ###
############################################################################
############################################################################

###  This .R file reads the final data set (sensors + climate 
###  + inspections), applies the gower distance function for mixed 
###  type data (categorical + continuous) and after clustering 
###  using the DBSCAN method.


##---------------------------------------------------------------
##                          Libraries                          --
##---------------------------------------------------------------

library(tidyverse) # Data Manipulation
library(lubridate) # Date Manipulation
library(cluster)   # Gower Distance and Cluster Tools


##---------------------------------------------------------------
##                        Load data set                        --
##---------------------------------------------------------------

###  Here we read the data set created by the dataset/merge.R 
###  file and which contains all the summary information of 
###  inspections, climatic data and sensor data.

bee <- read_csv('../dataset/data/finaldata.csv')


##---------------------------------------------------------------
##                    Gower distance object                    --
##---------------------------------------------------------------

###  Because we have mixed type variables in our dataset distances 
###  such as Euclidean, they do not fully reflect the behavior of 
###  a variable with 3 categories for example. We will then use 
###  the Gower distance, which basically includes in its functional 
###  form approaches for categorical and continuous variables.

gower <- daisy(bee %>%
                 mutate_at(.vars = vars(Season, Brood, Bees, Queen, Food, Stressors, Space),
                           .funs = list(~as_factor(.))) %>%
                 select(-c(Apiary, Hive, Latitude, Longitude, StationLat, StationLng)), 
               metric = "gower", stand = T)

gower <- as.matrix(gower)

parecidos <- bee[which(gower == min(gower[gower != min(gower)]), arr.ind = TRUE)[1, ], ]
distintos <- bee[which(gower == max(gower[gower != max(gower)]), arr.ind = TRUE)[1, ], ]


############################################################################
############################################################################