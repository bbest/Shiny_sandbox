library(shiny)
library(leaflet)
library(tidyverse)
#ui
ui <- fluidPage(
  titlePanel(h3("Habitat use at Carrizo Plain National Monument, USA")),
  sidebarLayout(
    sidebarPanel(
      sliderInput("shrub_cover", "Shrub cover", min = min(data$shrub_cover), max = max(data$shrub_cover),
                            value = range(data$shrub_cover), step = 0.1)
  ),
mainPanel = leafletOutput("map")
  )
)


#server
server <- function(input, output, session) {
  data <- read.csv("data/mcp20m.csv")
  filterdata <- reactive({
    data %>%
      filter(shrub_cover >= input$shrub_cover[1], total <= input$shrub_cover[2])
})
  
  output$map <- renderLeaflet({
    leaflet() %>%
      addTiles() %>%
      addCircleMarkers(data$x_wgs, data$y_wgs, radius = 1, color = ifelse(data$total == "0", 'lightblue', 'red'))
  })
}

observe({
  leafletProxy("map", data = filterdata()) %>%
    clearMarkers() %>%
    clearControls() %>%
    addCircleMarkers(data$x_wgs, data$y_wgs, radius = 1, color = ifelse(data$total == "0", 'lightblue', 'red'))
  
  
})
#generate app
shinyApp(ui, server)
