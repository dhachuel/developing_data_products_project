library(shiny)
library(leaflet)
library(RCurl)
library(rjson)

shinyUI(bootstrapPage(
  tags$style(type = "text/css", 
             "html,body {width:100%;height:100%}
    #input_panel {background-color: white;padding: 10px;border-radius: 5px;}
    "),
  leafletOutput("map", width = "100%", height = "100%"),
  absolutePanel(
    div(id='input_panel',
        h2('Shiny Weather!'),
        h4('To get started enter any location.'),
        h4('Enjoy!')
    ),
    top = 10, right = 10,
    textInput(
      "input_location","Input Location",
      value = "New York, 10014"
    ),
    selectInput(
      "input_scale", "Choose Temperature Scale",
      c("Celcius","Fahrenheit")
    )
  )
))