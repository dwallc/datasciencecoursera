### Exploratory Data Analysis - Peer Assessment II

## Question 6 - Compare emissions from motor vehicle sources in Baltimore City with emissions from motor vehicle sources 
## in Los Angeles County, California (fips == "06037"). Which city has seen greater changes over time in motor vehicle 
## emissions?

# Read data files
NEI <- readRDS("summarySCC_PM25.rds")
SCC <- readRDS("Source_Classification_Code.rds")

# Load ggplot2 plotting system
library(ggplot2)

# Extract emissions data corresponding to Baltimore (fips == "24510") and Los Angeles (fips == "06037")
NEI.24510.06037 <- NEI[NEI$fips == "24510"|NEI$fips == "06037", ]

# Extract emissions data from motor vehicle sources
SCC.motor.city <- grep("motor", SCC$Short.Name, ignore.case = TRUE)
SCC.motor.city <- SCC[SCC.motor.city, ]
SCC.motor.city <- NEI.24510.06037[NEI.24510.06037$SCC %in% SCC.motor.city$SCC, ]

# Creating plot
png(file = "plot6.png")
g <- ggplot(SCC.motor.city, aes(year, Emissions, color = fips))
g + geom_line(stat = "summary", fun.y = "sum") + xlab("Year") + 
  ylab(expression('Total PM'[2.5]*" Emissions")) + 
  ggtitle("A Comparison, by City, of Total Emissions\n From Motor Vehicle Sources From 1999 to 2008") + 
  scale_colour_discrete(name = "Cities", label = c("Los Angeles, CA", "Baltimore, MD"))
dev.off()