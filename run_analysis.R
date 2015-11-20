####################################### download zip file ######################################################
downloadFileUrl <- 'https://d396qusza40orc.cloudfront.net/getdata%2Fprojectfiles%2FUCI%20HAR%20Dataset.zip'
zipFilePath <- './data/samsung-dataset.zip'
extractDir <- './data/UCI HAR Dataset'

if(!file.exists(zipFilePath)) {
  cat('\nFile doesn\'t exist in \'data\' directory. Downloading now...')
  download.file(downloadFileUrl, destfile = zipFilePath, mode = 'wb')
}else {
  cat('\nFile already exists in \'data\' directory. No need to download again.')
}


####################################### extract zip file ######################################################
library(downloader)

if(!file.exists(extractDir)) {
  cat('\nExtracting zip file...')
  unzip(zipfile = targetFilePath, exdir = './data/')
}else{
  cat('\nContents of zip file are already extracted.')
}

####################################### read text files ######################################################

cat('\nReading training set...')
if(!exists('trainingSet')){
  trainingSet <- read.table(file.path(extractDir, '/train/x_train.txt'))
  trainingLabels <- read.table(file.path(extractDir, '/train/y_train.txt'))
  trainingSubject <- read.table(file.path(extractDir, '/train/subject_train.txt'))
}

cat('\nReading test set...')
if(!exists('testSet')){
  testSet <- read.table(file.path(extractDir, '/test/x_test.txt'))
  testLabels <- read.table(file.path(extractDir, '/test/y_test.txt'))
  testSubject <- read.table(file.path(extractDir, '/test/subject_test.txt'))
}

#############################################################################################
#Goal #1 Merges the training and the test sets to create one data set.
#############################################################################################

cat('\nMerging training and test sets...')
mergedSet <- rbind(trainingSet, testSet)
mergedLabels <- rbind(trainingLabels, testLabels)
mergedSubjects <- rbind(trainingSubject, testSubject)

#############################################################################################
#Goal #2 Extracts only the measurements on the mean and standard deviation for each measurement. 
#############################################################################################

cat('\n\nReading features list...')
featuresList <- read.table(file.path(extractDir, 'features.txt'))[,2]

cat('\nExtracting only the measurements on the mean and standard deviation for each measurement')
meanStdIndices <- grep('mean\\(\\)|std\\(\\)', featuresList)
mergedSet <- mergedSet[,meanStdIndices]

#############################################################################################
#Goal #3 Uses descriptive activity names to name the activities in the data set
#############################################################################################

cat('\n\nReading activity list...')
activityList <- read.table(file.path(extractDir, 'activity_labels.txt'))

cat('\nUsing descriptive activity names to name the activities in the dataset')
mergedLabels[,1] <- activityList[mergedLabels[,1],2]
names(mergedLabels) <- 'activity'

#############################################################################################
#Goal #4 Appropriately labels the data set with descriptive variable names. 
#############################################################################################
cat('\n\n Appropriately labeling the dataset with descriptive names')
names(mergedSubjects) <- 'subject'
names(mergedSet) <- featuresList[meanStdIndices]
names(mergedSet) <- gsub('\\(\\)','', names(mergedSet))


#############################################################################################
#Goal #5 From the data set in step 4, creates a second, independent tidy data set with the 
#         average of each variable for each activity and each subject.
#############################################################################################

tidySet <- cbind(mergedSubjects, mergedLabels, mergedSet)
cat('\n\nCalculating average for each variable for each activity and subject')

mean_result <- tidySet %>% group_by(subject, activity) %>% summarise_each(funs(mean))

cat('\nSaving data to \'run_analysis.txt\' file')
write.table(mean_result,"./run_analysis.txt",sep=" ",row.name=FALSE) 