library(shiny)
library(leaflet)

#ui
ui <- fluidPage(
  leafletOutput("map")
)


#server
server <- function(input, output, session) {
  data <- read.csv("data/mcp20m.csv")
  t.class <- colorFactor("Blues", data$SumAllYr, levels = TRUE)
  output$map <- renderLeaflet({
    leaflet() %>%
      addTiles() %>%
      addCircleMarkers(data$x_wgs, data$y_wgs, radius = 1, popup = data$SumAllYr, color = ifelse(data$SumAllYr == "0", 'lightblue', 'red'))
  })
}

#generate app
shinyApp(ui, server)
