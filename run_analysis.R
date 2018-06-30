
library(reshape2)
# download zip file containing data if it hasn't already been downloaded
fileUrl <- "https://d396qusza40orc.cloudfront.net/getdata%2Fprojectfiles%2FUCI%20HAR%20Dataset.zip"
fileName <- "getdata_projectfiles_UCI HAR Dataset.zip"

if (!file.exists(fileName)) {
  download.file(fileUrl, fileName, mode = "wb")
}

# unzip zip file containing data if data directory doesn't already exist
filePath <- "UCI HAR Dataset"
if (!file.exists(filePath)) {
  unzip(fileName)
}

# Extract activity labels and features
activityLabels <- read.table("UCI HAR Dataset/activity_labels.txt")
activityLabels[,2] <- as.character(activityLabels[,2])
features <- read.table("UCI HAR Dataset/features.txt")
features[,2] <- as.character(features[,2])

# Extract only the data on mean and standard deviation
featuresToUse <- grep(".*mean.*|.*std.*", features[,2])
featuresToUse.names <- features[featuresToUse,2]
featuresToUse.names = gsub('-mean', 'Mean', featuresToUse.names)
featuresToUse.names = gsub('-std', 'Std', featuresToUse.names)
featuresToUse.names <- gsub('[-()]', '', featuresToUse.names)

# Load the datasets
trainFeatures <- read.table("UCI HAR Dataset/train/X_train.txt")[featuresToUse]
trainLabels <- read.table("UCI HAR Dataset/train/Y_train.txt")
trainSubjects <- read.table("UCI HAR Dataset/train/subject_train.txt")
trainingData <- cbind(trainSubjects, trainLabels, trainFeatures)

testFeatures <- read.table("UCI HAR Dataset/test/X_test.txt")[featuresToUse]
testLabels <- read.table("UCI HAR Dataset/test/Y_test.txt")
testSubjects <- read.table("UCI HAR Dataset/test/subject_test.txt")
testData <- cbind(testSubjects, testLabels, testFeatures)


# merge datasets and add labels
totalData <- rbind(trainingData, testData)
colnames(totalData) <- c("Subject", "Activity", featuresToUse.names)

# turn activities & subjects into factors
totalData$Activity <- factor(totalData$Activity, levels = activityLabels[,1], labels = activityLabels[,2])
totalData$Subject <- as.factor(totalData$Subject)

totalData.melted <- melt(totalData, id = c("Subject", "Activity"))
totalData.mean <- dcast(totalData.melted, Subject + Activity ~ variable, mean)

write.table(totalData.mean, "tidy.txt", row.names = FALSE, quote = FALSE)