library(shiny)
library(ggplot2)
library(dplyr)
library(data.table)

###Put Data processing steps here
#load dataset
dataset <- fread("data/fullPatientData.csv",stringsAsFactors = TRUE)
dataset$patientID <- as.character(dataset$patientID)
dataset$age <- ordered(dataset$age)

##Don't modify anything below here, or app won't work properly.
#get the variable types
varClass <- sapply(dataset, class)
varClass <- lapply(varClass, function(x){if(length(x)>1)x <- x[2]; return(x)})

#separate the variables into each type
categoricalVars <- names(varClass[varClass %in% c("factor","ordered")])
numericVars <- names(varClass[varClass %in% c("numeric", "integer")])