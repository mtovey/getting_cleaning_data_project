suppressPackageStartupMessages(library(dplyr))
suppressPackageStartupMessages(library(plyr))

# Retrieve the measurement variable names from the features file, tidy them up for readability
m_names <- read.table("./UCI HAR Dataset/features.txt",colClasses=c("integer","character"),col.names=c("ix","feature"))
m_names <- mutate(m_names,feature = gsub('[\\(\\)]','',feature))
m_names <- mutate(m_names,feature = gsub('-','_',feature))

parseFileData <- function(type) {
  # Function to read in the necessary data files from the data directory, based on the type parameter (test or train)
  # First, read in the subject ids from the subject file into an initial data frame
  subjects <- read.table(paste("./UCI HAR Dataset/",type,"/subject_",type,".txt",sep=""),col.names="subject")
  # Then, read in the corresponding activity ids, converting them into a readable factor
  subjects$activity <- factor(readLines(paste("./UCI HAR Dataset/",type,"/y_",type,".txt",sep="")))
  levels(subjects$activity) <- c("Walking","Walking Upstairs","Walking Downstairs","Sitting","Standing","Laying")
  # Adding a basic sequence column to allow joining the actual measurement data below
  subjects$sequence <- c(1:nrow(subjects))

  # Now, read in the actual measurements for the subjects, using the variable names from features
  measurements <- read.table(file=paste("./UCI HAR Dataset/",type,"/X_",type,".txt",sep=""),col.names=m_names[,2])
  # Select the mean and std columns that we're interested in and add the common sequence column
  measurements <- select(measurements, c(1:6,41:46,81:86,121:126,161:166,201:202,214:215,227:228,240:241,253:254,266:271,345:350,424:429,503:504,516:517,529:530,542:543))
  measurements$sequence <- c(1:nrow(subjects))

  # Finally, join the subject and measurement frames together and return the final frame, removing the sequence column
  combined_frame <- join(subjects, measurements)
  combined_frame <- select(combined_frame, -(sequence))
  combined_frame
}

# Use our helper function to get the individual test and train data sets
test_data <- parseFileData("test")
train_data <- parseFileData("train")

# Combine them together to get one large data set
combined_data <- rbind(test_data,train_data)

# Use dplyr to get the means of all our mean and std columns, grouped by activity and subject
tidy_data <- ddply(combined_data, .(activity, subject), numcolwise(mean))

# Finally, write the summarized data to an output file, tidied_data.txt
write.table(tidy_data, "./tidied_data.txt", row.names=FALSE)
