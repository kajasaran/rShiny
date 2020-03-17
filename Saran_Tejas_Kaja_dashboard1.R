`library(ggplot2)
library(shiny)
library(sqldf)

data <- read.csv("ABC Healthcare Company Claims Dataset.csv")

ui<-shinyUI(fluidPage(    
  
  titlePanel("Dynamic Bar Chart of ABC HEALTHCARE based on PATIENT STATE"),
  
  sidebarLayout(
    sidebarPanel(
      
      selectInput("selected_bar", label = "Select Metric for Bar Plot:",
                  choices = c("Count of Patients in each state" = "Count of Patients in each state",
                              "Total Insurance Paid by each state" = "Total Insurance Paid by each state", 
                              "Total deductables paid by each state"="Total deductables paid by each state"),
                  
                  selected = "Count of Patients in each state"),
      sliderInput("month", "Select month:",
                  1,
                  12,
                  value = c(1, 12),
                  sep = "")
    ),   
    mainPanel(
      h3(textOutput("caption")),
      plotOutput("plot")
      
      
    )
  )
)
)

server<-shinyServer(function(input, output) {
  
  dataframe <- reactive({ 
    
    startDate = input$month[1]
    endDate = input$month[2]
    if (input$selected_bar=="Count of Patients in each state") {
      sql = sprintf("SELECT PATIENT_STATE,month,count(*) as metric FROM data where month between '%s' AND '%s' GROUP BY PATIENT_STATE  ",startDate,endDate)
    }
    
    if (input$selected_bar=="Total Insurance Paid by each state") {
      sql = sprintf("SELECT PATIENT_STATE,month,sum(TOTAL_PAID_BY_INSURANCE) as metric FROM data  where month between '%s' AND '%s' GROUP BY PATIENT_STATE  ",startDate,endDate)
    }
    
    if (input$selected_bar=="Total deductables paid by each state") {
      sql =sprintf("SELECT PATIENT_STATE,month,sum(PATIENT_DEDUCTIBLE) as metric FROM data  where month between '%s' AND '%s' GROUP BY PATIENT_STATE  ",startDate,endDate)
    }
    sqldf(sql)
  }
  )
  
  output$plot<-renderPlot({
    ytitle=input$selected_bar
    ggplot(dataframe(),mapping = aes(x=PATIENT_STATE,y=metric,fill = PATIENT_STATE))+
      geom_bar(stat = 'identity',show.legend = F)+
      xlab("PATIENT STATE")+
      ylab(ytitle)
  })
}
)


shinyApp(ui, server)
