# DEVELOPMENT PAUSED; MAY NOT BE NEEDED
# Filter down the station data to just include the major traffic stations.

target <- 75

#### section adapted from prepareXtab2  
t1 <- Sys.time()

memory.limit(size=400000)
require (dplyr)
require(stringr)

yr <- 14  # configure this for year required

YRFile  <- as.name(paste("JD",yr, sep = ""))

if (!exists(as.character(YRFile))) load(paste("..//..///Data/Trip Data/", YRFile, ".RData", sep = ""))

# this is here for future versions of this script  
yrFile  <- eval(YRFile) %>% select( Billable.Duration, StartStation.Name, EndStation.Name,  StartStation.Id, EndStation.Id, Date, weekday, month, startHourDecimal, endHourDecimal) 
names(yrFile) <- c("delay", "orig", "dest", "origNum", "destNum", "date", "weekday", "month", "startHrDec", "endHrDec")

# clean out records with no dest station
yrFile <- yrFile %>% filter (dest != "NA" | dest == "")

# clean up noisy station names, and give the same name to stations in clusters, e.g., Waterloo 1-3
source("cleanNcluster.R")

x3<-as.data.frame(xtabs(~origNum+orig,data=yrFile))
x3 <- x3 %>% filter(Freq>0)

x4<-as.data.frame(xtabs(~destNum+dest,data=yrFile))
x4 <- x4 %>% filter(Freq>0)

yrFile1 <- yrFile %>% select(origNum, destNum)
yrFile1$origNum <- as.factor(yrFile1$origNum)
yrFile1$destNum <- as.factor(yrFile1$destNum)

### end of copy 

names(x3)[3] <- "FreqOut"
names(x4)[3] <- "FreqIn"

stationEvents <- left_join(x3, x4, by = c("origNum" = "destNum"))

stationEvents$Freq <- stationEvents$FreqIn + stationEvents$FreqOut

stationEvents  <- stationEvents %>% arrange(Freq) %>% select(origNum, orig, Freq)

numStations <- dim(stationEvents)[1]

while(numStations > target){
  
  cullStationID  <- stationEvents[1,]$origNum
    
  yrFile1$origNum <- str_replace_all(fixed(yrFile1$origNum), cullStationID, "9999")
  yrFile1$destNum <- str_replace_all(fixed(yrFile1$destNum), cullStationID, "9999")
  
  stationEvents <- stationEvents %>% filter(origNum != cullStationID)
  
  numStations <- numStations - 1
}


# report the elapsed time
t2 <-  Sys.time()
message(cat("lumpSmallstations:  Finish: ",t2, " Start: ",t1,"  Elapsed Time:",t2-t1))
