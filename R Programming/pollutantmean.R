##Programing Assignment 1 (Air Pollution) - Part 1

pollutantmean <- function(directory, pollutant, id = 1:332) {
  ## 'directory' is a character vector of length 1 indicating
  ## the location of the CSV files
  
  ## 'pollutant' is a character vector of length 1 indicating
  ## the name of the pollutant for which we will calculate the
  ## mean; either "sulfate" or "nitrate".
  
  ## 'id' is an integer vector indicating the monitor ID numbers
  ## to be used
  
  ## Return the mean of the pollutant across all monitors list
  ## in the 'id' vector (ignoring NA values)
  
  Data <- data.frame()
  
  for(file in rep(id)) {
    Data <- rbind(Data,read.csv(paste(directory,"/",sprintf("%03d", file),".csv",sep="")))
  }
  
  result <- mean(as.matrix(Data[pollutant]), na.rm = TRUE)
  
  as.vector(result)
  
  return(round(result, 3))
}


## Example output
pollutantmean("specdata", "sulfate", 1:10)

pollutantmean("specdata", "nitrate", 70:72)

pollutantmean("specdata", "nitrate", 23)