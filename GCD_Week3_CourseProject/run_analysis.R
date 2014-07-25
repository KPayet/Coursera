## clean_data.R: Kevin Payet
## loads, merges and cleans the UCI HAR datasets, and extracts a new tidy dataset
## with the mean of every variable, grouped by subjects and activities

library(plyr)

# I load the features and activity labels data. I will use them to add proper
# names to the column, and add an ActivityName column in the data set

features_names <- read.table("UCI HAR Dataset/features.txt")
feat_names_vec <- as.character(features_names$V2)

activity_labels <- read.table("UCI HAR Dataset/activity_labels.txt")
names(activity_labels) <- c("ID", "NAME")

# create 3 data.frames from the 3 files that contain the information I need
# These 3 data.frames are meant to be merged into one
X_test <- read.table("UCI HAR Dataset/test/X_test.txt")
activity_test <- read.table("UCI HAR Dataset/test/y_test.txt")
subject_test <- read.table("UCI HAR Dataset/test/subject_test.txt")

# I add a new column in activity_test, with the name of the activity.
# For that I use the information from activity_labels.txt
for (i in activity_labels$ID) {
    activity_test[which(activity_test[,1] == i),2] <- 
        as.character(activity_labels[i,2])
}


# I add the proper column names to the main data set. These names come from
# the features.txt file, and were loaded into feat_names_vec
names(X_test) <- feat_names_vec

# I add proper names for the activity and subject dfs
names(activity_test) <- c("ActivityID","ActivityName")

names(subject_test) <- "SubjectID"

# and merge them together. The output df is 
X_test <- cbind(subject_test, activity_test, X_test) # with all you need

## do exactly the same for train

X_train <- read.table("UCI HAR Dataset/train/X_train.txt")
activity_train <- read.table("UCI HAR Dataset/train/y_train.txt")
subject_train <- read.table("UCI HAR Dataset/train/subject_train.txt")

for (i in activity_labels$ID) {
    activity_train[which(activity_train[,1] == i),2] <- 
        as.character(activity_labels[i,2])
}

names(X_train) <- feat_names_vec

names(activity_train) <- c("ActivityID","ActivityName")

names(subject_train) <- "SubjectID"

X_train <- cbind(subject_train, activity_train, X_train) # with all you need

# bring test and train data sets together with rbind
total_data <- rbind(X_test, X_train)

# then, I extract the indices of the mean and std variables, and used them to 
# subset the columns with the means and standard deviations
mean_std_indexes <- sort(c(grep("mean", names(total_data), perl=T),
                      grep("std", names(total_data), perl=T)))
mean_std_data <- total_data[, c(1,2,3, mean_std_indexes)]

## now compute the average of all the column for each subject and each activity
## we should be left with a 30 subjects * 6 activities = 180 rows + 82 columns dataset

tidy_data <- with(mean_std_data, 
                  aggregate(mean_std_data[,4:ncol(mean_std_data)], 
                            by = list(SubjectID = SubjectID, 
                                      ActivityID = ActivityID), 
                            FUN = mean))

# I order the data frame a little with arrange from the package plyr
# ordering by SubjectID and then ActivityID
tidy_data <- arrange(tidy_data, SubjectID, ActivityID)

# I add the activity names back in the tidy data set: add an ActivityName column
# to the data.frame, and use activity_labels to rename each element according to
# its ActivityID
tidy_data <- cbind(tidy_data[1:2], 
                   data.frame(ActivityName = rep("XXX", nrow(tidy_data)),
                              stringsAsFactors = FALSE), 
                   tidy_data[3:ncol(tidy_data)])
for (i in activity_labels$ID) {
    tidy_data[which(tidy_data[,2] == i),3] <- 
        as.character(activity_labels[i,2])
}

#and write it to a .txt file
write.table(tidy_data,file = "tidy_data.txt", row.names = FALSE)