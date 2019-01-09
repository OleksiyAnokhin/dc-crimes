# Oleksiy Anokhin 
# August 17, 2018

# DC Crimes 

# Global code

# Set working directory
# setwd("C:/Users/wb516241/OneDrive - WBG/Oleksiy Anokhin/My R Work/Shiny apps/App DC Crimes 2017/New app 5")
setwd("C:/Users/wb516241/OneDrive - WBG/Oleksiy Anokhin/My R Work/Shiny apps/App DC Crimes 2017/New app 6 (November 24, 2018)/New app 8 (Barcharts)")

# Install packages
library(tidyverse)
library(leaflet)
library(leaflet.extras)
library(shiny)
library(shinythemes)
library(plotly)
library(geojsonio)
library(rgdal)
library(sf)
library(ggthemes)

# Read datatset
crimes <- read_csv("Crime Incidents in 2017.csv")

# Select relevant columns for analysis
crimes <- crimes %>% select(Lon, Lat, `Report date`, Shift, Method, Offense, 
                            Block, District, `Census tract`,`Voting precinct`)

# Clean date format
crimes$`Report date` <- as.Date(crimes$`Report date`, format = "%Y-%m-%d")

# To lower all words in columns "Shift", "Method", "Offence")
crimes[,4:6] <- apply(crimes[,4:6], 2, str_to_lower)

# Use a custom function to capitalize only first letter
# Source: https://stackoverflow.com/questions/18509527/first-letter-to-upper-case/18509816
firstup <- function(x) {
  substr(x, 1, 1) <- toupper(substr(x, 1, 1))
  x
}

# Capitalize these columns now
crimes[,4:6] <- apply(crimes[,4:6], 2, firstup)

# Add awesome markers (if necessary)
# icons <- awesomeIcons(
#   icon = 'ios-close',
#   iconColor = 'white',
#   library = 'ion',
#   markerColor = "darkred") 

# Prepare data for server filters
methods <- unique(crimes$Method)
shifts <- unique(crimes$Shift)
offenses <- unique(crimes$Offense)
districts <- unique(crimes$District)

# Cleaning the df for the table (dropping Lon and Lat, which are useless for the table)
crimes2 <- crimes %>% select (-c(Lon, Lat))


# Read data in a separate file for barcharts
# crimes3 <- read_csv("Crime Incidents in 2017.csv")
# crimes3 <- crimes3 %>% select(Lon, Lat, `Report date`, Shift, Method, Offense, 
#                              Block, District, `Census tract`,`Voting precinct`)

# 
crimes3 <- crimes %>% select(Shift, Method, Offense) %>% 
  gather(key = "variable", value = "value")

# Add new columns to analyze time
crimes4 <- read_csv("Crime Incidents in 2017.csv")
crimes4 <- crimes4 %>% select(`Report date`, Shift, Method, Offense) 
crime.time <- strptime(crimes4$`Report date`, "%Y-%m-%d %H:%M")

# Extracting Month, Day, and Hour separately
crime.time.month <- as.integer(format(crime.time, "%m"))
crime.time.day <- as.integer(format(crime.time, "%d"))
crime.time.hour <- as.integer(format(crime.time, "%H"))

# Combine columns
crimes4 <- cbind(crimes4, crime.time.month, crime.time.day, crime.time.hour)

# Rename columns
crimes4 <- crimes4 %>% rename("Month" = crime.time.month, "Day" = crime.time.day, "Hour" = crime.time.hour)

# Reshape the dataframe
crimes5 <- crimes4 %>% select(Shift, Method, Offense, Month, Day, Hour) %>% 
  gather(key = "variable", value = "value")





# 21. WHAT DO I WANT TO SHOW IN BARCHARTS? Number of crimes per different variable? How to combine several filter?
# # # Add district, tract, precinct, and flter all this by time and offence + add day. Basically everything!
# 22. What do I want to show in line charts? How to add Hour there? 
