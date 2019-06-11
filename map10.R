library(shiny)
library(leaflet)
library(tidyverse)
#ui
ui <- fluidPage(
  titlePanel(h3("Habitat use at Carrizo Plain National Monument, USA")),
  sidebarLayout(
    sidebarPanel(
      sliderInput("total", "Frequency", min = 0, max = 55,
                  value = 55, step = 1)
    ),
    mainPanel = leafletOutput("map")
  )
)


#server
server <- function(input, output, session) {
  data <- read.csv("data/mcp20m.csv")
  filteredData <- reactive({
    data %>%
      filter(total >= input$total[1], total <= input$total[2])
  })
  
  output$map <- renderLeaflet({
    leaflet(filteredData) %>%
      addTiles() %>%
      addCircleMarkers(filteredData$x_wgs, filteredData$y_wgs, radius = 1, color = ifelse(filteredData$total == "0", 'lightblue', 'red'))
  })
}

#generate app
shinyApp(ui, server)
