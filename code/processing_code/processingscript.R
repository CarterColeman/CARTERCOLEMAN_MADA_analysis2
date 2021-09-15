###############################
# processing script
#
#this script loads the raw data, processes and cleans it 
#and saves it as Rds file in the processed_data folder

#load needed packages. make sure they are installed.
library(readxl) #for loading Excel files
library(dplyr) #for data processing
library(here) #to set paths

#path to data
#note the use of the here() package and not absolute paths
data_location <- here::here("data","raw_data","Vaccine_Hesitancy_CDC.xlsx")

#load vaccine hesitancy data. Here is a description of the data set: "[the included data set]shows estimates of COVID-19 vaccine hesitancy rates using data from the U.S. Census Bureau's Household Pulse Survey (HPS). We estimate hesitancy rates in two steps. First, we estimate hesitancy rates at the state level using the HPS for the collection period May 26, 2021 - June 7, 2021, which is referred to as Week 31. Then, we utilize the estimated values to predict hesitancy rates in more granular areas using the Census Bureau's 2019 American Community Survey (ACS) 1-year Public Use Microdata Sample (PUMS). To create county-level estimates, we used a PUMA-to-county crosswalk from the Missouri Census Data Center. PUMAs spanning multiple counties had their estimates apportioned across those counties based on overall 2010 Census populations."

rawdata <- readxl::read_excel(data_location)

#take a look at the data
View(rawdata)

#Filtering and selecting wanted Georgia data. The objective is to grab data for changes in proportion of vaccine hesitant and unsure in the population (dependent variable) with different demographic factors.
#The independent variables that I decided to look at were Social Vulnerability Index (SVI), CVAC Level Of Concern, Percent adults fully vaccinated against COVID-19 (as of 6/10/21).
processeddata <- rawdata %>% 
  dplyr::select("State", "County Name", "Estimated hesitant", "Estimated hesitant or unsure", "Estimated strongly hesitant", "Social Vulnerability Index (SVI)", "CVAC Level Of Concern", "Percent adults fully vaccinated against COVID-19 (as of 6/10/21)")%>%
  dplyr::filter( State == "GEORGIA" )
                             
#View processed data.
View(processeddata)


# save data as RDS

# location to save file
save_data_location <- here::here("data","processed_data","processeddata.rds")

saveRDS(processeddata, file = save_data_location)


