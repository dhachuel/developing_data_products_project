library(shiny)
library(leaflet)
library(RCurl)
library(rjson)


shinyServer(function(input, output, session) {
  # Fetch temperature scale
  input_scale <- reactive({
    return(input$input_scale)
  })
  
  output$map <- renderLeaflet({
    # Clean input location
    
    location <- gsub(pattern = " ", replacement = "%20", x = input$input_location)
    
    # Base geolocation Google API endpoint
    ggapi_url <- "http://maps.googleapis.com/maps/api/geocode/json?address="
    
    # Get coordinates and address from zip code
    geo_data <- fromJSON(getURL(url = paste(ggapi_url, location, sep='')))
    formatted_address <- geo_data[1]$results[[1]]$formatted_address
    lat <- as.numeric(geo_data[1]$results[[1]]$geometry$bounds$northeast$lat)
    lng <- as.numeric(geo_data[1]$results[[1]]$geometry$bounds$northeast$lng)
    
    # Get weather data from OpenWeatherMap
    weather_url <- paste(
      "http://api.openweathermap.org/data/2.5/weather?lat=",
      lat,
      "&lon=",
      lng,
      sep='')
    weather_data <- fromJSON(getURL(url = weather_url))
    weather.main <- weather_data$weather[[1]]$main
    weather.description <- weather_data$weather[[1]]$description
    weather.temp <- round(weather_data$main$temp - 273.15,1) # Celcius scale
    weather.unit <- "C"
    if(input_scale() == "Fahrenheit"){
      weather.unit <- "F"
      weather.temp <-  round(weather.temp * 9/5 + 32, 1)
    }
    
    weather.icon <- paste(
      "http://openweathermap.org/img/w/",
      weather_data$weather[[1]]$icon,
      ".png",
      sep=''
    )
    
    
    content <- paste(
      sep = "",
      paste("<center><h2>",formatted_address,"</h2></center>",sep=''),
      paste("<center><img src='",weather.icon,"'></center>",sep=''),
      paste("<center><h1>",weather.temp," &#186",weather.unit,"</h1></center>",sep=''),
      paste("<center><strong>",weather.main,"</strong>: ",weather.description,"</center>",sep='')
    )
    
    
    leaflet() %>% 
      addTiles() %>%
      addPopups(lng, lat, content,
                options = popupOptions(closeButton = FALSE)
      ) %>% 
      addProviderTiles("Thunderforest.TransportDark") 
  })
  
})