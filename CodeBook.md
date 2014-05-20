# CodeBook for run_analysis.R script in this repo
========================================================
## The data

### Data source:   
https://d396qusza40orc.cloudfront.net/getdata%2Fprojectfiles%2FUCI%20HAR%20Dataset.zip 

### Data authors:   
Jorge L. Reyes-Ortiz, Davide Anguita, Alessandro Ghio, Luca Oneto. 
Smartlab - Non Linear Complex Systems Laboratory 
DITEN - Universit√  degli Studi di Genova, Genoa I-16145, Italy. 
activityrecognition '@' smartlab.ws 
www.smartlab.ws 
Link to details of the study:
http://archive.ics.uci.edu/ml/datasets/Human+Activity+Recognition+Using+Smartphones

### Study design
The data was collected from subjects wearing a Samsumg GalaxyII smartphone while performing 6 different activities of daily living (standing, sitting, laying down, walking, walking downstairs and upstairs). The raw data was collected as inertial signals from the phones accelerometer and gyroscope, and can be found in the folders under intertial signals. This raw data is not directly used in the script.  Rather, the data found in the x_train.txt and x_test.txt was used.  These two files contain both the orginal raw data, as well as some derived variables such as mean, standard deviation, mad, max, min, and a few others.  The names of the variables, both raw and derived, are found in the file called features.txt.  There were initially two sets of data, each with 561 features (variables).  One data set contained data used to train the software (7352 observations of each feature) representing 70% of the total observations, and a second set of data (2947 observations for each feature) representing 30% of the total data which was used to test the results of the training data. All features are normalized and bounded between-1 and +1. There are also files (y_train.txt and y_test.txt) which link the activities of daily living to the actual data.  subject_train.txt and subject_test.txt link the individual subject IDs to this data, and the activity_labels.txt file decodes the 6 activities.

More details of the variables can be found in the README.txt that downloads with the data. 

## The variables

The run_analysis.R script combines all the related information about subject ID, activity and variables (features) into one data frame.   It then selects only those features which are related to mean or standard deviation (derived), not including mean frequency (meanFreq()).  It further refines the names of the resulting 68 features to exclude possible illegal characters (specifically "()" and "-"), as well as capitalizing the remaining abbreviations to make them easier to read.  The incorrectly coded features starting with "fBodyBody...' are also corrected to read just "fBody...". The abbreviations and definitions used in the final tidied data are:

Acc: accelerometer measurements, has both gravitational and body motion components  
Std: standard devitaion 
Mean: mean or average
X,Y, and Z are used to denote 3-axial signals in the X, Y and Z directions of the phone.  
Gyro: Gyroscope measurements  
t: Time domain signals captured at a constant rate of 50Hz  
Jerk: Linear acceleration and angular velocity   
Gravity: Gravity component derived from acceleration signals  
Body: Body motion component derived from acceleration signals  
Mag: Magnitude of linear acceleration and angular velocity 
f: frequency domain  


These refined feature names are as follows:

"tBodyAccStdX"  
"tGravityAccMeanY"  
"tGravityAccStdZ"  
"tBodyAccJerkStdX"  
"tBodyGyroMeanY"  
"tBodyGyroStdZ"  
"tBodyGyroJerkStdX"  
"tBodyAccMagStd"  
"tBodyAccJerkMagStd"  
"tBodyGyroJerkMagStd"  
"fBodyAccStdX"  
"fBodyAccJerkMeanY"  
"fBodyAccJerkStdZ"  
"fBodyGyroStdX"  
"fBodyAccMagStd"  
"fBodyGyroMagStd"  
"tBodyAccMeanX"  
"tBodyAccStdY"  
"tGravityAccMeanZ"  
"tBodyAccJerkMeanX"  
"tBodyAccJerkStdY"  
"tBodyGyroMeanZ"  
"tBodyGyroJerkMeanX"  
"tBodyGyroJerkStdY"  
"tGravityAccMagMean"  
"tBodyGyroMagMean"  
"fBodyAccMeanX"  
"fBodyAccStdY"  
"fBodyAccJerkMeanZ"  
"fBodyGyroMeanX"  
"fBodyGyroStdY"  
"fBodyAccJerkMagMean"  
"fBodyGyroJerkMagMean"  
"tBodyAccMeanY"  
"tBodyAccStdZ"  
"tGravityAccStdX"  
"tBodyAccJerkMeanY"  
"tBodyAccJerkStdZ"  
"tBodyGyroStdX"  
"tBodyGyroJerkMeanY"  
"tBodyGyroJerkStdZ"  
"tGravityAccMagStd"  
"tBodyGyroMagStd"  
"fBodyAccMeanY"  
"fBodyAccStdZ"  
"fBodyAccJerkStdX"  
"fBodyGyroMeanY"  
"fBodyGyroStdZ"  
"fBodyAccJerkMagStd"  
"fBodyGyroJerkMagStd"  
"tBodyAccMeanZ"  
"tGravityAccMeanX"  
"tGravityAccStdY"  
"tBodyAccJerkMeanZ"  
"tBodyGyroMeanX"  
"tBodyGyroStdY"  
"tBodyGyroJerkMeanZ"  
"tBodyAccMagMean"  
"tBodyAccJerkMagMean"  
"tBodyGyroJerkMagMean"  
"fBodyAccMeanZ"  
"fBodyAccJerkMeanX"  
"fBodyAccJerkStdY"  
"fBodyGyroMeanZ"  
"fBodyAccMagMean"  
"fBodyGyroMagMean"  

## Transformations

The transformations on the data fall under the following scripts in the run_analysis.R

Combining test files by column (x_test, y_test, subject_test):

```{r}
mergedTest=cbind(subject_test, test_labels, test_set)
```

Combining training files by column (x_train, y_train, subject_train):

```{r}
mergedTrain=cbind(subject_train, train_labels, train_set)
```

Merging the test set and training set by row:

```{r}
mergedAll=rbind(mergedTest, mergedTrain)
```

Renaming the columns in the merged set:

```{r}
names(mergedAll)[1]= "SubjectID"
names(mergedAll)[2]= "Activity"
names(mergedAll)[3:563]= features[,2]
```

Filtering to retain only those features which measure mean or standard deviation:

```{r}
meanSD=mergedAll[grep("mean\\(\\)|std\\(\\)|Subject|Activity",names(mergedAll),)]
```

Labeling the activities by iterating over activity_labels.txt
```{r}
activityLabels= read.table("activity_labels.txt",stringsAsFactors =FALSE, header=FALSE, sep="")
for (activity in 1:6){
  meanSD$Activity[meanSD$Activity == activity]=activityLabels[activity,2]
}
```

Removing illegal characters and capitalisong abbreviations:
```{r}
a <- gsub("\\(\\)|-","",names(meanSD))  
b <- gsub("mean","Mean", a)
c <- gsub("std","Std", b)
d <- gsub("BodyBody", "Body", c)
names(meanSD) <- as.character(w) 
```

Aggregating the measurements and calculating the mean for each subject and each activity:

```{r}
tidyData=aggregate(x=meanSD[,3:68], by=list(SubjectID = meanSD$SubjectID, Activity = meanSD$Activity), FUN="mean")

```




