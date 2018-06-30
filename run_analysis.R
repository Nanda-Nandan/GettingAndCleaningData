
library(dplyr)

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

