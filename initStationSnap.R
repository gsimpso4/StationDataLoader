initStationSnap <- function(initDateTime) {
  
  # Initialize StationSnap iterator to given date,
  # return time of first record on date.
  # This just loads data and records date, 
  # doesn't move through data to date given
  

  source("..//StationDataLoader//cleanStationSnap.R")
  source("..//StationDataLoader//nextStationSnap.R")
  source("..//StationDataLoader//getStationSnap.R")
  source("..//StationDataLoader//getDayStationData2.R")
  
  
  require(lubridate)
  
# set up environment to hold StationSnap working data


if (!exists("envStationSnap" , mode="environment")) {
  
  envStationSnap <- new.env(parent = emptyenv())

  assign("envStationSnap", envStationSnap, .GlobalEnv)
}

# get the data for the day requested
  getDayStationData(initDateTime)

# initialize the time range and cursor

  envStationSnap$first <- min(envStationSnap$dayStationData$Time)
  envStationSnap$last <- max(envStationSnap$dayStationData$Time)
  envStationSnap$cursor <- 0

}
