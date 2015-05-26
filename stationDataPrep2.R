# Go through station files for a particular year, and the associated JD annual trip data file.
# Identify the unique station names from the trip data file
# Clean up noisy station names in station data file, and add station number.

rm(list = ls())

t1 <- Sys.time()

memory.limit(size=400000)
require (dplyr)
require(stringr)

yr <- 14  # configure this for year required

# get trip data
YRFileName  <- as.name(paste("TD",yr, sep = ""))

if(!exists("YRFile")) load(paste("..//..///Data/Trip Data/", YRFileName, ".RData", sep = ""))

yrFile  <- eval(YRFile)

# clean up noisy station names, and give the same name to stations in clusters, e.g., Waterloo 1-3
# source("cleanNcluster2.R", echo = TRUE)

yrFile  <- yrFile %>% select( EndStation.Name, EndStation.Id) 

names(yrFile) <- c("EndStation.Name", "EndStation.Id")

# clean out records with no dest station
yrFile <- yrFile %>% filter (EndStation.Name != "NA" | EndStation.Name == "")

# prepare LUT of station names and station numbers.
stationLUT<-as.data.frame(xtabs(~EndStation.Id+EndStation.Name,data=yrFile), stringsAsFactors = FALSE)
stationLUT <- stationLUT %>% filter(Freq>0) %>% arrange(EndStation.Id)
stationLUT$EndStation.Id <- as.numeric(stationLUT$EndStation.Id)

# set up to process a year's worth of station data
dataDir <- paste("..\\..\\Data\\Station Data\\Station Status 20",yr," 15 mins Original\\", sep = "")   

outDir <- paste("..\\..\\Data\\Station Data\\Station Status 20",yr," 15 mins Cleansed\\", sep = "")   

# get the names of all the .Rdata files in the directory
files<-list.files(dataDir,all.files=TRUE,pattern=".csv")

# display the files
View (files)

# loop over the files, cleaning them up
for (n in 1:length(files)) {
  
  # display filename to show progress
  message(n, " ", files[n])
  
  # read in the station data
  stationFile <- read.csv(paste(dataDir, files[n], sep=""), stringsAsFactor =FALSE, header = TRUE, sep=",", strip.white=TRUE) 

  # clean names and add station numbers
  source("cleanNclusterStations.R", echo = TRUE)
  
  message("Adding station numbers")
  source("addStationNumbers3.R", echo = TRUE)
  
  # write out the cleaned station file
  write.csv(stationFile, paste(outDir, files[n], sep="") )

  # report the elapsed time
  t2 <-  Sys.time()
  message(cat("Elapsed Time:",t2-t1))
  
  # next file...
}

# put stationLUT in the stations directory
write.csv(stationLUT, paste("..\\..\\Data\\Station Data\\", "stationLUT",yr,".csv", sep=""))
save(stationLUT, file = paste("..\\..\\Data\\Station Data\\", "stationLUT",yr,".RData", sep="")) 

