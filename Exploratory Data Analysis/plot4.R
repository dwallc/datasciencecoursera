### Exploratory Data Analysis - Peer Assessment II

## Question 4 - Across the United States, how have emissions from coal combustion-related sources changed from 1999–2008?

# Read data files
NEI <- readRDS("summarySCC_PM25.rds")
SCC <- readRDS("Source_Classification_Code.rds")

# Extract emissions data from coal combustion-related sources
SCC.coal <- grep("coal", SCC$Short.Name, ignore.case = TRUE)
SCC.coal <- SCC[SCC.coal, ]
SCC.coal <- NEI[NEI$SCC %in% SCC.coal$SCC, ]

# Aggregating coal combustion-related emissions by year
SCC.coal.agg <- aggregate(SCC.coal$Emissions, list(SCC.coal$year), FUN = "sum")

# Creating plot
png(file = "plot4.png")
with(SCC.coal.agg, plot(SCC.coal.agg, type = "l", xlab = "Year", ylab = expression('Total PM'[2.5]*" Emissions"), 
                         main = "Total Emissions From Coal Combustion-related Sources\n From 1999 to 2008"))
dev.off()