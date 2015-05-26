#  Assign station number to a station file
#  Remove stations that don't match master list of stations.
#  This version attempts to speed up the process

# create a new field in the station file for station number
stationFile$"EndStation.Id" <- 0

# loop through the list of approved station names
# note this should be constructed from most recent trip data.
# first loop: exact matching

for (row in 1: length(stationLUT$EndStation.Name)) {
  
  name <- stationLUT$EndStation.Name[row]
  
  if (name=="") next

  matches  <- grep(name,stationFile$EndStation.Name, fixed = TRUE, value=FALSE)

  stationFile$EndStation.Id[matches] <- stationLUT$EndStation.Id[row]
  
}

# second loop: fuzzy matching.  Loop over stationFile
t1 <-  Sys.time()   # temp 

for (row in 1: length(stationFile$EndStation.Id)) {
  
  if (stationFile$EndStation.Id[row] == 0 ) { # try fuzzy matching
    
    name <- stationFile$StationName[row]
    
    if (name=="") next

    # use fuzzy matching to clear mistyped names
    matchLUT  <- agrep(name,stationLUT$EndStation.Name, max.distance = 0.01)
    # should only be one, but might be zero
    
    if (length(matchLUT) > 1) { 
 #  should write these to a file for future clear-up
 #      cat("LUT fuzzy match poss duplicate: ", matchLUT, " ",name,"\n", sep = "  " )

      # assign the station number and replace the station name 
      stationFile$EndStation.Id[row] <- stationLUT$EndStation.Id[matchLUT[1]]
      stationFile$StationName[row] <- stationLUT$EndStation.Name[matchLUT[1]]
    }
    
    if (length(matchLUT) == 1) {
    # now assign the station number and replace the station name 
    stationFile$EndStation.Id[row] <- stationLUT$EndStation.Id[matchLUT]
    stationFile$StationName[row] <- stationLUT$EndStation.Name[matchLUT]
    }
  }
}
t2 <-  Sys.time()   # temp 
print (t2-t1)


stationFile <- stationFile %>% filter(EndStation.Id > 0 )

write.csv(stationFile, "stationFile_test.csv")
