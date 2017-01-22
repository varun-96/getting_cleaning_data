library(dplyr)

test <- read.csv("test/X_test.txt", sep = "", header = FALSE)
sub_test <- read.csv("test/subject_test.txt", sep = "", header = FALSE)
y_test <- read.csv("test/y_test.txt", sep = "", header = FALSE)

merge_test <- data.frame(sub_test,y_test,test)


train <- read.csv("train/X_train.txt", sep = "", header = FALSE)
sub_train <- read.csv("train/subject_train.txt", sep = "", header = FALSE)
y_train <- read.csv("train/y_train.txt", sep = "", header = FALSE)

merge_train <- data.frame(sub_train, y_train,train)

#Final data after combining train and test dataset
merge_data <- rbind(merge_train,merge_test)

#to remove files from environment
remove(sub_test, sub_train,y_test, y_train, train, test, merge_test, merge_train)

features <- read.csv("features.txt", sep = "",header = FALSE)
col.name <- as.vector(features[,2])

colnames(merge_data) <- c("Subject_id","activity_labels",col.name)

#assigning merge_data to final
final <- merge_data

#delete the duplicate columns
final <- final %>% subset(., select= which(!duplicated(names(.))))

#select the required columns
final <- select(final, contains("subject"), contains("label"), contains("mean"),contains("std"), -contains("angle"), -contains("freq"))

activity_labels <- read.csv("activity_labels.txt", sep = "", header = FALSE)

final$activity_labels <- as.character(activity_labels[match(final$activity_labels, activity_labels$V1), 'V2'])

#Appropriately labels the data set with descriptive variable names.
colnames(final) <- gsub("\\(\\)", "", colnames(final))
colnames(final) <- gsub("-", "_", colnames(final))
colnames(final) <- gsub("BodyBody", "Body", colnames(final))

# Independent tidy data set with the average of each variable for each activity and each subject.
final.summary <- final %>% group_by(Subject_id, activity_labels) %>% summarise_each(funs(mean))


write.table(final.summary, file = "final_summary.txt", row.names = FALSE)