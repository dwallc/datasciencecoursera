### Exploratory Data Analysis - Peer Assessment II

## Question 3 - Of the four types of sources indicated by the type (point, nonpoint, onroad, nonroad) variable, which of 
## these four sources have seen decreases in emissions from 1999–2008 for Baltimore City? Which have seen increases in 
## emissions from 1999–2008? Use the ggplot2 plotting system to make a plot answer this question.

# Read data files
NEI <- readRDS("summarySCC_PM25.rds")
SCC <- readRDS("Source_Classification_Code.rds")

# Load ggplot2 plotting system
library(ggplot2)

# Extract emissions data corresponding to Baltimore (fips == "24510")
NEI.24510 <- NEI[NEI$fips == "24510", ]

# Creating plot
png(file = "plot3.png")
g <- ggplot(NEI.24510, aes(year, Emissions, color = type))
g + geom_line(stat = "summary", fun.y = "sum") + xlab("Year") + 
  ylab(expression('Total PM'[2.5]*" Emissions")) + 
  ggtitle("Total Emissions in Baltimore, Maryland From 1999 to 2008")
dev.off()