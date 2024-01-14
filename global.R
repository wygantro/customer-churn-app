library(dplyr)
library(DT)
library(ggplot2)
library(readr)
library(shiny)
library(shinydashboard)
library(shinythemes)
library(tidyr)
library(tidyverse)

# load customer churn and map data set
churn_modeling <- read_csv(file = "./churn_modeling_updated.csv")
mapdata <- read_csv(file = "./mapdata.csv")

# define customer specific categories
Geography_factor <- c("France", "Spain", "Germany")
Gender_factor <- c("All", "Female", "Male")
Age_factor <- c("All", "18 - 29", "30 - 39", "40 - 49", "50 - 59",
                "60 - 69", "70 - 79", "80 - 89", "90 - 100")
CreditScore_factor <- c("All", 800, 700, 600, 500, 400, 300)

# define company specific segments
Tenure_factor <- c("All", 0, 1, 2, 3, 4, 5, 6, 7, 8, 9, 10)
HasCrCard_factor <- c("All", "yes", "no")
NumOfProducts_factor <- c("All", 1, 2, 3, 4)
IsActiveMember_factor <- c("All", "yes", "no")

SelectCategory_1_factor <- c("Tenure", "HasCrCard",
                             "NumOfProducts", "IsActiveMember")