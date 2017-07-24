library(shiny)
library(ggplot2)
library(dplyr)
library(data.table)
library(tidyverse)

###Put Data processing steps here
#load dataset, loading strings as categorical data
#dataset <- fread("data/genoData.csv",stringsAsFactors = TRUE)
dataset <- fread("data/fullPatientData.csv",stringsAsFactors = TRUE)

#dataset <- dataset %>% filter(numAge > 50 & gender =="F") %>%
#  select(cvd, htn) 

#Uncomment this line to load the genetic data
#dataset <- fread("data/genoData.csv",stringsAsFactors = TRUE)
#make this variable a character
dataset$patientID <- as.character(dataset$patientID)
#make this variable an ordered categorical variable
dataset$age <- ordered(dataset$age)




##Don't modify anything below here, or app won't work properly.
##get the variable types
varClass <- sapply(dataset, class)
varClass <- lapply(varClass, function(x){if(length(x)>1)x <- x[2]; return(x)})

#separate the variables into each type
categoricalVars <- names(varClass[varClass %in% c("factor","ordered")])
numericVars <- names(varClass[varClass %in% c("numeric", "integer")])