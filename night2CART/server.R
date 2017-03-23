
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
    #might want to use party (ctree()) instead - don't have to prune
    
    if(is.null(input$covariates)){
      return(NULL)
      #covariateString <- covariateNames[1]
    }else{
      covariateString <- paste(input$covariates, collapse = " + ")
    }
    formulaString <- paste(outcomeVar, "~", covariateString)
    
    #print(formulaString)
    #trainTree <- tree(Species ~ ., data=dataset)
    
    trainTree <- ctree(as.formula(formulaString), data=dataset)
    
    return(trainTree)
    })
  
  output$cartTree <- renderPlot({
    ##levels of interactivity
    #examineGroups: output summary for group
    if(is.null(treeObj())){return(NULL)}
    
    plot(treeObj())
    
  })

  output$confusionMatrix <- renderTable({
    if(is.null(treeObj())){return(NULL)}
    
    out <- data.frame(predict=predict(treeObj()), truth=dataOut()[[outcomeVar]])
    #print(head(out))
    tab <- table(out)
    tab
  })
  
  output$groupUI <- renderUI({
    membership <- where(treeObj())
    choices <- unique(membership)
    
    out <- list()
    out <- list(out, selectInput("groupNumber", "Select Terminal Node to Summarize", 
                                 choices=membership, selected=membership[1]))
    
    return(tagList(out))
        
  })
  
  output$groupSummary <- renderPrint({
    membership <- where(treeObj())
    
    if(is.null(input$groupNumber)){return(NULL)}
    if(is.null(treeObj())){return(NULL)}
    
    groupNum <- input$groupNumber
    groupData <- dataOut() %>% mutate(membership = membership) %>% 
      dplyr::filter(membership == groupNum)
        
    print(summary(groupData))
    
  })
  
  output$groupTable <- renderTable({
    membership <- where(treeObj())
    table(membership, dataOut()[[outcomeVar]])
  })
  
})
