# testStationSnap.R
# test harness for StationSnap

rm(list=ls())

source("initStationSnap.R")

# configure evaluation start dateTime
yr <- "14"
mo <- "04"
day <- "01"

require(lubridate)
start <- parse_date_time(paste("20",yr,"-",mo,"-",day,sep=""), "ymd")

initStationSnap(start)
  
repeat
{
  snap <- nextStationSnap()
  print(envStationSnap$cursorDateTime)
  if (is.null(snap)) break  
}

# advance the date                 
start <- update(start, ydays = 93)     
initStationSnap(start)

for (time in seq(0, 23.75, 0.25)){
  t <- getStationSnap (time)
  if (is.null(t)) 
    print (paste(time, " NULL" )) else
      print(envStationSnap$cursorDateTime)
}
