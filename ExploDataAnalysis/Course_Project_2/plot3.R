library(ggplot2)
#NEI <- readRDS("exdata_data_NEI_data/summarySCC_PM25.rds")

png("plot3.png",width = 720, height = 480, units = "px")

qplot(data = subset(NEI, fips == "24510"), 
              x = year, y = Emissions, 
              stat="summary", fun.y = "sum",
              facets = . ~ type)

dev.off()

