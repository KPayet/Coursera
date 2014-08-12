# q1.R: Kevin Payet
# Script for first question of Assignment 1 of Reproducible Research

# for this question, we can ignore the missing values, i.e. we're going to use
# the data data.frame
# given a data data.frame, this script plots the histogram of the
# total number of steps taken each day, and computes the mean and median total 
# number of steps taken per day, stored in mean_steps_per_day and
# median_steps_per_day respectively

steps_per_day <- with(data, aggregate(data[1], by = list(Date = date), FUN = sum))

library(ggplot2)

g <- ggplot(data = steps_per_day, aes(x = Date, y = steps))
g <- g + geom_histogram(stat = "identity")
g <- g + theme_bw()
g <- g + xlab("Day") + ylab("Total number of steps per day")
g

#mean_steps_per_day <- mean(steps_per_day$steps, na.rm = TRUE)

#median_steps_per_day <- median(steps_per_day$steps, na.rm = TRUE)

