library(shiny)
library(dplyr)
library(tidyr)
library(ggplot2)
library(readr)
library(shinydashboard)
library(shinythemes)
library(tidyverse)
library(DT)

churn_modeling <- read_csv(file = "./churn_modeling_updated.csv")
mapdata <- read_csv(file = "./mapdata.csv")

#customer specific categories
Geography_factor <- c("France", "Spain", "Germany") #location (categorical nominal)
Gender_factor <- c("All", "Female", "Male") #gender (categorical nominal)
Age_factor <- c("All", "18 - 29", "30 - 39", "40 - 49", "50 - 59", "60 - 69", "70 - 79", "80 - 89", "90 - 100") #age (categorical ordinal)
CreditScore_factor <- c("All", 800, 700, 600, 500, 400, 300) #credit score (categorical ordinal)

#company specific segments
Tenure_factor <- c("All", 0, 1, 2, 3, 4, 5, 6, 7, 8, 9, 10) #years as user (categorical ordinal)
HasCrCard_factor <- c("All", "yes", "no") #has the credit card or not (categorical nominal binary)
NumOfProducts_factor <- c("All", 1, 2, 3, 4) #number of products used (categorical ordinal)
IsActiveMember_factor <- c("All", "yes", "no") #currently an active member or not (categorical ordinal binary)

SelectCategory_1_factor <- c("Tenure", "HasCrCard", "NumOfProducts", "IsActiveMember")

