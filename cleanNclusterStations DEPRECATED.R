t1_cleanNcluster <- Sys.time()


stationFile$StationName <-  str_replace_all(stationFile$StationName, "  ", " ")

stationFile$StationName <-  str_replace_all(stationFile$StationName, " ,", ",")

# Waterloo cluster
stationFile$StationName <-  str_replace_all(stationFile$StationName, fixed("Waterloo Station 1, Waterloo"), "Waterloo Stations123, Waterloo")
stationFile$StationName <-  str_replace_all(stationFile$StationName, fixed("Waterloo Station 2, Waterloo"), "Waterloo Stations123, Waterloo")
stationFile$StationName <-  str_replace_all(stationFile$StationName, fixed("Waterloo Station 3, Waterloo"), "Waterloo Stations123, Waterloo")

# Southwark cluster
stationFile$StationName <-  str_replace_all(stationFile$StationName, fixed("Southwark Station 1, Southwark"), "Southwark Stations12, Southwark")
stationFile$StationName <-  str_replace_all(stationFile$StationName, fixed("Southwark Station 2, Southwark"), "Southwark Stations12, Southwark")

# New North Road cluster
stationFile$StationName <-  str_replace_all(stationFile$StationName, fixed("New North Road 1, Hoxton"), "New North Road 12, Hoxton")
stationFile$StationName <-  str_replace_all(stationFile$StationName, fixed("New North Road 2, Hoxton"), "New North Road 12, Hoxton")

# Royal Avenue cluster
stationFile$StationName <-  str_replace_all(stationFile$StationName, fixed("Royal Avenue 1, Chelsea"), "Royal Avenue 12, Chelsea")
stationFile$StationName <-  str_replace_all(stationFile$StationName, fixed("Royal Avenue 2, Chelsea"), "Royal Avenue 12, Chelsea")

# Concert Hall Approach cluster 
stationFile$StationName <-  str_replace_all(stationFile$StationName, fixed("Concert Hall Approach 1, South Bank"), "Concert Hall Approach 12, South Bank")
stationFile$StationName <-  str_replace_all(stationFile$StationName, fixed("Concert Hall Approach 2, South Bank"), "Concert Hall Approach 12, South Bank")

# Speakers' Corner cluster 
stationFile$StationName <-  str_replace_all(stationFile$StationName, fixed("Speakers' Corner 1, Hyde Park"), "Speakers' Corner 12, Hyde Park")
stationFile$StationName <-  str_replace_all(stationFile$StationName, fixed("Speakers' Corner 2, Hyde Park"), "Speakers' Corner 12, Hyde Park")

# New Road cluster 
stationFile$StationName <-  str_replace_all(stationFile$StationName, fixed("New Road 1, Whitechapel"), "New Road 12, Whitechapel")
stationFile$StationName <-  str_replace_all(stationFile$StationName, fixed("New Road 2, Whitechapel"), "New Road 12, Whitechapel")

# Queen Street cluster 
stationFile$StationName <-  str_replace_all(stationFile$StationName, fixed("Queen Street, Bank"), "Queen Street 12, Bank")
stationFile$StationName <-  str_replace_all(stationFile$StationName, fixed("Queen Street 2 , Bank"), "Queen Street 12, Bank")

t2_cleanNcluster <-  Sys.time()
message(cat("cleanNclusterStations Elapsed Time:",t2_cleanNcluster - t1_cleanNcluster))
