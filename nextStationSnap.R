nextStationSnap <- function(){
  
  # needs to replace invalid records with NA next
  
  require(dplyr)
  require(lubridate)
    
  # advance to next DateTime in YRStnFile ----
  
  # get all data after cursor time  
  temp <- envStationSnap$dayStationData %>% filter(Time > envStationSnap$cursor)
  
  # test for end condition
  if (dim(temp)[[1]] == 0)  return(NULL)
  
  # get the first time stamp in that data
  thisTime <- temp$DateTime[1]
  
  # select only data at the time stamp
  s <- temp %>% 
    filter(DateTime == thisTime) %>%
    select(DateTime, stationNumber, DockCount, EmptyDockCount, BikeCount, Time)
  
  # advance the cursor to the current record
  envStationSnap$cursor <- s$Time[[1]]
  envStationSnap$cursorDateTime <- s$DateTime[[1]]

# put a reference to the snap into envStationSnap
  envStationSnap$snap <- s
  
  # replace bad data with NA
  cleanStationSnap()
  
  return(envStationSnap$snap)
}