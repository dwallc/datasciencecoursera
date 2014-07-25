### Exploratory Data Analysis - Peer Assessment II

## Question 2 - Have total emissions from PM2.5 decreased in the Baltimore City, Maryland (fips == "24510") 
## from 1999 to 2008? Use the base plotting system to make a plot answering this question.

# Read data files
NEI <- readRDS("summarySCC_PM25.rds")
SCC <- readRDS("Source_Classification_Code.rds")

# Extract emissions data corresponding to Baltimore (fips == "24510")
NEI.24510 <- NEI[NEI$fips == "24510", ]

# Aggregating total emissions by year
NEI.24510.agg <- aggregate(NEI.24510$Emissions, list(NEI.24510$year), FUN = "sum")

# Creating plot
png(file = "plot2.png")
with(NEI.24510.agg, plot(NEI.24510.agg, type = "l", xlab = "Year", ylab = expression('Total PM'[2.5]*" Emissions"), 
                   main = "Total Emissions in Baltimore, Maryland From 1999 to 2008"))
dev.off()