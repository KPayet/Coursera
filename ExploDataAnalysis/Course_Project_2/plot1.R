NEI <- readRDS("exdata_data_NEI_data/summarySCC_PM25.rds")

total_emissions <- with(NEI, aggregate(NEI$Emissions, 
                                       by = list(year = year), FUN = sum))
names(total_emissions)[2] <- "Emissions"

plot(total_emissions$year, total_emissions$Emissions, 
     xlab = "Year", ylab = "Total PM25 emission per year")

dev.copy(png,file = "plot1.png")
dev.off()