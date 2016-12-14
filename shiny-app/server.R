shinyServer(function(input, output){
  #output$graph <- renderPlot({
  #  source(file = "../main.R")
  #})

       output$text1 <- renderText({ 
          "You have selected this"
     })
})
