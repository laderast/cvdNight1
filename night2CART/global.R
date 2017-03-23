library(shiny)
library(ggplot2)
library(dplyr)
library(party)

###Put Data processing steps here
###This is a test using the iris dataset
###You can load any data here, just name it "dataset"

dataset <- iris
outcomeVar <- "Species"
dataset <- dataset %>% mutate(sepalRatio=Sepal.Length/Sepal.Width, petalRatio = Petal.Length/Petal.Width)

##Build test and train sets of data
trainIndex <- sample(nrow(dataset), size = floor(0.75 * nrow(dataset)))
trainDataset <- dataset[trainIndex,]
testDataset <- dataset[-trainIndex,]

##Find covariate names
covariateNames <- colnames(dataset)[!colnames(dataset) %in% outcomeVar]

##Don't modify anything below here, or app won't work properly.
#get the variable types
varClass <- sapply(dataset, class)

#separate the variables into each type
categoricalVars <- names(varClass[varClass == "factor"])
numericVars <- names(varClass[varClass %in% c("numeric", "integer")])

