NEI <- readRDS("exdata_data_NEI_data/summarySCC_PM25.rds")
SCC <- readRDS("exdata_data_NEI_data/Source_Classification_Code.rds")

years <- unique(NEI$year)
total_emissions <- numeric(0)

for (year in years) {
    
    total_emissions <- c(total_emissions, 
           sum((NEI["Emissions"])[(NEI["year"] == year) 
                                  & (NEI["fips"] == "24510")]))
}

plot(years, total_emissions, xlab = "Year", 
     ylab = "Total PM25 emission per year", 
     main = "Total PM25 emissions for Baltimore")

dev.copy(png,file = "plot2.png")
dev.off()