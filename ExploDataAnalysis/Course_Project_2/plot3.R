library(ggplot2)
#NEI <- readRDS("exdata_data_NEI_data/summarySCC_PM25.rds")
#SCC <- readRDS("exdata_data_NEI_data/Source_Classification_Code.rds")

nei_plot <- qplot(data = subset(NEI, fips == "24510"), 
                  x = year, y = Emissions, 
                  stat="summary", fun.y = "sum",
                  facets = . ~ type)



dev.copy(png,file = "plot3.png")
dev.off()

