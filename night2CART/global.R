library(shiny)
library(ggplot2)
library(dplyr)
library(party)

###Put Data processing steps here
#load dataset A

# datasetA <- read.delim("data/datasetA.txt",row.names = 1)
# datasetA <- datasetA %>% filter(startWeights != 9999 & endWeights != 9999)
# datasetA <- datasetA %>% mutate(weightLoss = startWeights - endWeights, weightLossPerDay = weightLoss / timeElapsed)
# datasetA <- na.omit(datasetA)
# dataset <- datasetA

dataset <- iris
dataset <- dataset %>% mutate(sepalRatio=Sepal.Length/Sepal.Width, petalRatio = Petal.Length/Petal.Width)

trainIndex <- sample(nrow(dataset), size = floor(0.75 * nrow(dataset)))
trainDataset <- dataset[trainIndex,]
testDataset <- dataset[-trainIndex,]

outcomeVar <- "Species"

covariateNames <- colnames(dataset)[!colnames(dataset) %in% outcomeVar]

#Code to process dataset B

#Code to combine the two datasets
#Here we select columns for each dataset (treatment and weight)
#in order to make the two datasets comparable, we make both genders lowercase 
#(coverting it to a character), but then we have to recast it as a 
#factor (categorical variable)
# datasetAselect <- datasetA %>% mutate(site="A", gender=factor(tolower(gender))) %>% 
#   select(treatment, weightLossPerDay, site, gender)
# 
# datasetBselect <- datasetB %>% mutate(site="B", gender=factor(tolower(gender))) %>% 
#   select(treatment, weightLossPerDay, site, gender)

#dataset <- rbind(datasetAselect, datasetBselect)

#have to recast site as a factor because it's a character
#dataset$site <- factor(dataset$site)


##Don't modify anything below here, or app won't work properly.
#get the variable types
varClass <- sapply(dataset, class)

#separate the variables into each type
categoricalVars <- names(varClass[varClass == "factor"])
numericVars <- names(varClass[varClass %in% c("numeric", "integer")])

