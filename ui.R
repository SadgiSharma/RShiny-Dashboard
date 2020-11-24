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