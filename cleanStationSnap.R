 cleanStationSnap  <-  function(){
 
     fixRows <- (envStationSnap$snap$DockCount == 0 & 
                   envStationSnap$snap$EmptyDockCount == 0 & 
                   envStationSnap$snap$BikeCount == 0)
     
     envStationSnap$snap[fixRows,3:5] <- NA
  
}
