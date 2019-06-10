library(shiny)

#ui
ui <- fluidPage(
  titlePanel(h3("Habitat use at Carrizo Plain National Monument, USA")),
  sidebarLayout(
    sidebarPanel(
      selectInput("outcome", label = h4("Estimate"),
                  choices = list("Likelihood" = "probability",
                                 "Log odds" = "log_odds"), selected = 1),
      
      selectInput("indepvar", label = h4("Predictor"),
                  choices = list("shrub cover" = "shrub_cov",
                                 "NDVI" = "NDVI",
                                 "slope" = "slope",
                                 "elevation" = "elevation",
                                 "aspect" = "aspect",
                                 "solar" = "solar"), selected = 1),
      
      selectInput("model", label = h4("Model"),
                  choices = list("linear" = "lm",
                                 "GAM" = "gam",
                                 "loess" = "loess",
                                 "best fit" = "auto"), selected = 1)
      
    ),
    
    mainPanel(
      
      tabsetPanel(type = "tabs",
                  
                  tabPanel("Regressions", plotOutput("regressions")),
                  tabPanel("Distributions", plotOutput("distribution")),
                  h4("Data"),
                  p("At Carrizo Plain National Monument, California (35.19140N, 119.79290W), a 5 km2 was identified for ecological research.  This site was comprised of a foundation shrub species Ephedra californica with other vegetation and was occupied by the lizard species Gambelia sila.  For three years from 2016-2018, individual lizards were tracked using telemetry each summer when this species was primarily active.  Each instance was geotagged to within 5m, and specific ecological elements of habitat including shrub or open canopy microsites and micro-topography were recorded.  A total of 3553 relocations were recorded."),
                  h4("Models"),
                  p("The 95% maximum convex polygon (MCP) for all points was calculate using the R package 'adehabitat'.  Resource selection function models were applied to these data.  Individual telemetry relocations that fell within the 95% MCP were classified as 'used' locations and 'unused' habitat was randomly selected within range for subsequent resource selection models.  These points were then used in a logistic generalized linear mixed regression model with the predictor variables listed above, and the individual lizard ID was treated as a random effect.  Models were iterated 99 times, and mean probabilities for the model set are provided here.  All models were also retested using the R package 'ResourceSelection' to ensure estimate probabilities were robust.  The log odds ratio for probabilities was then calculated on these mean values as an effect size measure.   All analyses were done in R version 3.6.0, and the code is publicly archived at zenodo (DOI: 10.5281/zenodo.3240619).")
                  
      )
    )
  ))



#server
server <- function(input, output) {
  #data
  library(tidyverse)
  data <- read.csv(url("https://ndownloader.figshare.com/files/15371705"))
  
  #regressions
  output$regressions <- renderPlot({
    qplot(data[,input$indepvar], data[,input$outcome], geom = 'smooth', method = input$model, main="Predicted animal occurrence",
          xlab=input$indepvar, ylab=input$outcome) 
    
  }, height=400)
  
  
  # Histogram
  output$distribution <- renderPlot({
    qplot(data[,input$outcome], binwidth = 0.1, main="Presence distribution for all predictors",  xlab=input$outcome)
  }, height=300, width=300)
  
  
}

#run app
shinyApp(ui = ui, server = server)
