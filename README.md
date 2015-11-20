# Getting-and-Cleaning-Data-Assignment2 
# Getting and Cleaning Data Project

## run_analysis.R

The cleanup script (run_analysis.R) downloads zip file from web, extracts contents and then, does the following:

1. Merges the training and the test sets to create one data set.
2. Extracts only the measurements on the mean and standard deviation for each measurement. 
3. Uses descriptive activity names to name the activities in the data set
4. Appropriately labels the data set with descriptive activity names. 
5. Creates a second, independent tidy data set with the average of each variable for each activity and each subject. 

## Running the script

To run the script, type source(`run_analysis.R`). After running, you will see the following output as the script works:

`> source('run_analysis.r')

File already exists in 'data' directory. No need to download again.
Contents of zip file are already extracted.
Reading training set...
Reading test set...
Merging training and test sets...

Reading features list...
Extracting only the measurements on the mean and standard deviation for each measurement

Reading activity list...
Using descriptive activity names to name the activities in the dataset

 Appropriately labeling the dataset with descriptive names

Calculating average for each variable for each activity and subject
Saving data to 'run_analysis.txt' file
> 

## Process

1. For both the test and train datasets, produce an interim dataset:
    1. Extract the mean and standard deviation features (listed in CodeBook.md, section 'Extracted Features'). This is the `values` table.
    2. Get the list of activities.
    3. Put the activity *labels* (not numbers) into the `values` table.
    4. Get the list of subjects.
    5. Put the subject IDs into the `values` table.
2. Join the test and train interim datasets.
3. Put each variable on its own row.
4. Rejoin the entire table, keying on subject/acitivity pairs, applying the mean function to each vector of values in each subject/activity pair. This is the clean dataset.
5. Write the clean dataset to disk.

## Cleaned Data

The resulting clean dataset is in this repository at: `run_analysis.txt`. It contains one row for each subject/activity pair and columns for subject, activity, and each feature that was a mean or standard deviation from the original dataset.

## Notes

X_* - feature values (one row of 561 features for a single activity)
Y_* - activity identifiers (for each row in X_*)
subject_* - subject identifiers for rows in X_*