rankhospital <- function(state, ailment, num = "best") {
  ## Read outcome data
  outcome <- read.csv("outcome-of-care-measures.csv", 
                      colClasses = "character")
  
  ## Check that state and outcome are valid
  outcome <- outcome[outcome$State == state,]
  if (nrow(outcome) == 0)
    stop("invalid state")
  
  ailment <- if (ailment == "heart attack") {
    "Hospital.30.Day.Death..Mortality..Rates.from.Heart.Attack"
  } else if (ailment == "heart failure") {
    "Hospital.30.Day.Death..Mortality..Rates.from.Heart.Failure"
  } else if (ailment == "pneumonia") {
    "Hospital.30.Day.Death..Mortality..Rates.from.Pneumonia"
  } else {
    stop("invalid outcome")
  }
  
  ## Return hospital name in that state with the given rank
  ## 30-day death rate
  
  data <- outcome[outcome$State == state, c("Hospital.Name", ailment)]
  data[,2] <- as.numeric(data[,2])
  result <- order(data[ailment], data$Hospital.Name, na.last=NA)
  
  if (num == "best") {
    as.character(data$Hospital.Name[result[1]])
  } else if (num == "worst") {
    as.character(data$Hospital.Name[result[length(result)]])
  } else if (is.numeric(num)) {
    as.character(data$Hospital.Name[result[num]])
  } else {
    stop("invalid num")
  }
}