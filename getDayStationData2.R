getDayStationData <- function(dateNeeded) {
  
  # Loads all station data for given date, saves in envStationSnap
  
  # needs to return NULL if no data found on dateNeeded
  
  require(lubridate)
  
  envStationSnap$date  <- dateNeeded
  
  # configure for year of interest
  yr <- year(dateNeeded) - 2000
  
  # Create station data file name
  SDFileName  <- as.name(paste("SD",yr, sep = ""))
  
  # get stationData year file -----
  
  if (!exists("YRStnFile")){
    
  load(paste("..//..///Data/Station Data/", SDFileName, ".Rdata", sep = ""))
      
  }
  
  # Now carve out the data for the day we need. ----
  require(dplyr)
  
  dayStationData <- YRStnFile %>%
    filter(Date == dateNeeded) %>% 
  # filter out extraneous records - workshop etc. 
    filter (latitude > 0) %>%
    filter (latitude < 51.6)  # this may need to be altered if scheme expands
  
  
# save results within the stationSnap environment:
  assign("YRStnFile", YRStnFile, envStationSnap)
  
# this should have the same effect as the assign, but does it?
  envStationSnap$dayStationData <- dayStationData
    
  assign("dayStationData", dayStationData, envStationSnap)

}
