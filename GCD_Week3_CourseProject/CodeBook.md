---
title: "CodeBook.md"
author: "Kevin Payet"
date: "Thursday, July 24, 2014"
output: html_document
---

Course project - Getting and Cleaning data
----------------------------------------------------------------------------------

This file gives some clarifications/descriptions of the script and data used in the course project.

**Original data**

The original data set that was used to obtain the tidy data is divided into several directories (parent directory .../UCI HAR Dataset/):

- test directory: 
    - X_test.txt: the main data set, a 2948 rows data set of 561 features vector
    - y_test.txt: The corresponding activity (Standing, Sitting, Laying...)for each of these measurements (also 2948 rows)
    - subject_test.txt: The subject ID (from 1 to 30) for the given measurement (also 2948)
- train directory: This directory is organised in the exact same way as the former. The characteristics of the file are exactly the same, except for the number of measurements which is 7353 here
- root directory (inside UCI HAR Dataset/):
    - features.txt: a 561 rows file. Each row gives the name of one of the features in X_test/train.txt
    - activity_labels.txt: gives the activity name corresponding to the activity ID found in y_test/train.txt
    
**Goal**

We want to merge the data from X_i.txt, y_i.txt and subject_i.txt, where i in (test, train), into a single data frame, then, merge the train and test data sets.

We then extract the information on the mean and standard deviation for each measurement. Finally, we produce a tidy data set with the average of each variable  for every subject and activity. The output data set will contain 30 x 6 = 180 rows.

**Steps**

I describe the steps that are used in the R script clean_data.R. It's pretty straightforward:

1. Load features.txt and activity_labels.txt into two data.frames. These are used to give proper labels to the X_i.txt columns and to the activities in y_i.txt, respectively
2. Load X_test.txt, y_test.txt and subject_test.txt in three data.frames (named X_test, activity_test and subject_test respectively)
    - Using the information from activity_labels.txt, I add a new column in the activity_test data.frame, which gives the activity name corresponding to the activity id (1:6) for each row
    - add proper variable names to each column in X_test, using the information from features.txt. I also give names to activity_test and subject_test columns
    - I cbind subject_test + activity_test + X_test into a new data.frame
    - The created data.frame contains a subjectID column, activity ID and activity name columns and the original 561 features vector, each correctly labeled.
3. I do exactly the same for the train files
4. I now have two 564 columns data set with the characteristics described above, one for the test data set and one for the training one.
I just have to rbind them to create the full dataset, stored in a new data.frame called total_data
5. Now, I extract the information for the mean and standard deviation for each measurement:
    - Using grep, and the names(total_data) vector, I extract the indices of the column that have mean() or std() (standard deviation) in their variable name. These indices are stored into a vector that is sorted.
    - I use the indices vector to store the information I am interested in in a new data.frame, mean_std_data, e.g. the 3 first columns (SubjectID, ActivityID, ActivityName) + the mean and standard deviation columns
6. I compute the average of all the columns (except the first three) for each subject and each activity, using the aggregate function: the by parameter is set to `by = list(SubjectID = SubjectID, ActivityID = ActivityID)` and the FUN parameter to `mean`. The values are stored in the data.frame tidy_data
7. I order tidy_data using arrange from the plyr package (ordering by SubjectID and ActivityID). This is just so that the final dataset is easier to read.
8. I add the activity names back in the tidy data set: add an ActivityName column to the data.frame, and use activity_labels to rename each element according to its ActivityID
9. I write the tidy data set to a text file (tidy_data.txt) in the same directory as clean_data.R (can of course be modified). The `row.names` parameter should be `FALSE` to avoid R adding a "row name" column to the output data set.


And **Done!**

**Tidy data set**

180 rows (30 subjects x 6 activities) and 82 columns.

The data set has been ordered by SubjectID, from 1 to 30, and then by ActivityID (1 to 6), to allow for an easier reading.

The column variables are properly labeled according to the features.txt file. For more details on these variables, see below or on 'http://archive.ics.uci.edu/ml/datasets/Human+Activity+Recognition+Using+Smartphones'.

The information below come from the features_info.txt file in the 'UCI HAR Dataset' directory:

<blockquote cite="http://archive.ics.uci.edu/ml/datasets/Human+Activity+Recognition+Using+Smartphones">
<font size="3">
Feature Selection </font>

