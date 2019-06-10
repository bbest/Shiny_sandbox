layer1 <- read.table("data/layer20m.txt",sep=",")
layer1 <- rename(layer1, Shrub_Cov = ShrubPercent20m_Clip, Elev = Elevation_20m_Clip, Aspect = Aspect_20m, Slope = Slope_20m, NDVI = NDVI_20m_Clip, Solar = Solar_20m_Clip)
layer1 <- mutate(layer1, aspect.cat = ifelse(Aspect >= 0 & Aspect < 22.5, "north", ifelse(Aspect >= 22.5 & Aspect < 67.5, "northeast", ifelse(Aspect >= 67.5 & Aspect < 112.5, "east", ifelse(Aspect >= 112.5 & Aspect < 157.5, "southeast", ifelse(Aspect >= 157.5 & Aspect < 202.5, "south", ifelse(Aspect >= 202.5 & Aspect < 247.5, "southwest", ifelse(Aspect >= 247.5 & Aspect < 292.5, "west", ifelse(Aspect >= 292.5 & Aspect < 337.5, "northwest", ifelse(Aspect >= 337.5 & Aspect < 360, "north", "flat"))))))))))

l.all <- layer1
predictions = predict(m5, newdata=l.all, level = 0, type = "response") 

l.all$predictions = predictions
full.pred <- predictions
preds <- l.all
preds <- SpatialPixelsDataFrame(points=preds[c("x", "y")], data=preds)
preds <- as(preds, "SpatialGridDataFrame")
names(preds)