# Cleaning data for 10 years (2008-2018)

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

# Read datatsets
# crimes2008 <- read_csv("Crime_Incidents_in_2008.csv")
# crimes2009 <- read_csv("Crime_Incidents_in_2009.csv")
# crimes2010 <- read_csv("Crime_Incidents_in_2010.csv")
# crimes2011 <- read_csv("Crime_Incidents_in_2011.csv")
# crimes2012 <- read_csv("Crime_Incidents_in_2012.csv")
# crimes2013 <- read_csv("Crime_Incidents_in_2013.csv")
# crimes2014 <- read_csv("Crime_Incidents_in_2014.csv")
# crimes2015 <- read_csv("Crime_Incidents_in_2015.csv")
# crimes2016 <- read_csv("Crime_Incidents_in_2016.csv")
# crimes2017 <- read_csv("Crime_Incidents_in_2017.csv")
# crimes2018 <- read_csv("Crime_Incidents_in_2018.csv")

# Add columns with a specific years to filter it
# crimes2008$YEAR <- 2008
# crimes2009$YEAR <- 2009
# crimes2010$YEAR <- 2010
# crimes2011$YEAR <- 2011
# crimes2012$YEAR <- 2012
# crimes2013$YEAR <- 2013
# crimes2014$YEAR <- 2014
# crimes2015$YEAR <- 2015
# crimes2016$YEAR <- 2016
# crimes2017$YEAR <- 2017
# crimes2018$YEAR <- 2018

# Combine crimes all together (2008 - 2018)
# crimes <- rbind(crimes2008, crimes2009, crimes2010, crimes2011, crimes2012, crimes2013,
#                 crimes2013, crimes2014, crimes2015, crimes2016, crimes2017)

# Let's save data as RDS
# saveRDS(crimes, file = "DC crimes.rds")

# Let's read RDS file now
DC_crimes <- readRDS("DC crimes.rds")

# Select relevant columns for analysis
DC_crimes <- DC_crimes %>% select(X, Y, REPORT_DAT, SHIFT, METHOD, OFFENSE, 
                            BLOCK, DISTRICT, CENSUS_TRACT, VOTING_PRECINCT, YEAR)

# Clean date format
DC_crimes$REPORT_DAT <- as.Date(DC_crimes$REPORT_DAT , format = "%Y-%m-%d")

# To lower all words in columns "Shift", "Method", "Offence")
# crimes[,4:6] <- apply(crimes[,4:6], 2, str_to_lower) - old code
DC_crimes <- apply(DC_crimes, 2, str_to_lower)

# Use a custom function to capitalize only first letter
# Source: https://stackoverflow.com/questions/18509527/first-letter-to-upper-case/18509816
firstup <- function(x) {
  substr(x, 1, 1) <- toupper(substr(x, 1, 1))
  x
}

# Capitalize these columns now
DC_crimes <- apply(DC_crimes, 2, firstup)

# Transform matrix into data frame 
DC_crimes <- as.data.frame(DC_crimes)

# Rename names of columns
DC_crimes <- DC_crimes %>% rename(Lon = X,
                                  Lat = Y,
                                  `Report date` = REPORT_DAT,
                                  Shift = SHIFT,
                                  Method = METHOD,
                                  Offense = OFFENSE,
                                  Block = BLOCK, 
                                  District = DISTRICT,
                                  `Census tract` = CENSUS_TRACT,
                                  `Voting precinct` = VOTING_PRECINCT,
                                  Year = YEAR)




