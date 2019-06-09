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
    
    mainPanel(fluidRow(plotOutput("regressions"), plotOutput("distribution"))),
  )
)

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
