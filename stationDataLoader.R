# load all the .csv station data data files in a particular directory 
# into a single data frame, stored as an SDyy.Rdata object

# to use this script:
# 1. Configure dataDir if needed 
# 2. Set value of yr (line ~23)
# 3. Configure intervalMins attribute (line~73)

# ISSUES
  # stronger validity checks desirable.

# clear out the R environment
rm(list=ls())

# get the start time
message(t1 <- Sys.time())

# load required packages if not already loaded
  require(dplyr)
  require(lubridate)

# configure year number here.
yr <- 14

# note directory where station data is stored 
  dataDir <- "..\\..\\Data\\Station Data\\Station Status 2014 15 mins Cleansed\\"   

  # make sure we have sufficient working memory
  memory.limit(size=800000)

# get the names of all the .csv files in the directory
files<-list.files(dataDir,all.files=TRUE,pattern=".csv")

# Note the file names may not be in time order
View (files)

YRStnFile <- as.data.frame(NULL)

# grab each of the files in turn.
for (n in 1:length(files)) {
    
  # display filename to show progress
  message(files[n])
  
  # read the file into a data.table
  tmp <- read.csv(paste(dataDir, files[n], sep=""), stringsAsFactor =FALSE, header = TRUE, sep=",", strip.white=TRUE) 
  
  #  Make a new startTime variable, POSIXct, on which data can be sorted
  tmp$DateTime <- parse_date_time(paste(tmp$LastUpdateDate,tmp$LastUpdateTime),
                                   orders = "dmy %H%M")
  
# checks:  
 message( (paste( "earliest data", min(tmp$DateTime))) )
 message(  (paste( "latest data", max(tmp$DateTime))) )
 message( (paste("timeSpan",max(tmp$DateTime) - min(tmp$DateTime))) )
  
# select relevant columns:
  tmp <- tmp %>% 
    select (DateTime, stationNumber, longitude, latitude, DockCount, EmptyDockCount, BikeCount, StationName) 

  if (n==1) YRStnFile <- tmp else
    YRStnFile <- rbind(YRStnFile,tmp)  # append tmp to year's Journey Data

  } # end of loop over files

# sort data by startTime
  YRStnFile <- YRStnFile %>% 
    arrange(DateTime, stationNumber) %>%
  # filter out dummy records representing workshops
    filter(latitude != 0) %>%
    filter (latitude < 51.6)    ##  this may need to be changed in future

# Add date field:
  YRStnFile$Date <- floor_date(YRStnFile$DateTime, unit = "day")

# Add time field:
  YRStnFile$Time <- (YRStnFile$DateTime - YRStnFile$Date)/3600

# set attributes - metadata that can be checked by routines using the data
  attr(YRStnFile, "intervalMins") <-  15  # CONFIGURE
  attr(YRStnFile, "sourcedFrom") <-  dataDir
  attr(YRStnFile, "sourceFiles") <-  as.list(files)
  (attr(YRStnFile, "earliestDate") <- min(YRStnFile$DateTime))
  (attr(YRStnFile, "latestDate")  <- max(YRStnFile$DateTime))
  (attr(YRStnFile, "timeSpan") <- max(YRStnFile$DateTime) - min(YRStnFile$DateTime))
  (attr(YRStnFile, "preparedOn") <-  Sys.time())
  attr(YRStnFile, "script") <- "stationDataLoader.R"
  attr(YRStnFile, "R_Project") <-  paste(getwd(),"/",list.files(pattern=".Rproj"),sep="")

# source("Checks.R", echo = TRUE)

# save the data frame at the top level of the Station Data directory
if ("Darwin" == Sys.info()['sysname'])  {
  stationDataDir <- "../../Data/Station Data/" 
} else {
  stationDataDir <- "..\\..\\Data\\Station Data\\" 
}
  save(YRStnFile, file = paste(stationDataDir,"SD",yr,".Rdata",sep=""))  

# report the elapsed time
message(t2 <-  Sys.time())
message(cat("Elapsed Time:",t2-t1))