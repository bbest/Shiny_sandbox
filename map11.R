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
  df <- read.csv(url("https://ndownloader.figshare.com/files/15437489"))
  filtered_df <- reactive({
    df %>%
      filter(shrub_cover >= input$shrub_cover[1] & shrub_cover <= input$shrub_cover[2])
  })
  
  output$map <- renderLeaflet({
    t.class <- colorFactor("Blues", df$status, levels = TRUE)
    leaflet() %>%
      addTiles() %>%
      addCircleMarkers(df$x_wgs, df$y_wgs, radius = 1, color = ifelse(df$status == "0", 'lightblue', 'red'))
  })
  
  observe({
    t.class <- colorFactor("Blues", filtered_df$status, levels = TRUE)
    leafletProxy("map", data = filtered_df()) %>%
      clearMarkers() %>%
      addCircleMarkers(df$x_wgs, df$y_wgs, radius = 1, color = ifelse(filtered_df$status == "0", 'lightblue', 'red'))
  })  

}
    
#generate app
shinyApp(ui, server)
