# StationDataLoader
For people wishing to make use of London Cycle Hire station data, this repository holds routines
for accessing the data.  

###Purpose: 
Gather station data into a form that can be used in other analyses  
Provide sequential access to station data via an iterator

#### Concepts:  
A stationDataSnap is a set of measurements of the state of all of the reporting stations at a point in time.  
StationData is composed of a sequence of days on which station data has been gathered.    
The data for each day comprises a time-sequence of stationDataSnaps  

Routines assume that raw station data, in the form of .csv files, are held in a directory such as 
"..\\..\\Data\\Station Data\\Station Status 2014 15 mins Cleansed\\"
Routines put processed data in "..\\..\\Data\\Station Data\\"


####Scripts   
Normally these should be run in the order mentioned.  

1. stationDataPrep3.R   
Reads in all the .csv files in a nominated directory (configure this)  
Writes out cleaned files to target directory  
Also writes out StationLUTyy.Rdata and ..csv  
Uses:   
1.1 addStationNumbers3  
stationData names used to look up stationNumbers.  

2. getLatLons.R  
Rewrites StationLUTyy.Rdata and ..csv to add lat-lons from station data files

3. stationDataLoader.R  
Loads all the .csv station data data files in a particular folder, e.g., cleaned    
into a single data frame, stored as an SDyy.Rdata object in the Station Data directory

4. lumpSmallStationData.R    DEVELOPMENT PAUSED 
Produces new SDL or SDM .. yy.Rdata object in which low-use stations are aggregated  

5. getDayStationData.R  
Retrieve all station data for a given date  

6. initStationSnap  
set iterator to retrieve first of a sequence of stationDataSnaps from the current day's data:  
 
+ initStationSnap ()  	
	* creates envStationSnap, and assigns it to .GlobalEnv	
	* calls  getDayStationData:	
		+ sets date in envStationSnap   
		+ loads year station data   
		+ extracts day needed, filtering out invalid stations using latitude   
		+ assigns year station data to environment   
		+ assigns day station data to environment   
	* initializes the time range	  
	* sets cursor to 0	
  

7. next StationSnap   
iterator to retrieve each of a sequence of stationDataSnaps from the current day's data:  

+ nextStationSnap()    
	* gets all data after cursor  
	* returns NULL if no data meet condition  
	* gets the first time stamp in that data  
	* selects only data at the time stamp  
	* selects relevant columns  
	* advances cursor  
	* calls cleanStationSnap()  
	* replaces all-zero data with NAs  
	* returns snap	
  
8. getStationSnap   
  get the stationSnap for a particular time, if it is available.
  if not, return NULL

