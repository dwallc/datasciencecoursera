rankall <- function(ailment, num = "best") {
  ## Read outcome data
  outcome <- read.csv("outcome-of-care-measures.csv", 
                      colClasses = "character")
  
  ## Check that state and outcome are valid
  diagnosis <- if (ailment == "heart attack") {
    outcome[, 11] <- as.numeric(outcome[, 11])
    "Hospital.30.Day.Death..Mortality..Rates.from.Heart.Attack"
  } else if (ailment == "heart failure") {
    outcome[, 17] <- as.numeric(outcome[, 17])
    "Hospital.30.Day.Death..Mortality..Rates.from.Heart.Failure"
  } else if (ailment == "pneumonia") {
    outcome[, 23] <- as.numeric(outcome[, 23])
    "Hospital.30.Day.Death..Mortality..Rates.from.Pneumonia"
  } else {
    stop("invalid outcome")
  }
  
  ## For each state, find the hospital of the given rank
  data <- split(outcome[, c("Hospital.Name", "State", diagnosis)], 
                outcome$State)
  ranks <- function(state_data, num) {
    ordereddata <- order(state_data[3], state_data$Hospital.Name, na.last=NA)
    if (num == "best") {
      state_data$Hospital.Name[ordereddata[1]]
    } else if (num == "worst") {
      state_data$Hospital.Name[ordereddata[length(ordereddata)]]
    } else if (is.numeric(num)) {
      state_data$Hospital.Name[ordereddata[num]]
    } else {
      stop("invalid num")
    }
  }
  
  ## Return a data frame with the hospital names and the
  ## (abbreviated) state name
  preresult <- lapply(data, ranks, num)
  data.frame(hospital = unlist(preresult), state = names(preresult), 
             row.names = names(preresult))
  
}