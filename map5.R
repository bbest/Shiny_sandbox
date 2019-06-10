library(shiny)
library(leaflet)
library(tidyverse)
#ui
ui <- fluidPage(
  titlePanel(h3("Habitat use at Carrizo Plain National Monument, USA")),
  sidebarLayout(
    sidebarPanel(
      sliderInput("shrub_cover", "shrub cover", min = min(data$shrub_cover), max = max(data$shrub_cover),
                  value = range(data$shrub_cover), step = 0.1),
      sliderInput("elevation", "elevation", min = min(data$elevation), max = max(data$elevation),
                  value = range(data$elevation), step = 1)
    ),
    mainPanel = leafletOutput("map")
  )
)


#server
server <- function(input, output, session) {
  #get data
  data <- read.csv("data/mcp20m.csv")
  
#map
output$map <- renderLeaflet({
    leaflet() %>%
      addTiles() %>%
      addCircleMarkers(data$x_wgs, data$y_wgs, radius = 1, color = ifelse(data$total == "0", 'lightblue', 'red'))
  })


#data filter
filterdata <- reactive({
  data %>%
    filter(shrub_cover >= input$shrub_cover[1], shrub_cover <= input$shrub_cover[2]) %>%
    filter(elevation >= input$elevation[1], elevation <= input$elevation[2])
}) 

#plot  
observe({
  leafletProxy("map", data = filterdata()) %>%
    clearMarkers() %>%
    addCircleMarkers(data$x_wgs, data$y_wgs, radius = 1, color = ifelse(data$total == "0", 'lightblue', 'red'))
})
}
#generate app
shinyApp(ui, server)
