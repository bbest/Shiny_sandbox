library(shiny)
library(leaflet)
library(tidyverse)

#ui
ui <- fluidPage(
  titlePanel(h3("Habitat use at Carrizo Plain National Monument, USA")),
  sidebarLayout(
    sidebarPanel(
      sliderInput("shrub_cover", "Shrub cover", min = 0, max = 10,
                  value = 5, step = 1)
    ),
    mainPanel = leafletOutput("map")
  )
)


#server
server <- function(input, output, session) {
  df <- read.csv("data/mcp20m.csv")
  filtered_df <- reactive({
    df[df$shrub_cover >= input$slider, ]
  })
  
  output$map <- renderLeaflet({
    leaflet() %>%
      addTiles() %>%
      addCircleMarkers(df$x_wgs, df$y_wgs, radius = 1, color = ifelse(filtered_df$status == "0", 'lightblue', 'red'))
  })
  
  
}

#generate app
shinyApp(ui, server)
