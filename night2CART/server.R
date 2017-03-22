
# This is the server logic for a Shiny web application.
# You can find out more about building applications with Shiny here:
#
# http://shiny.rstudio.com
#

library(shiny)

shinyServer(function(input, output) {

  #dataOut is a "reactive" dataset - you can add live filtering criteria here
  #to use this reactive, notice you have to use dataOut() rather than just dataOut
  #in this expression
  dataOut <- reactive({
    dataset
  })
  
  
  treeObj <- reactive({ 
    #outcomeVariable: outcome of interest
    #checkboxGroup: which variables to include
    #pruneTree: pruning functions
    
    #might want to use party (ctree()) instead - don't have to prune
    
    trainTree <- tree(Species ~ ., data=dataset)
    
    return(trainTree)
    })
  
  output$treePlot <- renderPlot({
    ##levels of interactivity
    #examineGroups: output summary for group
    
  })

  output$groupTable <- renderTable({
    
  })
  
})
