### Exploratory Data Analysis - Peer Assessment II

## Question 1 - Have total emissions from PM2.5 decreased in the United States from 1999 to 2008?
## Using the base plotting system, make a plot showing the total PM2.5 emission from all sources for each of the years 
## 1999, 2002, 2005, and 2008.

# Read data files
NEI <- readRDS("summarySCC_PM25.rds")
SCC <- readRDS("Source_Classification_Code.rds")

# Aggregating total emissions by year
NEI.agg <- aggregate(NEI$Emissions, list(NEI$year), FUN = "sum")

# Creating plot
png(file = "plot1.png")
with(NEI.agg, plot(NEI.agg, type = "l", xlab = "Year", ylab = expression('Total PM'[2.5]*" Emissions"), 
                   main = "Total Emissions in the United States From 1999 to 2008"))
dev.off()