log10sum <- function(x) {
    return(log10(sum(x)))
}


#NEI <- readRDS("exdata_data_NEI_data/summarySCC_PM25.rds")
#SCC_DF <- readRDS("exdata_data_NEI_data/Source_Classification_Code.rds")
#library(ggplot2)
#library(sqldf)

# First, we need to find out the SCCs (col.1 in NEI) 
# of all motor vehicle sources 
# I will use the package sqldf to retrieve that info from SCC_DF:
# After investigation, it seems that this information is located
# in the EI.Sector column in SCC_DF. So:

names(SCC_DF)[4] <- "EI_Sector" # sql doesn't like the original name (EI.Sector)

query_res <- sqldf("select SCC from SCC_DF where EI_Sector like '%vehicle%'")

vehicle_SCCs <- as.character(query_res[["SCC"]]) # from query_res (DF) to characters vector

# now I can make the plot
png("plot6.png", width = 600, height = 360, units = "px")

qplot(data = subset(NEI, (SCC %in% vehicle_SCCs) & 
                                    (fips %in% c("24510","06037"))), 
                  x = year, y = Emissions,
                  stat="summary", 
                  fun.y = "log10sum", # I plot the sum of emissions for each year
                  color = fips,
                  xlab = "Year", ylab = "log10 Emissions")

dev.off()
