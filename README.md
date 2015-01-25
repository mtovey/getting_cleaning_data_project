
The run_analysis.R file is the primary script in this repo. This assumes the data files of the project are in a subdirectory of the working directory named "UCI HAR Dataset" and that the files in the subdirectory are unchanged from the zip file provided with the project.

Also assumed is that the dplyr and plyr packages are available on the machine executing the script. If they are not currently available, they can be obtained by typing: install.packages("dplyr") and install.packages("plyr")

When the script is run by typing in source("run_analysis.R"), it will read the appropriate data files for both the test and train data sets, then produce a data file named "tidied_data.txt" as described in the project requirements. A data frame variable called "tidy_data" will also be available which holds the summarized data by activity and subject.