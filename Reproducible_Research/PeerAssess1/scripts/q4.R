# q4.R: Kevin Payet
# given a data data.frame, this script adds a factor column with 2 levels:
# Weekday and Weekend, depending on the date column
# We use this new factor to produce a panel plot containing a time series plot 
# of the 5-minute interval (x-axis) and the average number of steps taken, 
# averaged across all weekday days or weekend days

days <- weekdays(data$date)
data$day <- as.character(days)

weekpos <- c(rep("Weekday", 5), rep("Weekend", 2))

df <- data.frame(day = unique(days), weekpos = weekpos)

data$weekpos <- sqldf("select b.weekpos from data a, df b where a.day = b.day")[[1]]

avg_steps_per_intvl <- with(data, aggregate(data$steps, 
                                            by = list(weekpos = weekpos, 
                                                      interval = interval), 
                                            FUN = mean, na.rm = TRUE))
names(avg_steps_per_intvl)[3] <- "Average.Steps"

g <- ggplot(data = avg_steps_per_intvl, aes(x = interval, y = Average.Steps))
g <- g + geom_line()
g <- g + theme_bw()
g <- g + xlab("Interval") + ylab("Average number of steps")
g <- g + facet_grid(weekpos ~ .)
g