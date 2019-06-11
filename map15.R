library(shiny)
library(leaflet)

#ui
ui <- fluidPage(
  titlePanel(h3("Habitat use at Carrizo Plain National Monument, USA")),
  sidebarLayout(position = "left",
    sidebarPanel(
      selectInput("var", label = h4("Presence"),
                  choices = list("observed" = "status",
                                 "expected" = "expected"), selected = 1)
    ),
    
    mainPanel(leafletOutput("map"),
              h4("Data"),
              p("At Carrizo Plain National Monument, California (35.19140N, 119.79290W), a 5 km2 was identified for ecological research.  This site was comprised of a foundation shrub species Ephedra californica with other vegetation and was occupied by the lizard species Gambelia sila.  For three years from 2016-2018, individual lizards were tracked using telemetry each summer when this species was primarily active.  Each instance was geotagged to within 5m, and specific ecological elements of habitat including shrub or open canopy microsites and micro-topography were recorded.  A total of 3553 relocations were recorded."),
              h4("Models"),
              p("The 95% maximum convex polygon (MCP) for all points was calculate using the R package 'adehabitat'.  Resource selection function models were applied to these data.  Individual telemetry relocations that fell within the 95% MCP were classified as 'used' locations and 'unused' habitat was randomly selected also within the home range for subsequent resource selection models.  Models were iterated 99 times, and mean probabilities for the model set were then converted to binary data using a 0.5 threshold.  All models were also retested using the R package 'ResourceSelection' to ensure estimate probabilities were robust.  All analyses were done in R version 3.6.0, and the code is publicly archived at zenodo (DOI: 10.5281/zenodo.3240619)."),
              h4("Interpretation"),
              p("Within the home range estimated for this population for this endangered species, the predicted available habitat is relatively extensive (i.e. within the 5km2 extent). Interestingly, a proportion of the habitat for this species is not. These findings suggest that fine-scale analysis of habitat through resource selection function models effectively informs likelihood of presence for sampling or for conservation efforts.")
              
    )
  )
)


#server
server <- function(input, output, session) {
  data <- read.csv(url("https://ndownloader.figshare.com/files/15437489"))
  t.class <- colorFactor("Blues", data[,input$var], levels = FALSE)
  output$map <- renderLeaflet({
    leaflet() %>%
      addTiles() %>%
      addCircleMarkers(data$x_wgs, data$y_wgs, radius = 1, color = ifelse(data[,input$var] == "0", 'lightblue', 'red'))
  })
}

#generate app
shinyApp(ui, server)