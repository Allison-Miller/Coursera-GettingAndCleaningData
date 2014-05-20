# Read features 

#561 measurement variables in one column
features <- read.table("features.txt",stringsAsFactors=FALSE,sep="")



# Read training data

# Training set data
train_set <- read.table("train/x_train.txt", , header=F,sep="")
# list of (7352) training labels by activity 1-6
train_labels <- read.table("train/y_train.txt", header=F,sep="")
#list of subject number (n=9) for each feature
subject_train <- read.table("train/subject_train.txt", sep="")

# Read test data

# Test set data
test_set <- read.table("test/x_test.txt", sep="")
# Activity labels for test set
test_labels <- read.table("test/y_test.txt", sep="")
# List of subject number (n=21) for each feature
subject_test <- read.table("test/subject_test.txt", sep="")

# 1)Merge the training and the test sets to create one data set.

#Merge test subject ID (column 1), test labels (column 2), and  test data (columns 3-563) 
mergedTest <- cbind(subject_test, test_labels, test_set)
#Merge training subject ID (column 1), training labels (column 2) and  training data (columns 3-563)
mergedTrain <- cbind(subject_train, train_labels, train_set)
#Merge the training and test set together, appends rows of training data to test data
mergedAll <- rbind(mergedTest, mergedTrain)
#I also want to add column names to my mergedAll data set
#Column 1 is SubjectID
names(mergedAll)[1] <- "SubjectID"
#Column 2 is Activity
names(mergedAll)[2] <- "Activity"
#Columns 3:563 are assigned to the character string in column 2 of the features file
names(mergedAll)[3:563] <- features[,2]

# 2) Extract only the measurements on the mean and standard deviation for each measurement. 
#I chose to also keep the SubjectID and Activity labels to use later 
#I have excluded mean frequency measures (.meanFreq())

# Keep only those columns that have the pattern "mean()", "std()", "Subject" or "Activity" in them.  Remove all others
meanSD <- mergedAll[grep("mean\\(\\)|std\\(\\)|Subject|Activity",names(mergedAll),)]

# 3 Use descriptive activity names to name the 6 different activities in the data set. I am using the meanSD dataset for this

activityLabels <- read.table("activity_labels.txt",stringsAsFactors =FALSE, header=FALSE, sep="")
for (activity in 1:6){
  meanSD$Activity[meanSD$Activity == activity] <- activityLabels[activity,2]
}

# 4) Appropriately label the data set with descriptive activity names. I have chosen to remove the symbols "() and "-", as well as capitalize the first letter of each abbreviated word to keep readbility easy.

#Remove all parentheses() and hyphens (-)
a <- gsub("\\(\\)|-","",names(meanSD))  
# Capitalize the word mean
b <- gsub("mean","Mean", a)
#Capitalize the word std
c <- gsub("std","Std", b)
#Correct the variables with "BodyBody" to read just "Body"
d <- gsub("BodyBody", "Body", c)
#Apply the above changes to the meanSD data frame
names(meanSD) <- as.character(d) 

# 5) Create a second, independent tidy data set with the average of each variable for each activity and each subject. I am choosing to "melt" the data using the reshape 2 package
#Use the aggregate() function to calculate the mean of each variable per subject per activity
tidyData <- aggregate(x=meanSD[,3:68], by=list(SubjectID = meanSD$SubjectID, Activity = meanSD$Activity), FUN="mean")

# Write this tidy data to a tabe separated text file
write.table(tidyData, "tidyData.txt", row.names=FALSE, sep="\t")

