##Programing Assignment 1 (Air Pollution) - Part 3

corr <- function(directory, threshold = 0) {
        ## 'directory' is a character vector of length 1 indicating
        ## the location of the CSV files

        ## 'threshold' is a numeric vector of length 1 indicating the
        ## number of completely observed observations (on all
        ## variables) required to compute the correlation between
        ## nitrate and sulfate; the default is 0

        ## Return a numeric vector of correlations
  
  degfree <- complete(directory)
  
  case <- degfree[degfree["nobs"] > threshold, ]$id
  
  correlate <- numeric()
  
  for(i in case) {
    data <- read.csv(paste(directory,"/",sprintf("%03d", i),".csv",sep=""))
    comp <- data[complete.cases(data), ]
    correlate <- c(correlate, cor(comp$sulfate, comp$nitrate))
  }
  return(correlate)
}


## Example output

cr <- corr("specdata", 150)
head(cr)

summary(cr)

cr <- corr("specdata", 400)
head(cr)

summary(cr)

cr <- corr("specdata", 5000)
summary(cr)

length(cr)

cr <- corr("specdata")
summary(cr)

length(cr)