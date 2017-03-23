library(shiny)

shinyServer(function(input, output) {

  #trainData is a "reactive" dataset - you can add live filtering criteria here
  #to use this reactive, notice you have to use trainData() rather than just trainData
  #in this expression
  trainData <- reactive({
    trainDataset
  })
  
  testData <- reactive({
    testDataset
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
    
    trainTree <- ctree(as.formula(formulaString), data=trainData())
    
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
    
    out <- data.frame(predict=predict(treeObj()), truth=trainData()[[outcomeVar]])
    #print(head(out))
    tab <- table(out)
    tab
  })
  
  output$groupUI <- renderUI({
    if(is.null(treeObj())){return(NULL)}
    
    membership <- where(treeObj())
    membership <- sort(membership)
    choices <- unique(membership)
    
    out <- list()
    out <- list(out, selectInput("groupNumber", "Select Terminal Node to Summarize", 
                                 choices=membership, selected=membership[1]))
    
    return(tagList(out))
        
  })
  
  output$groupSummary <- renderPrint({
    if(is.null(input$groupNumber)){return(NULL)}
    if(is.null(treeObj())){return(NULL)}
    
    membership <- where(treeObj())
    
    groupNum <- input$groupNumber
    groupData <- trainData() %>% mutate(membership = membership) %>% 
      dplyr::filter(membership == groupNum)
        
    print(summary(groupData))
    
  })
  
  output$groupTable <- renderTable({
    membership <- where(treeObj())
    table(membership, trainData()[[outcomeVar]])
  })
  
  output$testResponse <- renderPrint({
    
    predictions <- predict(treeObj(), newdata=testData())
    table(predictions, testData()[[outcomeVar]])
    
    #pull calls as max
  })
  
})
