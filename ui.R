library(shiny)

# Define UI for application that draws a histogram
shinyUI(
    fluidPage(
        titlePanel("Next Word Prediction"),
        textInput("text", width = 500, label = h2("Enter sentence here:"), value = ""),
        hr(),
  fluidRow(plotOutput("distPlot"))
))
