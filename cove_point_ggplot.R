#####This script is to show how to make some interesting ggplot graphics and is based off of the Cove Point data for 
#the R Meetup 5/30/2018

#####Install Packages needed#####
install.packages("tidyverse")
install.packages("ggpmisc")
install.packages("lubridate")
install.packages("viridis")

#####Activate Packages#####
library(tidyverse)
library(ggpmisc)
library(lubridate)
library(viridis)

#####Load Data#####


#####Format Data#####



#####Some things to specify that I will call upon later#####
pal7<-c("North"="#E69F00", "Mid"="#F0E442", "South"="#009E73", "Hobo"="#56B4E9", "Kayak"="#56B4E9")
ypal2 <- c("2010"="#fde0dd", "2011"="#fcc5c0", "2012"="#fa9fb5", "2013"="#f768a1", 
           "2014"="#dd3497", "2015"="#ae017e", "2016"="#7a0177", "2017"="#49006a")
degrees<-c(0, 45, 90, 135,180,225,270,315)
compass<-c("N", "NE", "E", "SE", "S", "SW", "W", "NW")


#####Graphing!#####