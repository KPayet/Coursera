# q2.R: Kevin Payet
# Script for second question of Assignment 1 of Reproducible Research

# for this question, we can ignore the missing values, i.e. we're going to use
# the data data.frame

avg_steps_per_intvl <- with(data, aggregate(data$steps, 
                                            by = list(interval = interval), 
                                            FUN = mean, na.rm = TRUE))
names(avg_steps_per_intvl)[2] <- "Average.Steps"

library(ggplot2)

g <- ggplot(data = avg_steps_per_intvl, aes(x = interval, y = Average.Steps))
g <- g + geom_line()
g <- g + theme_bw()
g <- g + xlab("Interval") + ylab("Average number of steps")
g

max_int <- avg_steps_per_intvl[which.max(avg_steps_per_intvl$Average.Steps), 1]
g + geom_vline(xintercept = max_int, colour = "red")
