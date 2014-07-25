### Exploratory Data Analysis - Peer Assessment II

## Question 5 - How have emissions from motor vehicle sources changed from 1999–2008 in Baltimore City?

# Read data files
NEI <- readRDS("summarySCC_PM25.rds")
SCC <- readRDS("Source_Classification_Code.rds")

# Extract emissions data corresponding to Baltimore (fips == "24510")
NEI.24510 <- NEI[NEI$fips == "24510", ]

# Extract emissions data from motor vehicle sources
SCC.motor <- grep("motor", SCC$Short.Name, ignore.case = TRUE)
SCC.motor <- SCC[SCC.motor, ]
SCC.motor <- NEI.24510[NEI.24510$SCC %in% SCC.motor$SCC, ]

# Aggregating motor vehicle emissions in Baltimore by year
SCC.motor.agg <- aggregate(SCC.motor$Emissions, list(SCC.motor$year), FUN = "sum")

# Creating plot
png(file = "plot5.png")
with(SCC.motor.agg, plot(SCC.motor.agg, type = "l", xlab = "Year", ylab = expression('Total PM'[2.5]*" Emissions"), 
                         main = "Total Emissions From Motor Vehicle Sources\n From 1999 to 2008 in Baltimore, Maryland"))
dev.off()