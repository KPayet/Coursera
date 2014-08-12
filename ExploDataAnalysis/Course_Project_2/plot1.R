NEI <- readRDS("exdata_data_NEI_data/summarySCC_PM25.rds")
SCC <- readRDS("exdata_data_NEI_data/Source_Classification_Code.rds")

years <- unique(NEI$year)
total_emissions <- numeric(0)

for (year in years) {
    
    total_emissions <- c(total_emissions, sum((NEI["Emissions"])[NEI["year"] == year]))
}

plot(years, total_emissions, xlab = "Year", ylab = "Total PM25 emission per year")

dev.copy(png,file = "plot1.png")
dev.off()