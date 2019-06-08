library(shiny)

#UI
ui <- fluidPage(
  
  # App title ----
  titlePanel("Resource selection function"),
  
  # Sidebar layout with input and output definitions ----
  sidebarLayout(
    
    # Sidebar panel for inputs ----
    sidebarPanel(
      
      # Input: Slider for the number of bins ----
      sliderInput(inputId = "bins",
                  label = "Number of bins:",
                  min = 1,
                  max = 50,
                  value = 30),
      #Variables
      selectInput("indepvar", label = h3("Predictor"),
                  choices = list("shrub cover" = "shrub_cov",
                                 "slope" = "slope",
                                 "aspect" = "aspect"), selected = 1)
    ),
    
    # Main panel for displaying outputs ----
    mainPanel(
      
      # Output: Histogram ----
      plotOutput(outputId = "distPlot")
      
    )
  )
)

#server
server <- function(input, output) {
  
library(tidyverse)
  data <- read_csv(url("https://ndownloader.figshare.com/files/15371537"))
  data <- data %>%
    filter(status == 1)
  
  output$distPlot <- renderPlot({
    
    x    <- data$probability
    bins <- seq(min(x), max(x), length.out = input$bins + 1)
    
      ggplot(data, aes(x)) +
      geom_histogram(breaks = bins, fill = "darkgreen")
    
  })
  
}

# run app
shinyApp(ui = ui, server = server)