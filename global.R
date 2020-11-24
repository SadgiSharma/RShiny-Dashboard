library(lubridate)

data<- read.csv("coviddata.csv")

data$date <-month(ymd(data$date), label = TRUE, abbr = FALSE)
