library(shiny)

#UI
ui <- fluidPage(
  
  # App title ----
  titlePanel("Resource selection function"),
  
  # Sidebar layout with input and output definitions ----
  sidebarLayout(
    
    # Sidebar panel for inputs ----
    sidebarPanel(
      
      #Variables
      selectInput("var", label = h3("Predictor"),
                  choices = list("shrub cover" = "shrub_cov",
                                 "slope" = "slope",
                                 "aspect" = "aspect"), selected = 1),
      
      selectInput("outcome", label = h3("Outcome"),
                  choices = list("likelihood" = "probability",
                                 "log odds" = "log_odds"), selected = 1),
      
    ),
    
    # Main panel for displaying outputs ----
    mainPanel(
      
      # Output: plot
      plotOutput(outputId = "scatterplot")
      
    )
  )
)

#server
server <- function(input, output) {
  
  library(tidyverse)
  data <- read_csv(url("https://ndownloader.figshare.com/files/15371705"))
  
  output$scatterplot <- renderPlot({
    plot(data[,input$var], data[,input$outcome], main="",
         xlab=input$var, ylab=input$outcome, pch=19)
    abline(lm(data[,input$outcome] ~ data[,input$var]), col="red")
    lines(lowess(data[,input$var],data[,input$outcome]), col="blue")
    
  })
  
}

# run app
shinyApp(ui = ui, server = server)