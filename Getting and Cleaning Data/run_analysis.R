### Preliminary Activity


## Load required packages "data.table" and "reshape2"

# If these packages are not already installed, then uncomment and run the
# the following code.

# install.packages("data.table", "reshape2")
library(data.table, reshape2)


## Acquiring the Data

# Set download path for required data
path <- getwd()
path

# Download the required data file. After the file is downloaded, extract
# the folder containing the necessary files. DO NOT REMOVE THE FILES FROM
# THE FOLDER.
url <- 
  "https://d396qusza40orc.cloudfront.net/getdata%2Fprojectfiles%2FUCI%20HAR%20Dataset.zip"
data <- "UCI_HAR_Dataset.zip"
if (!file.exists(path)) {
  dir.create(path)
}
download.file(url, file.path(path, data))

# Set the input path and list the data files
pathIn <- file.path(path, "UCI HAR Dataset")
list.files(pathIn, recursive = TRUE)


## Reading the Files

# Read the subject files
SubjectTrain <- fread(file.path(pathIn, "train", "subject_train.txt"))
SubjectTest <- fread(file.path(pathIn, "test", "subject_test.txt"))

# Read the activity files
ActivityTrain <- fread(file.path(pathIn, "train", "y_train.txt"))
ActivityTest <- fread(file.path(pathIn, "test", "y_test.txt"))

# Read the data files
DataTable <- function(f) {
  df <- read.table(f)
  dt <- data.table(df)
}
Train <- DataTable(file.path(pathIn, "train", "X_train.txt"))
Test <- DataTable(file.path(pathIn, "test", "X_test.txt"))



### Course Project Requirements


## Part 1 - Merge the training and the test sets to create one data set

# Link the data tables
Subject <- rbind(SubjectTrain, SubjectTest)
setnames(Subject, "V1", "Subject")
Activity <- rbind(ActivityTrain, ActivityTest)
setnames(Activity, "V1", "ActivityNum")
DataTable <- rbind(Train, Test)

# Merge the columns
Subject <- cbind(Subject, Activity)
DataTable <- cbind(Subject, DataTable)

# Set the key
setkey(DataTable, Subject, ActivityNum)


## Part 2 - Extract only the measurements on the mean and standard 
## deviation for each measurement

# Read the "features.txt" file
Features <- fread(file.path(pathIn, "features.txt"))
setnames(Features, names(Features), c("FeatureNum", "FeatureName"))

# Subset mean and standard deviation measurements
Features <- Features[grepl("mean\\(\\)|std\\(\\)", FeatureName)]

# Convert column numbers to a vector of variable names
Features$FeatureCode <- Features[, paste0("V", FeatureNum)]
head(Features)

# Subset the variables via variable names
Select <- c(key(DataTable), Features$FeatureCode)
DataTable <- DataTable[, Select, with = FALSE]


## Part 3 - Use descriptive activity names to name the activities
## in the data set

# Read "activity_labels.txt" file
ActivityNames <- fread(file.path(pathIn, "activity_labels.txt"))
setnames(ActivityNames, names(ActivityNames), 
         c("ActivityNum", "ActivityName"))


## Part 4 - Label the data set with descriptive variable names

# Merge activity labels
DataTable <- merge(DataTable, ActivityNames, by = "ActivityNum", 
                   all.x = TRUE)

# Add 'ActivityName' as a key
setkey(DataTable, Subject, ActivityNum, ActivityName)

# Melt the data table to reshape into a stacked form
DataTable <- data.table(melt(DataTable, key(DataTable), 
                             variable.name = "FeatureCode"))

# Merge activity name
DataTable <- merge(DataTable, 
                   Features[, list(FeatureNum, FeatureCode, FeatureName)], 
                   by = "FeatureCode", all.x = TRUE)

# Create a new variable, 'Activity' that is equivalent to 
# 'ActivityName' as a factor class.
DataTable$Activity <- factor(DataTable$ActivityName)

# Create a new variable, 'Feature' that is equivalent to 'FeatureName'
# as a factor class.
DataTable$Feature <- factor(DataTable$FeatureName)

# Seperate features from 'FeatureName'
GrepThis <- function(regex) {
  grepl(regex, DataTable$Feature)
}
## Features with 2 categories
n <- 2
y <- matrix(seq(1, n), nrow = n)
x <- matrix(c(GrepThis("^t"), GrepThis("^f")), ncol = nrow(y))
DataTable$FeatDomain <- factor(x %*% y, labels = c("Time", "Freq"))
x <- matrix(c(GrepThis("Acc"), GrepThis("Gyro")), ncol = nrow(y))
DataTable$FeatInstrument <- factor(x %*% y, 
                                   labels = c("Accelerometer", "Gyroscope"))
x <- matrix(c(GrepThis("BodyAcc"), GrepThis("GravityAcc")), ncol = nrow(y))
DataTable$FeatAcceleration <- factor(x %*% y, 
                                     labels = c(NA, "Body", "Gravity"))
x <- matrix(c(GrepThis("mean()"), GrepThis("std()")), ncol = nrow(y))
DataTable$FeatVariable <- factor(x %*% y, labels = c("Mean", "SD"))
## Features with 1 category
DataTable$FeatJerk <- factor(GrepThis("Jerk"), labels = c(NA, "Jerk"))
DataTable$FeatMagnitude <- factor(GrepThis("Mag"), 
                                  labels = c(NA, "Magnitude"))
## Features with 3 categories
n <- 3
y <- matrix(seq(1, n), nrow = n)
x <- matrix(c(GrepThis("-X"), GrepThis("-Y"), 
              GrepThis("-Z")), ncol = nrow(y))
DataTable$FeatAxis <- factor(x %*% y, labels = c(NA, "X", "Y", "Z"))

# Check all possible combinations of 'Feature'
R1 <- nrow(DataTable[, .N, by = c("Feature")])
R2 <- nrow(DataTable[, .N, by = c("FeatDomain", 
                           "FeatAcceleration", "FeatInstrument", 
                           "FeatJerk", "FeatMagnitude", "FeatVariable", 
                           "FeatAxis")])
R1 == R2


## Part 5 - Create a second, independent tidy data set with the 
## average of each variable for each activity and each subject

setkey(DataTable, Subject, Activity, FeatDomain, FeatAcceleration, 
       FeatInstrument, FeatJerk, FeatMagnitude, FeatVariable, FeatAxis)
DataTableTidy <- DataTable[, list(count = .N, average = mean(value)), 
                           by = key(DataTable)]
DTT <- file.path(path, "DataTableTidy.txt")
write.table(DataTableTidy, DTT, quote=FALSE, sep="\t", row.names=FALSE)