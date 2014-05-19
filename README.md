## Getting and Cleaning Data: Project Assignment
========================================================
### Pre-requisites to running the program:

The run-analysis.R script in this repo requires the user to first download and unzip the "Human Activity Recognition Using Smartphones Dataset" from UCI.  This dataset can be found at:

https://d396qusza40orc.cloudfront.net/getdata%2Fprojectfiles%2FUCI%20HAR%20Dataset.zip 

Make sure to set your R working directory to the folder that your files are unzipped into.

### About the data

A detailed description of the study design can be found in the README.txt file in the unzipped data.  Briefly, 30 subjects each performed a series of 6 activities (standing, sitting, laying down, walking, walking downstairs and upstiars) while wearing a Samsung Galaxy II smartphone.  The subject data was broken in to two groups, a training set of 21 subjects, and a test set of 9 subjects.  The resulting data fell into 561 different 'features' as outlined in the features.txt in the dataset and includes some mean and standard deviation calculations.

### About the script

The run_analysis.R script attempts to do the following:

*Merge the training and the test sets to create one data set.

*Extract only the measurements on the mean and standard deviation for each measurement.

*Use descriptive activity names to name the activities in the data set

*Appropriately label the data set with descriptive variable names. 

*Creates a second, independent tidy data set with the average of each variable for each activity and each subject. 

The script itself is fully annotated with comments, but a couple of things are worth noting:

The variables chosen that measure mean and standard deviation excludes measure of meanFreq.  This was done because the meanFreq variables had no corresponding measures of standard deviation.  I felt leaving these in would muddy the content of the data set.

The naming of the variables was altered from the original features.txt.  This was done to remove characters that may cause problems such as "-" and "()", as well as to make the variable names more readable by capitalizing the first letter of each abbreviation in the name.  So, for instance, the variable name tBodyAcc-mean()-X is changed to tBodyAccMeanX.  There were also a couple of variables that were incorrectly coded with the prefix f"BodyBody" instead of just "Body".  These are also corrected in the script.

More details about the data, variables and transformations used can be found in the CodeBook.md in this repo.





