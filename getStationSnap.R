
getStationSnap <- function(timeRequired){
# Assuming initStationSnap has been called, 
  # get the snap for a particular time, if it is available.
  # time here is a decimal hour of the day
  # if not, return NULL
    
  require(dplyr)
  require(lubridate)
  
  s <- envStationSnap$dayStationData %>% 
    filter(abs(Time - timeRequired) < .05) %>%
    select(DateTime, stationNumber, DockCount, EmptyDockCount, BikeCount, Time)
  
    if (dim(s)[[1]] == 0)  return(NULL)
  
  # advance the cursor to the current record
  envStationSnap$cursor <- s$Time[[1]]
  envStationSnap$cursorDateTime <- s$DateTime[[1]]
  
  # put a reference to the snap into envStationSnap
  envStationSnap$snap <- s
  
  # replace bad data with NA
  cleanStationSnap()
  
  return(envStationSnap$snap)
}