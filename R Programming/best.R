best <- function(state, ailment) {
  ## Read outcome data
  outcome <- read.csv("outcome-of-care-measures.csv", 
                      colClasses = "character")
  
  ## Check that state and outcome are valid
  outcome <- outcome[outcome$State == state,]
  if (nrow(outcome) == 0)
    stop("invalid state")
  
  data <- NULL
  if (ailment == "heart attack") {
    outcome <- outcome[complete.cases(outcome[,11]),]
    outcome[,11] <- as.numeric(outcome[,11])
    data <- outcome[order(outcome$Hospital.30.Day.Death..Mortality..Rates.from.Heart.Attack, outcome$Hospital.Name), ]
  } else if (ailment == "heart failure") {
    outcome <- outcome[complete.cases(outcome[,17]),]
    outcome[,17] <- as.numeric(outcome[,17])
    data <- outcome[order(outcome$Hospital.30.Day.Death..Mortality..Rates.from.Heart.Failure, outcome$Hospital.Name), ]
  } else if (ailment == "pneumonia") {
    outcome <- outcome[complete.cases(outcome[,23]),]
    outcome[,23] <- as.numeric(outcome[,23])
    data <- outcome[order(outcome$Hospital.30.Day.Death..Mortality..Rates.from.Pneumonia, outcome$Hospital.Name), ]
  } else
    stop("invalid outcome")
  
  ## Return hospital name in that state with lowest 30-day death
  ## rate
  
  return (data[1,2])
}