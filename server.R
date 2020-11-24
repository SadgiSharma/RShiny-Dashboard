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