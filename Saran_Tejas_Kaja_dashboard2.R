#install.packages("shiny")
library(shiny)
library(ggplot2)

data2<-read.csv("Global Superstore Orders 2016.csv")


ui<-shinyUI(fluidPage(
  
  
  titlePanel("Dynamic Scatter Plot of Global Superstore Orders"),
  sidebarLayout(
    sidebarPanel(
      
      radioButtons("x", "Select first column of dataset:",
                   list("Sales"='sales', "Quantity"='quantity', "Profit"='profit', "Shipping.Cost"='shipping')),
      
      selectInput("y", "Select second column of dataset:",
                   list("Sales"='sales', "Quantity"='quantity', "Profit"='profit', "Shipping.Cost"='shipping')),
      numericInput("size", "ScatterPlot size", 1, 2)
      
    ),
    
    mainPanel(
      plotOutput("distPlot")
    )
  )
))


server<-shinyServer(function(input, output) {
  
  
  output$distPlot <- renderPlot({
     
    reduced<- data2[,c("Sales","Quantity","Profit","Shipping.Cost")]
    
    
   
    if(input$x=='sales'){
      i<-1
    }
    
    if(input$x=='quantity'){
      i<-2
    }
    
    if(input$x=='profit'){
      i<-3
    }
    
    if(input$x=='shipping'){
      i<-4
    }
    
    
   
    if(input$y=='sales'){
      j<-1
    }
    
    if(input$y=='quantity'){
      j<-2
    }
    
    if(input$y=='profit'){
      j<-3
    }
    
    if(input$y=='shipping'){
      j<-4
    }
    
    
   
    plot(reduced[[i]],
         reduced[[j]],
         cex = input$size,
         xlab = input$x,
         ylab = input$y)
    
  })
})

shinyApp(ui, server)
