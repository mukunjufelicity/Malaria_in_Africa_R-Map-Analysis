#clear_workspace <- function() {
  # Remove all objects from the environment
  #rm(list = ls())
  
  # Close all plots
  
#dev.off()
  
  # Clear the console
  #cat("\014")
#}

# Usage
#clear_workspace()


#Analyzing the Malaria in Africa

#Package Installation
install.packages("sp")
library(sp)

install.packages("rgdal")
library(rgdal)

install.packages("raster")
library(raster)

install.packages("ggplot2")
library(ggplot2)

#Data set
data_path <- "C:/Users/v-femuku/Desktop/portfolio projects/r_gis_project/malaria_in_africa/malaria_africa.csv"
malaria_data <- read.csv(data_path)

summary(malaria_data)    #Using summary to explore the structure of the data

#Converting to Spatial Object
coordinates(malaria_data) <- c("longitude", "latitude")
proj4string(malaria_data) <- CRS("+proj=longlat +datum=WGS84")

#Data Visualization
malaria_data_df <- as.data.frame(malaria_data)

ggplot() + geom_point(data = malaria_data_df, aes(x=longitude, y=latitude, color=malaria_cases)) + 
  scale_color_gradient(low="steelblue", high="red", name="Malaria Cases") + labs(title="Malaria Spread in Africa")

#Spatial Analysis
#Calculation of: summary statistics of malaria cases
summary(malaria_data$malaria_cases)

#Calculation of: total number of cases
total_cases <- sum(malaria_data$malaria_cases, na.rm = TRUE)

#Analysis of Maps: converting to raster for better visualization
raster_extent <- extent(min(malaria_data$longitude), max(malaria_data$longitude), 
                        min(malaria_data$latitude), max(malaria_data$latitude))
resolution <- 1
malaria_raster <- raster(raster_extent, resolution = resolution)

malaria_raster <- rasterize(malaria_data, malaria_raster, field="malaria_cases", fun=sum)

install.packages("rnaturalearthdata")
library(rnaturalearthdata)

install.packages("rnaturalearth")
library(rnaturalearth)

world_map <- ne_countries(scale="medium", returnclass="sf")  #map of Africa background
africa_map <- world_map[world_map$continent == "Africa", ]   #subset the world map to only include Africa

custom_colors <- colorRampPalette(c("red", "orange", "yellow"))(30)
plot(malaria_raster, col = custom_colors, main = "Malaria Cases in Africa")

plot(africa_map, add=TRUE, col=rgb(0,0.2,0.6, alpha=0.5), border="black")
plot(malaria_raster, col=custom_colors, add=TRUE, legend=FALSE)


#Export Result
png("malaria_cases_map.png", width = 800, height = 600)
plot(malaria_raster, col = heat.colors(10), main = "Malaria Cases in Africa")
dev.off()







#cat("\014")

