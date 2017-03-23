
# This is the user-interface definition of a Shiny web application.
# You can find out more about building applications with Shiny here:
#
# http://shiny.rstudio.com
#

library(shiny)

shinyUI(navbarPage(

  # Application title
  "Tree Analysis",

  # Sidebar with a slider input for number of bins
    tabPanel("Tree Explorer",
              selectInput("covariates", "Select Covariates for Model", 
                                choices = covariateNames, multiple=TRUE),
              fluidRow(
                column(width=9,plotOutput("cartTree", click="mouse_click")),
                column(width=3, tableOutput("confusionMatrix"))
              ),
              uiOutput("groupUI"),
              verbatimTextOutput("groupSummary")#,
              #verbatimTextOutput("cartNode")
             ),
    tabPanel("Compare Nodes",
              selectInput("compareVar", "Select Covariate to Compare", 
                          choices=covariateNames),
              plotOutput("compareViolin")
             ),
    
    tabPanel("Test Group Accuracy",
             verbatimTextOutput("testResponse")
             )
    
  
    #add group comparison?
    #add evaluate on test data?
))