<font size="2">The features selected for this database come from the accelerometer and gyroscope 3-axial raw signals tAcc-XYZ and tGyro-XYZ. These time domain signals (prefix 't' to denote time) were captured at a constant rate of 50 Hz. Then they were filtered using a median filter and a 3rd order low pass Butterworth filter with a corner frequency of 20 Hz to remove noise. Similarly, the acceleration signal was then separated into body and gravity acceleration signals (tBodyAcc-XYZ and tGravityAcc-XYZ) using another low pass Butterworth filter with a corner frequency of 0.3 Hz. </font>

<font size="2">Subsequently, the body linear acceleration and angular velocity were derived in time to obtain Jerk signals (tBodyAccJerk-XYZ and tBodyGyroJerk-XYZ). Also the magnitude of these three-dimensional signals were calculated using the Euclidean norm (tBodyAccMag, tGravityAccMag, tBodyAccJerkMag, tBodyGyroMag, tBodyGyroJerkMag). </font>

<font size="2">Finally a Fast Fourier Transform (FFT) was applied to some of these signals producing fBodyAcc-XYZ, fBodyAccJerk-XYZ, fBodyGyro-XYZ, fBodyAccJerkMag, fBodyGyroMag, fBodyGyroJerkMag. (Note the 'f' to indicate frequency domain signals). </font>

<font size="2">These signals were used to estimate variables of the feature vector for each pattern:  
'-XYZ' is used to denote 3-axial signals in the X, Y and Z directions.</font>

<blockquote>
<font size="2">tBodyAcc-XYZ</font>

<font size="2">tGravityAcc-XYZ</font>

<font size="2">tBodyAccJerk-XYZ</font>

<font size="2">tBodyGyro-XYZ</font>

<font size="2">tBodyGyroJerk-XYZ</font>

<font size="2">tBodyAccMag</font>

<font size="2">tGravityAccMag</font>

<font size="2">tBodyAccJerkMag</font>

<font size="2">tBodyGyroMag</font>

<font size="2">tBodyGyroJerkMag</font>

<font size="2">fBodyAcc-XYZ</font>

<font size="2">fBodyAccJerk-XYZ</font>

<font size="2">fBodyGyro-XYZ</font>

<font size="2">fBodyAccMag</font>

<font size="2">fBodyAccJerkMag</font>

<font size="2">fBodyGyroMag</font>

<font size="2">fBodyGyroJerkMag</font>
</blockquote>

<font size="2">The set of variables that were estimated from these signals are: </font>

<blockquote>
<font size="2">mean(): Mean value</font>

<font size="2">std(): Standard deviation</font>

<font size="2">mad(): Median absolute deviation </font>

<font size="2">max(): Largest value in array</font>

<font size="2">min(): Smallest value in array</font>

<font size="2">sma(): Signal magnitude area</font>

<font size="2">energy(): Energy measure. Sum of the squares divided by the number of values. </font>

<font size="2">iqr(): Interquartile range </font>

<font size="2">entropy(): Signal entropy</font>

<font size="2">arCoeff(): Autorregresion coefficients with Burg order equal to 4</font>

<font size="2">correlation(): correlation coefficient between two signals</font>

<font size="2">maxInds(): index of the frequency component with largest magnitude</font>

<font size="2">meanFreq(): Weighted average of the frequency components to obtain a mean </font>

<font size="2">frequency</font>

<font size="2">skewness(): skewness of the frequency domain signal </font>

<font size="2">kurtosis(): kurtosis of the frequency domain signal </font>

<font size="2">bandsEnergy(): Energy of a frequency interval within the 64 bins of the FFT of each window.</font>

<font size="2">angle(): Angle between to vectors.</font>
</blockquote>

<font size="2">Additional vectors obtained by averaging the signals in a signal window sample. These are used on the angle() variable:</font>

<blockquote>
<font size="2">gravityMean</font>

<font size="2">tBodyAccMean</font>

<font size="2">tBodyAccJerkMean</font>

<font size="2">tBodyGyroMean</font>

<font size="2">tBodyGyroJerkMean</font>
</blockquote>

<font size="2">The complete list of variables of each feature vector is available in 'features.txt'
</font>
</blockquote>

Our data set contains the values of the mean and standard deviation for the above variables, averaged for each subject and each activity, as well as the subjectID, from 1 to 30, and the ActivityID (from 1 to 6) and ActivityName.
