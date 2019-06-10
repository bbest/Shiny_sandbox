library(shiny)
library(leaflet)
library(tidyverse)
#ui
ui <- fluidPage(
  titlePanel(h3("Habitat use at Carrizo Plain National Monument, USA")),
  sidebarLayout(
    sidebarPanel(
      sliderInput("total", "Frequency", min = min(data$total), max = max(data$total),
                  value = range(data$total), step = 1)
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
    leaflet() %>%
      addTiles() %>%
      addCircleMarkers(data$x_wgs, data$y_wgs, radius = 1, color = ifelse(data$total == "0", 'lightblue', 'red'))
  })
}

#generate app
shinyApp(ui, server)
