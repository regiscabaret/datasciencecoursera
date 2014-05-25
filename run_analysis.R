#file.url <- "https://d396qusza40orc.cloudfront.net/getdata%2Fprojectfiles%2FUCI%20HAR%20Dataset.zip"
#if (file.exists("har.zip")) file.remove("har.zip")
#download.file(file.url,destfile="har.zip",method='curl')
#unzip("har.zip")
# Reading x data sets and binding them, then cleaning intermediate sets for memory optimization
x.train <- read.table("UCI HAR Dataset/train/X_train.txt")
x.test <- read.table("UCI HAR Dataset/test/X_test.txt")
x.har.dataset <- rbind(x.train,x.test)
rm(x.train,x.test)
# Reading y data sets and binding them, then cleaning intermediate sets for memory optimization
y.train <- read.table("UCI HAR Dataset/train/Y_train.txt")
y.test <- read.table("UCI HAR Dataset/test/Y_test.txt")
y.har.dataset <- rbind(y.train,y.test)
rm(y.train,y.test)
# Reading subject data sets and binding them, then cleaning intermediate sets for memory optimization
subject.train <- read.table("UCI HAR Dataset/train/subject_train.txt")
subject.test <- read.table("UCI HAR Dataset/test/subject_test.txt")
subject.har.dataset <- rbind(subject.train,subject.test)
rm(subject.train,subject.test)
# Convert activity field to factor type and replace codes with labels found in activity_labels.txt
y.labels <- as.vector(read.table("UCI HAR Dataset/activity_labels.txt"))
y.har.dataset[,1] <- as.factor(y.har.dataset[,1])
levels(y.har.dataset[,1]) <- y.labels[,2]
# Convert subject field to factor
subject.har.dataset[,1] <- as.factor(subject.har.dataset[,1])
# Add a proper field name for activity and subject
features <- as.vector(read.table("UCI HAR Dataset/features.txt")$V2)
colnames(x.har.dataset) <- features
colnames(y.har.dataset) <- c("activity")
colnames(subject.har.dataset) <- c("subject")
# Keep only measurements at the mean or standard deviation
x.har.dataset <- x.har.dataset[,grep("mean()|std()",features)]
# Merging subject ids, activity ids, measurements
har.dataset <- cbind(subject.har.dataset,y.har.dataset,x.har.dataset)
# Removing unnecessary data frames to release memory
rm(subject.har.dataset,y.har.dataset,x.har.dataset)
# Summarize by subject and activity in an independant dataset
har.summary.dataset <- aggregate(har.dataset[,3:ncol(har.dataset)],by=list(har.dataset$subject,har.dataset$activity),mean,na.rm=TRUE)
# Export tidy data set to file
if (file.exists("har_dataset_tidy.txt")) file.remove("har_dataset_tidy.txt")
write.table(har.dataset,file="har_dataset_tidy.txt",sep="\t",row.names=FALSE)