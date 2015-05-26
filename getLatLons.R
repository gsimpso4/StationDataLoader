# update stationLUT with station coordinates from station data files 

memory.limit(size=400000)

yr <- 14  # configure

# get StationLUT
load( paste("..\\..\\Data\\Station Data\\", "stationLUT",yr,".RData", sep="")) 

# get the station files
dataDir <- paste("..\\..\\Data\\Station Data\\Station Status 20",yr," 15 mins Cleansed\\", sep = "")   

# get the names of all the .Rdata files in the directory
files<-list.files(dataDir,all.files=TRUE,pattern=".csv")

# read in the station data files
# have to go through them all, because stations come and go
for (n in 1:length(files)) {
  
  # display filename to show progress
  message(n, " ", files[n])
  
  stationFile <- read.csv(paste(dataDir, files[n], sep=""), stringsAsFactor =FALSE, header = TRUE, sep=",", strip.white=TRUE) 

  # grab the rows and fields we need:
  require(dplyr)
  
  stationFile <- stationFile %>% 
    distinct(stationNumber) %>%
    select (stationNumber, longitude, latitude)
  
# copy the data we need into a holding structure, for merge with LUT
  if (n == 1) stations <- stationFile else {
    stations  <- bind_rows(stations, stationFile)
    stations  <- stations %>% distinct(stationNumber)
  }
}

stationLUT <- left_join(stationLUT, stations, by = c("EndStation.Id" = "stationNumber"))

# put stationLUT in the stations directory
write.csv(stationLUT, paste("..\\..\\Data\\Station Data\\", "stationLUT",yr,".csv", sep=""))
save(stationLUT, file = paste("..\\..\\Data\\Station Data\\", "stationLUT",yr,".RData", sep="")) 

