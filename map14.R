library(shiny)
library(leaflet)

#ui
ui <- fluidPage(
  titlePanel(h3("Habitat use at Carrizo Plain National Monument, USA")),
  sidebarLayout(
    sidebarPanel(
      selectInput("var", label = h4("Variable"),
                  choices = list("observed" = "status",
                                  "expected" = "expected"), selected = 1)
    ),
    mainPanel = leafletOutput("map")
  )
)


#server
server <- function(input, output, session) {
  data <- read.csv("data/mcp95_20m.csv")
  t.class <- colorFactor("Blues", data[,input$var], levels = FALSE)
  output$map <- renderLeaflet({
    leaflet() %>%
      addTiles() %>%
      addCircleMarkers(data$x_wgs, data$y_wgs, radius = 1, color = ifelse(data[,input$var] == "0", 'lightblue', 'red'))
  })
}

#generate app
shinyApp(ui, server)
