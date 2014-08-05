data <- read.table(unz("exdata_data_household_power_consumption.zip",
                       "household_power_consumption.txt"), skip = 66636, 
                   nrow = 2880, header = TRUE, na.strings = "?",sep=";")

names(data) <- c("Date","Time","Global_active_power",
                 "Global_reactive_power","Voltage","Global_intensity",
                 "Sub_metering_1","Sub_metering_2","Sub_metering_3")

data$Time <- strptime(paste(data$Date,data$Time),format = "%d/%m/%Y %H:%M:%S")

plot(data$Time,data$Global_active_power,type = "l", 
     xlab = "", ylab = "Global Active Power (kilowatts)")

dev.copy(png, file = "plot2.png")
dev.off()
