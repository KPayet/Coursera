# we're going to replace the missing steps values by the average number of steps
# across all days, for the corresponding 5-min interval
# we reuse the code of question 2 to produce a data.frame avg_steps_per_intvl 

avg_steps_per_intvl <- with(data, aggregate(data$steps, 
                                            by = list(interval = interval), 
                                            FUN = mean, na.rm = TRUE))
names(avg_steps_per_intvl)[2] <- "Average.Steps"

steps_col <- data$steps

intervals <- subset(data, is.na(data$steps), select = c(3))

library(sqldf)

avg_steps <- (sqldf("select * from intervals a, avg_steps_per_intvl b \
                   where a.interval = b.interval"))[[3]]

steps_col[is.na(steps_col)] <- avg_steps

data$steps <- steps_col # data$steps has no more missing values

