library(shiny)
library(leaflet)

#ui
ui <- fluidPage(
  leafletOutput("map"),
  absolutePanel(top = 10, right = 10,
                sliderInput("range", "Frequency", min(data$SumAllYr), max(data$SumAllYr),
                            value = range(data$SumAllYr), step = 0.1
                )
  )
)


#server
server <- function(input, output, session) {
  data <- read.csv("data/mcp20m.csv")
  filteredData <- reactive({
    data[data$SumAllYr >= input$range[1] & data$SumAllYr <= input$range[2],]
  })
  t.class <- colorFactor("Blues", data$SumAllYr, levels = TRUE)
  output$map <- renderLeaflet({
    leaflet() %>%
      addTiles() %>%
      addCircleMarkers(data = filteredData, data$x_wgs, data$y_wgs, radius = 1, popup = data$SumAllYr, color = ifelse(data$SumAllYr == "0", 'lightblue', 'red'))
  })
}

#generate app
shinyApp(ui, server)
