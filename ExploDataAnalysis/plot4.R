data <- read.table(unz("exdata_data_household_power_consumption.zip",
                       "household_power_consumption.txt"), skip = 66636, 
                   nrow = 2880, header = TRUE, na.strings = "?",sep=";")

names(data) <- c("Date","Time","Global_active_power",
                 "Global_reactive_power","Voltage","Global_intensity",
                 "Sub_metering_1","Sub_metering_2","Sub_metering_3")

data$Time <- strptime(paste(data$Date,data$Time),format = "%d/%m/%Y %H:%M:%S")


png(filename = "plot4.png")

par(mfrow = c(2,2))

hist(data$Global_active_power,xlab = "Global Active Power (kilowatts)", 
     col = "red", main = "")

plot(data$Time,data$Voltage,type="l", xlab = "datetime", ylab = "Voltage")

plot(data$Time,data$Sub_metering_1,type = "n",xlab="",ylab="Energy sub metering")
lines(data$Time,data$Sub_metering_1,type="l")
lines(data$Time,data$Sub_metering_2,type="l",col = "red")
lines(data$Time,data$Sub_metering_3,type="l",col = "blue")
legend("topright", lty = "solid", 
       col =c("black","red","blue"),
       legend = c("Sub_metering_1","Sub_metering_2", "Sub_metering_3"), 
       cex = 0.9)

plot(data$Time,data$Global_reactive_power,type="l", 
     xlab = "datetime", ylab = "Global_reactive_power")

dev.off()
