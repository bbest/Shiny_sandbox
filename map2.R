library(shiny)
library(leaflet)

#ui
ui <- fluidPage(
  leafletOutput("map"),
  absolutePanel(top = 10, right = 10,
                sliderInput("shrub_cover", "Shrub cover", min(data$total), max(data$total),
                            value = range(data$total), step = 0.1
                )
  )
)


#server
server <- function(input, output, session) {
  data <- read.csv("data/mcp20m.csv")
  filteredData <- reactive({
    data[data$total >= input$range[1] & data$total <= input$range[2],]
  })
  
  output$map <- renderLeaflet({
    # Use leaflet() here, and only include aspects of the map that
    # won't need to change dynamically (at least, not unless the
    # entire map is being torn down and recreated).
    leaflet(data) %>% addTiles() %>%
      fitBounds(~min(x_wgs), ~min(y_wgs), ~max(x_wgs), ~max(y_wgs))
  })
  
  observe({
    t.class <- colorFactor("Blues", filteredData$total, levels = TRUE)
    leafletProxy("map", data = filteredData()) %>%
      addCircleMarkers(filteredData$x_wgs, filteredData$y_wgs, radius = 1, color = ifelse(filteredData$total == "0", 'lightblue', 'red'))
  })
}
    
#generate app
shinyApp(ui, server)
