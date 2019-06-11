library(shiny)
library(leaflet)

#ui
ui <- fluidPage(
  titlePanel(h3("Habitat use at Carrizo Plain National Monument, USA")),
  sidebarLayout(
    sidebarPanel(
      selectInput("var", label = h4("Variable"),
                  choices = list("presence" = "total",
                                 "shrub cover" = "shrub_cover",
                                 "NDVI" = "NDVI",
                                 "slope" = "slope",
                                 "elevation" = "elevation",
                                 "aspect" = "aspect",
                                 "solar" = "solar"), selected = 1)
    ),
    mainPanel = leafletOutput("map")
  )
)


#server
server <- function(input, output, session) {
  data <- read.csv("data/mcp20m.csv")
  pal <- reactive({colorNumeric(
    palette = c("lightblue", "red"), 1:10,
    domain = data[,input$var])
  })
  
  output$map <- renderLeaflet({
    leaflet(data) %>%
      addTiles() %>%
      addCircleMarkers(data$x_wgs, data$y_wgs, radius = 1, color = ~pal())
  })
}

#generate app
shinyApp(ui, server)
