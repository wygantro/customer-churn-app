library(shiny)
library(dplyr)
library(tidyr)
library(ggplot2)
library(readr)
library(tidyverse)

churn_modeling <- read_csv(file = "./churn_modeling.csv")

#inspect initial dataframe
print(summary(churn_modeling))

#delete customer specific data columns
churn_modeling <- churn_modeling %>% select(-c(RowNumber, CustomerId, Surname))

churn_modeling$CreditScore <- cut(churn_modeling$CreditScore, breaks = c(0, 100, 200, 300, 400, 500, 600, 700, 800, 850), include.lowest = T, right = F)
levels(churn_modeling$CreditScore) <- c(0, 100, 200, 300, 400, 500, 600, 700, 800, 850)

#binning credit score column by level (by range = 10 years)
churn_modeling$Age <- cut(churn_modeling$Age, breaks = c(0, 30, 40, 50, 60, 70, 80, 90, 100), include.lowest = T, right = F)
levels(churn_modeling$Age) <- c('18 - 29', '30 - 39', '40 - 49', '50 - 59', '60 - 69', '70 - 79', '80 - 89', '90 - 100')

#numeric "Balance" values to integers
churn_modeling$Balance <- floor(churn_modeling$Balance)

#rename HasCrCard output from binary to string ("no"=0, "yes"=1)
churn_modeling$HasCrCard[churn_modeling$HasCrCard == 0] <- "no"
churn_modeling$HasCrCard[churn_modeling$HasCrCard == 1] <- "yes"

#rename IsActiveMember output from binary to string ("no"=0, "yes"=1)
churn_modeling$IsActiveMember[churn_modeling$IsActiveMember == 0] <- "no"
churn_modeling$IsActiveMember[churn_modeling$IsActiveMember == 1] <- "yes"

#numeric "EstimatedSalary" values to integers
churn_modeling$EstimatedSalary <- floor(churn_modeling$EstimatedSalary)

#rename exited/churn output from binary to string ("no"=0, "yes"=1)
churn_modeling$Exited[churn_modeling$Exited == 0] <- "no"
churn_modeling$Exited[churn_modeling$Exited == 1] <- "yes"

View(churn_modeling)
write_csv(churn_modeling, "./churn_modeling_updated.csv")

#mapping data

mapdata <- map_data("world")

#rename country name column to "Geography" to match churn_modeling
colnames(mapdata)[5]='Geography'

#initialize european region
european_countries <- c("Portugal", "Spain", "France", "UK", "Ireland", "Italy", "Switzerland", "Austria", "Germany", "Belgium", "Netherlands", "Denmark", "Norway", "Sweden", "Finland", "Luxembourg", "Andorra", "Poland", "Czech Republic", "Slovakia", "Hungary", "Slovenia")
mapdata <- mapdata[mapdata$Geography %in% european_countries ,]

#create binary columns for countries present in churn_modeling$Geography
mapdata <- mapdata %>% 
  mutate("France_NA_NA" = ifelse(Geography=="France",1,0)) %>%
  mutate("Spain_NA_NA" = ifelse(Geography=="Spain",1,0)) %>%
  mutate("Germany_NA_NA" = ifelse(Geography=="Germany",1,0)) %>%
  mutate("France_Spain_NA" = ifelse(Geography=="France" | Geography=="Spain",1,0)) %>%
  mutate("Spain_Germany_NA" = ifelse(Geography=="Spain" | Geography=="Germany",1,0)) %>%
  mutate("France_Germany_NA" = ifelse(Geography=="France" | Geography=="Germany",1,0)) %>%
  mutate("France_Spain_Germany" = ifelse(Geography=="France" | Geography=="Spain" | Geography=="Germany",1,0))

#view(mapdata_filt)
write_csv(mapdata, "./mapdata.csv")