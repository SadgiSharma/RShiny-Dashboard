# RShiny-Dashboard-

Global File
library(lubridate)

data<- read.csv("coviddata.csv")

data$date <-month(ymd(data$date), label = TRUE, abbr = FALSE)


Server File
library(shiny)
library(plotly)
library(scales)

function(input, output) {
  
  output$table <- DT::renderDataTable({
    
    if (input$mon != "All") {
      data <- data[data$date == input$mon,]
    }else{
      data<-data
    }
    
    if (input$con != "All") {
      data <- data[data$continent == input$con,]
    }else{
      data<-data
    }
    
    data<-data.frame(data)
    data<-data[,c("continent", "new_cases","new_deaths","total_deaths_per_million")]
    #colnames(data)<-c("Location","New Cases","New deaths", "Deaths Per Million")

  })
  
  output$plot <- renderPlotly({
    
    if (input$mon != "All") {
      data <- data[data$date == input$mon,]
    }else{
      data<-data
    }
    
    if (input$con != "All") {
      data <- data[data$continent == input$con,]
    }else{
      data<-data
    }
    
    data<-data[complete.cases(data),]
    
    data<-data %>% group_by(date) %>% summarise(Total_Cases=sum(total_cases))
    
    data %>% plot_ly(x=~date,y=~Total_Cases,type="bar",text=~label_number_si(accuracy=.01)(Total_Cases),textposition = 'outside')
  })
  
}

UI File
library(shiny)
library(lubridate)
library(DT)
library(plotly)

names(data)[which(names(data)=="date")]<-"MONTH"
fluidPage(
  titlePanel("Covid DataTable"),
  
  # Create a new Row in the UI for selectInputs
  fluidRow(
    column(4,
           selectInput("mon",
                       "Month:",
                       c("All",
                         unique(as.character(data$MONTH)))
           ),
           column(4,
                  selectInput("con",
                              "continent:",
                              c("All",
                                unique(as.character(data$continent))))
           ),
    )
  ),
  # Create a new row for the table.
  DT::dataTableOutput("table"),
  plotlyOutput("plot")
)
