library(leaflet)
data <- read.csv("data/mcp20m.csv")
pal <- colorNumeric(
  palette = c("lightblue", "red"), 1:10,
  domain = data$shrub_cover)

#pal <- colorNumeric(
  #palette = "Greens", 1:10,
  #domain = data$shrub_cover)


leaflet(data = data) %>%
  addTiles() %>%
  addCircleMarkers(data$x_wgs, data$y_wgs, radius = 1, color = ~pal(shrub_cover)) 

pal <- colorNumeric(
  palette = c("lightblue", "red"), 1:1,
  domain = data$total)



leaflet(data = data) %>%
  addTiles() %>%
  addCircleMarkers(data$x_wgs, data$y_wgs, radius = 1, color = ~pal(total)) 
  