#NEI <- readRDS("exdata_data_NEI_data/summarySCC_PM25.rds")

NEI_B <- subset(NEI, fips == "24510")

total_emissions_B <- with(NEI_B, aggregate(NEI_B$Emissions, 
                                       by = list(year = year), 
                                       FUN = sum))
names(total_emissions_B)[2] <- "Emissions"

plot(total_emissions_B$year, total_emissions_B$Emissions, 
     xlab = "Year", ylab = "Total PM25 emission per year", 
     main = "Total PM25 emissions for Baltimore")

dev.copy(png,file = "plot2.png")
dev.off()