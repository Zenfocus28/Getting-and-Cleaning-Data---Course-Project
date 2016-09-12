######
#Download files 
######


fileUrl <- "https://d396qusza40orc.cloudfront.net/getdata%2Fprojectfiles%2FUCI%20HAR%20Dataset.zip"
df <- file.path(getwd(), "Dataset.zip")  
download.file(fileUrl,df)
unzip(zipfile = "C:/Users/odyai/Desktop/Data Science/getting and cleaning data/Dataset.zip", exdir="C:/Users/odyai/Desktop/Data Science/getting and cleaning data")


#######
#Create a vector variable which lists text documents. 
#######

dirData <- file.path("C:/Users/odyai/Desktop/Data Science/getting and cleaning data","UCI HAR Dataset")
files<- list.files(dirData,recursive=TRUE)
files


########
# read in data from files
########

activity_test <- read.table(file.path(dirData, "test","Y_test.txt"), header = FALSE)
activity_train <- read.table(file.path(dirData,"train","Y_train.txt"), header = FALSE)

subject_test  <- read.table(file.path(dirData, "test" , "subject_test.txt"), header = FALSE)
subject_train <- read.table(file.path(dirData, "train", "subject_train.txt"), header = FALSE)

features_test  <- read.table(file.path(dirData, "test" , "X_test.txt" ), header = FALSE)
features_train <- read.table(file.path(dirData, "train", "X_train.txt"), header = FALSE)


activityType <- read.table(file.path(dirData, "activity_labels.txt"),header=FALSE) 

######
# MERGE train and test datasets with rbind()
######

activity_data <- rbind(activity_train, activity_test)
subject_data <- rbind(subject_train, subject_test)
features_data <- rbind(features_train, features_test)


#######
# APPLY NAMES TO VARIABLES IN MERGED-DATASETS
#######

names(activity_data) <- c("activity")
names(subject_data) <- c("subject")
features_names <- read.table(file.path(dirData, "features.txt"),head=FALSE) 
names(features_data) <- features_names$V2


######
# MERGE train and test datasets with cbind()
######

sub_act <- cbind(subject_data, activity_data)
final_data_set <- cbind(features_data, sub_act)


#######
# EXTRACT mean and standard deviation on each measurement
#######

data_mean_std <- features_names$V2[grep("mean\\(\\)|std\\(\\)",features_names$V2)]

selectedNames <- c(as.character(data_mean_std), "activity", "subject" )
final_data_set <- subset(final_data_set, select=selectedNames)


#######
# Substitute descriptive variable names for clearer analysis and understanding
#######

names(final_data_set) <- gsub("^t", "Time", names(final_data_set))
names(final_data_set) <- gsub("^f", "Frequency", names(final_data_set))
names(final_data_set) <- gsub("Acc", "Accelerometer", names(final_data_set))
names(final_data_set) <- gsub("BodyBody", "Body", names(final_data_set))
names(final_data_set) <- gsub("Mag", "Magnitude", names(final_data_set))
names(final_data_set) <- gsub("Gyro", "Gyroscope", names(final_data_set))
names(final_data_set)<-gsub("tBody", "TimeBody", names(final_data_set))
names(final_data_set)<-gsub("-mean()", "Mean", names(final_data_set))
names(final_data_set)<-gsub("-std()", "STD", names(final_data_set))


head(features_names)
tail(features_names)
str(final_data_set)      # validate mean and std were taken
dim(final_data_set)


#######
# creates a secon, independent tidy data set with the average of each variable for each activity and each subject.
#######

library(plyr)
final_data_set_2 <- aggregate(. ~subject + activity, final_data_set, mean)
final_data_set_2 <- final_data_set_2[order(final_data_set_2$subject,final_data_set_2$activity),]

write.table(final_data_set_2, file = "tidy_data.txt",row.name=FALSE)






















