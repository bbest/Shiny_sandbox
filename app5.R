library(shiny)
ui <- fluidPage(
  titlePanel("Resource selection function at Carrizo Plain National Monument, USA"),
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
                                 "solar" = "solar"), selected = 1)
      
    ),
    
    mainPanel(
      
      tabsetPanel(type = "tabs",
                  
                  tabPanel("Regressions", plotOutput("scatterplot")),
                  tabPanel("Distribution", plotOutput("distribution"))
                  
      )
    )
  ))



# SERVER
server <- function(input, output) {
  #data
  library(tidyverse)
  data <- read.csv(url("https://ndownloader.figshare.com/files/15371705"))
  
  #scatterplot
  output$scatterplot <- renderPlot({
    qplot(data[,input$indepvar], data[,input$outcome], geom = 'smooth', method = 'lm', main="Predicted occurrence",
          xlab=input$indepvar, ylab=input$outcome) 
    
  }, height=400)
  
  
  # Histogram output var 1
  output$distribution <- renderPlot({
    qplot(data[,input$outcome], binwidth = 0.1, main="Distribution of all presence likelihoods",  xlab=input$outcome)
  }, height=300, width=300)
  
  
}

shinyApp(ui = ui, server = server)
