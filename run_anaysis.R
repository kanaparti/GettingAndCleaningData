### run_analysis.R
### Getting and Cleaning Data
 
# Read all data  into data tables
testData.labels <- read.table("test/y_test.txt", col.names="label") 
testData.subjects <- read.table("test/subject_test.txt", col.names="subject") 
testData.xtest <- read.table("test/X_test.txt") 

trainingData.labels <- read.table("train/y_train.txt", col.names="label") 
trainingData.subjects <- read.table("train/subject_train.txt", col.names="subject") 
trainingData.xtrain <- read.table("train/X_train.txt") 


 
# Combine the data  
	data <- rbind(cbind(testData.subjects, testData.labels, testData.xtest), cbind(trainingData.subjects, trainingData.labels, trainingData.xtrain)) 
 
# Read the features from the data
	features <- read.table("features.txt", strip.white=TRUE, stringsAsFactors=FALSE) 

#Only retain the features for Mean and Standard Deviation 
	features.mean.std <- features[grep("mean\\(\\)|std\\(\\)", features$V2), ] 


# Select only Means and Standard Deviations from data 
# increment by 2 as data has subjects and labels in the beginning 
	data.mean.std <- data[, c(1, 2, features.mean.std$V1+2)] 

# Read the Labels  
	labels <- read.table("activity_labels.txt", stringsAsFactors=FALSE) 

# Replace Labels in data with Label names 
	data.mean.std$label <- labels[data.mean.std$label, 2] 

 
# Make a list of the current column names and feature names 
	tidy.colnames <- c("subject", "label", features.mean.std$V2) 

# Tidy the list by removing every non-alphabetic character and converting to lowercase 
	tidy.colnames <- tolower(gsub("[^[:alpha:]]", "", tidy.colnames)) 

# then use the list as column names for data 
	colnames(data.mean.std) <- tidy.colnames 

# find the mean for each combination of subject and label 
	aggr.data <- aggregate(data.mean.std[, 3:ncol(data.mean.std)], by=list(subject = data.mean.std$subject, label = data.mean.std$label), mean) 

#Write the data to a file
write.table(format(aggr.data, scientific=T), "tidy2.txt", row.names=F, col.names=F, quote=2) 
