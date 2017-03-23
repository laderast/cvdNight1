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
  
  trainMembership <- reactive({
    if(is.null(treeObj())){return(NULL)}
    return(where(treeObj()))
  })

  testMembership <- reactive({
    if(is.null(treeObj())){return(NULL)}
    return(where(treeObj(), newdata=testData()))
  })
  
  
  output$confusionMatrix <- renderTable({
    if(is.null(treeObj())){return(NULL)}
    
    out <- data.frame(predict=predict(treeObj()), truth=trainData()[[outcomeVar]])
    #print(head(out))
    tab <- table(out)
    tab
  })
  
  output$cartNode <- renderText({
    if(is.null(input$mouse_click)){return(NULL)}
    print(input$mouse_click)
  })
  
  output$groupUI <- renderUI({
    if(is.null(treeObj())){return(NULL)}
    
    membership <- trainMembership()
    membership <- sort(membership)
    choices <- unique(membership)
    
    out <- list()
    out <- list(out, selectInput("groupNumber", "Select Terminal Node to Summarize", 
                                 choices=membership, selected=membership[1]))
    
    return(tagList(out))
        
  })
  
  output$compareViolin <- renderPlot({
    
    if(is.null(trainMembership())){ return(NULL)}
    
    membership <- factor(trainMembership())
    outData <- trainData() %>% 
      mutate(membership = membership) 
    
    ggplot(outData, aes_string(x="membership", y=input$compareVar, fill="membership")) + geom_violin()
    
  })
  
  output$groupSummary <- renderPrint({
    if(is.null(input$groupNumber)){return(NULL)}
    if(is.null(treeObj())){return(NULL)}
    
    membership <- trainMembership()
    
    groupNum <- input$groupNumber
    groupData <- trainData() %>% mutate(membership = membership) %>% 
      dplyr::filter(membership == groupNum) %>% select(-membership)
        
    print(summary(groupData))
    
  })
  
  output$groupTable <- renderTable({
    membership <- trainMembership()
    table(membership, trainData()[[outcomeVar]])
  })
  
  output$testResponse <- renderPrint({
    
    if(is.null(treeObj())){return(NULL)}
    
    predictions <- predict(treeObj(), newdata=testData())
    outTab <- table(predictions, testData()[[outcomeVar]])
    
    accuracy <- sum(diag(outTab))/sum(outTab) * 100
    accuracy <- signif(accuracy, digits = 4)
    
    print(paste0("Accuracy of Model: ", accuracy, "%"))
    print(outTab)
    
  })
  
})
