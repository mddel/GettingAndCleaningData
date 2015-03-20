
# Read data ---------------------------------------------------------------

writeLines("reading activity labels")
activityLabels  <- read.table("UCI HAR Dataset/activity_labels.txt")

writeLines("reading features")
features        <- read.table("UCI HAR Dataset/features.txt")

writeLines("reading test data")
subjectTest <- read.table("UCI HAR Dataset/test/subject_test.txt")
xTest       <- read.table("UCI HAR Dataset/test/X_test.txt")
yTest       <- read.table("UCI HAR Dataset/test/y_test.txt")

writeLines("reading training data")
subjectTrain<- read.table("UCI HAR Dataset/train/subject_train.txt")
xTrain      <- read.table("UCI HAR Dataset/train/X_train.txt")
yTrain      <- read.table("UCI HAR Dataset/train/y_train.txt")


# Combine data ------------------------------------------------------------

writeLines("combining data")
testData    <- cbind(xTest, yTest, subjectTest)
trainData   <- cbind(xTrain, yTrain, subjectTrain)
allData     <-rbind(testData, trainData)

remove(xTest)
remove(yTest)
remove(subjectTest)
remove(testData)
remove(xTrain)
remove(yTrain)
remove(subjectTrain)
remove(trainData)


# Clean data --------------------------------------------------------------

writeLines("setting proper column names")
columnNames <- as.character(features[,2])
columnNames <- gsub("[(][)]","",columnNames)
columnNames <- gsub("-", ".", columnNames)
colnames(allData) <- c(columnNames, "activity", "subject")
remove(columnNames)
remove(features)

writeLines("setting proper activities")
allData$activity <- sapply(allData$activity, 
                           function(x) 
                               {as.factor(tolower(activityLabels[x,2]))}
                           )
remove(activityLabels)


# Subset data ---------------------------------------------------------

writeLines("subsetting data: keeping only mean, std, activity and subject")
desiredColumns <- grep("mean[.]|mean$|std[.]|std$|^activity$|^subject$", 
                       colnames(allData))
subsetData <- allData[,desiredColumns]
remove(desiredColumns)
remove(allData)


# Create summary data -----------------------------------------------------

writeLines("Creating summary dataset with the average of each activity and each subject")
library(reshape2)
dataMelt <- melt(subsetData, id = c("subject", "activity"))
summaryData <- dcast(dataMelt, subject + activity ~ variable, mean)
remove(dataMelt)

write.table(summaryData,"tidySummary.txt",row.name=FALSE)
