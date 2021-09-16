###############################
# analysis script
#
#this script loads the processed, cleaned data, does a simple analysis
#and saves the results to the results folder

#load needed packages. make sure they are installed.
library(ggplot2) #for plotting
library(broom) #for cleaning up output from lm()
library(here) #for data loading/saving
library(tidyverse)

#path to data
#note the use of the here() package and not absolute paths
data_location <- here::here("data","processed_data","processeddata.rds")

#load data. 
mydata <- readRDS(data_location)

######################################
#Data exploration/description
######################################
#I'm using basic R commands here.
#Lots of good packages exist to do more.
#For instance check out the tableone or skimr packages

#summarize data 
mysummary = summary(mydata)

#look at summary
print(mysummary)
print(mydata$`County Name`)

#make a scatter plot of the estimate hesitant of getting the vaccine with Social Vulnerability index.
#we also add a linear regression line to it with labels for the lowest combination of SVI and hesitance.
plot1 <- mydata %>% ggplot(aes(x=`Social Vulnerability Index (SVI)`, y = `Estimated hesitant or unsure`, label=`County Name`)) + 
  geom_point() + geom_smooth(method='lm') + 
  geom_text(aes(label=ifelse(`Social Vulnerability Index (SVI)` < 0.30 & `Estimated hesitant or unsure` < 0.19 ,as.character(`County Name`),'')),hjust=0,vjust=0) +
  ggtitle("Scatterplot of Hesitance and SVI")

#Scatterplot of Vaccinated adults and hesitance for each county in Georgia showing an outlier county
#with a linear regression line
plot2 <- mydata %>% ggplot(aes(x= `Percent adults fully vaccinated against COVID-19 (as of 6/10/21)` , y = `Estimated hesitant or unsure`, label=`County Name`)) + 
  geom_point() + geom_smooth(method='lm') +  
  geom_text(aes(label=ifelse(`Percent adults fully vaccinated against COVID-19 (as of 6/10/21)` > 0.75 ,as.character(`County Name`),'')),hjust=0.9,vjust=0.24) + 
  ggtitle("Scatterplot of percentages of adults vaccinated per county and hesitance")

#Scatterplot of Vaccinated adults and hesitance for each county in Georgia without the outlier. There is a labeling of
#counties with the highest percentage of adults fully vaccinated.
plot3 <- mydata %>% filter(`Percent adults fully vaccinated against COVID-19 (as of 6/10/21)`<= 0.95) %>%
  ggplot(aes(x= `Percent adults fully vaccinated against COVID-19 (as of 6/10/21)` , y = `Estimated hesitant or unsure`, label=`County Name`)) + 
  geom_point() + geom_smooth(method='lm') +  
  geom_text(aes(label=ifelse(`Percent adults fully vaccinated against COVID-19 (as of 6/10/21)` > 0.35 ,as.character(`County Name`),'')),hjust=0.5,vjust=0) + 
  ggtitle("Scatterplot of percentages of adults vaccinated per county and hesitance removing outlier")

#Boxplot of hesitance for each CVAC level
plot4 <- mydata %>% ggplot(aes(x= `CVAC Level Of Concern`, y = `Estimated hesitant or unsure`)) + geom_boxplot() +
  ggtitle("Side-by-side boxplots of hesitance by CVAC level of Concern")

#Summary table of hesitance groups by the CVAC level of concern. This includes the means and the standard deviation. 
hesitancetable <- mydata %>% select(`Estimated hesitant or unsure`, `CVAC Level Of Concern`) %>% group_by(`CVAC Level Of Concern`) %>%
  summarize(average = mean(`Estimated hesitant or unsure`), standard_deviation = sd(`Estimated hesitant or unsure`))


#save data frame table to file for later use in manuscript
summarytable_file = here("results", "summarytable.rds")
saveRDS(mysummary, file = summarytable_file)

#save hesitance and CVAC table to file for later use in manuscript
hesitancesummarytable_file = here("results", "hesitancesummarytable.rds")
saveRDS(hesitancetable, file = hesitancesummarytable_file)


#look at figure1
plot(plot1)

#save plot1
figure1_file = here("results","figure1.png")
ggsave(filename = figure1_file, plot=plot1) 

#save plot2
figure2_file = here("results","figure2.png")
ggsave(filename = figure2_file, plot=plot2) 

#save plot3
figure3_file = here("results","figure3.png")
ggsave(filename = figure3_file, plot=plot3) 

#save plot4
figure4_file = here("results","figure4.png")
ggsave(filename = figure4_file, plot=plot4) 

  