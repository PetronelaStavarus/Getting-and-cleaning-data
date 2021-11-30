getwd()
setwd("C:/Users/tibi/Documents")
data=download.file("https://d396qusza40orc.cloudfront.net/getdata%2Fprojectfiles%2FUCI%20HAR%20Dataset.zip",destfile = "./quiz1/Dataset", mode="wb")
data4=unzip(zipfile="quiz1/Dataset")
head(data4)
list(data4)
library(dplyr)

# Read in the X, Y,subject test dataset
xtest <- read.csv("UCI HAR Dataset/test/X_test.txt", sep="",
                   header=FALSE)
ytest <- read.csv("UCI HAR Dataset/test/y_test.txt", sep="",
                   header=FALSE)
subjecttest <- read.csv("UCI HAR Dataset/test/subject_test.txt",
                         sep="", header=FALSE)

# Merge the test datasets into a single dataframe
test <- data.frame(subjecttest, ytest, xtest)
head(test)

# Read in the X, Y,subject train dataset
xtrain <- read.csv("UCI HAR Dataset/train/X_train.txt", sep="",
                    header=FALSE)
ytrain <- read.csv("UCI HAR Dataset/train/y_train.txt", sep="",
                    header=FALSE)
subjecttrain <- read.csv("UCI HAR Dataset/train/subject_train.txt",
                          sep="", header=FALSE)

# Merge test training datasets 
train <- data.frame(subjecttrain, ytrain, xtrain)

head(train)

# Combine the training and test datasets
mydata <- rbind(train, test)
head(mydata)


# Read in the measurement labels dataset
features <- read.csv("UCI HAR Dataset/features.txt", sep="", header=FALSE)

features_id=as.vector(features[,2])

# Apply the measurement labels as column names to the combined
# running dataset
colnames(mydata) <- c("subject_id", "activity_labels", features_id)
head(mydata)


# Select only the columns that contain mean or standard deviations.

mydata3=select(mydata,contains("subject"), contains("label"),
               contains("mean"), contains("std"))
head(mydata3)

# Read in the activity labels dataset
activity.labels <- read.csv("UCI HAR Dataset/activity_labels.txt", 
                            sep="", header=FALSE)

mydata3$activity_labels <- as.character(activity.labels[
        match(mydata$activity_labels, activity.labels$V1), 'V2'])

# Clean up the data

gsub("\\(\\)", "", colnames(mydata3))
gsub("-", "_", colnames(mydata2))
gsub("BodyBody", "Body", colnames(mydata2))


# Calculte the mean
mydata3.summary <- mydata3 %>%
        group_by(subject_id, activity_labels) %>%
        summarise_each(funs(mean))

# Write run.data to file
write.table(mydata3.summary, file="mydata3.summary.txt", row.name=FALSE)
