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

#load data. 
#note that for functions that come from specific packages (instead of base R)
# I often specify both package and function like so
#package::function() that's not required one could just call the function
#specifying the package makes it clearer where the function "lives",
#but it adds typing. You can do it either way.
rawdata <- readxl::read_excel(data_location)

#take a look at the data
View(rawdata)

#Filtering and selecting wanted Georgia data. The objective is to grab data for changes in proportion of vaccine hesitant and unsure with different demographic factors. 
processeddata <- rawdata %>% 
  dplyr::select("State", "County Name", "Estimated hesitant", "Estimated hesitant or unsure", "Estimated strongly hesitant", "Social Vulnerability Index (SVI)", "CVAC Level Of Concern", "Percent adults fully vaccinated against COVID-19 (as of 6/10/21)")%>%
  dplyr::filter( State == "GEORGIA" )
                             
#View processed data.
View(processeddata)


# save data as RDS

# location to save file
save_data_location <- here::here("data","processed_data","processeddata.rds")

saveRDS(processeddata, file = save_data_location)


