library(shiny)
ui <- fluidPage(
  titlePanel("Resource selection function"),
  sidebarLayout(
    sidebarPanel(
      selectInput("outcome", label = h3("Outcome"),
                  choices = list("Likelihood" = "probability",
                                 "Log odds" = "log_odds"), selected = 1),
      
      selectInput("indepvar", label = h3("Explanatory variable"),
                  choices = list("shrub cover" = "shrub_cov",
                                 "NDVI" = "NDVI",
                                 "slope" = "slope",
                                 "elevation" = "elevation",
                                 "aspect" = "aspect",
                                 "solar" = "solar"), selected = 1)
      
    ),
    
    mainPanel(
      
      tabsetPanel(type = "tabs",
                  
                  tabPanel("Scatterplot", plotOutput("scatterplot")), # Plot
                  tabPanel("Distribution", plotOutput("distribution1"))
                  
      )
    )
  ))



# SERVER
server <- function(input, output) {
  #data
  data <- read.csv(url("https://ndownloader.figshare.com/files/15371705"))
  
  #scatterplot
  output$scatterplot <- renderPlot({
    plot(data[,input$indepvar], data[,input$outcome], main="Predicted occurrence",
         xlab=input$indepvar, ylab=input$outcome, pch=19)
    abline(lm(data[,input$outcome] ~ data[,input$indepvar]), col="red", lwd=3)
    lines(lowess(data[,input$indepvar],data[,input$outcome]), col="blue", lwd=3)
  }, height=400)
  
  
  # Histogram output var 1
  output$distribution1 <- renderPlot({
    hist(data[,input$outcome], main="", xlab=input$outcome)
  }, height=300, width=300)
  
 
}

shinyApp(ui = ui, server = server)
