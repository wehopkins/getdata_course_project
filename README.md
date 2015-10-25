# getdata_course_project

Course Project for Getting and Cleaning Data from Coursera Data Science sequence. 

Much of the content for this was adopted from the README.txt file from the UCI HAR Dataset package.
For more information, see [Human Activity Recognition Using Smartphones Data Set](http://archive.ics.uci.edu/ml/datasets/Human+Activity+Recognition+Using+Smartphones)

### Contents of this directory

File Name | Description
--------- | -----------
README.md | (this file) provides overview of the contents of the directory
features_info.md | adaptation of the original features_info.txt file to pertain to the contents of the data frames created as part of this project
codebook.md | specification of all the variables (i.e., columns) of the target data frame
run_analysis.R | the R script that creates the assigned data frames given the UCI HAR Data Set


### Running the run_analysis.R script
* Ensure that the top directory of the source dataset zip file, "UCI HAR Dataset" is in the working directory (getwd() or title bar for the RStudio Console window).
* Source run_analysis.R in your current R console (source("run_analysis.R"), or be viewing in
RStudio and press the "Source" button).

When you run the script, you will see:

* Messages from the byte compiler (e.g., "Note: no visible binding..."); those are not errors
* The output of summary(all.df) and the results of an object comparison sent to the console (depending
on the parameters passed to source()).

When the script is done, you will see:

* the complete data frame object as requested in step 1, named, "all.df", in the console environment
* two data frames, "test.df" and "train.df", containing the test and train subsets of the data,
respectively
* one data frame, named "act.ave.df", containing the tidy data set from step 5
* one file, "tidy.data.step5.txt", created in the working directory (the file created as part of step 5
and sent in via the course web interface).

### Notes on the code
The implementation relied heavily on the dplyr, tidyr, readr, and stringr packages, all written (mostly) by Hadley Wickham and are available from CRAN. dplyr and tidyr were mentioned in the lectures and are covered in the swirl lessons.

### Notes regarding the data

* Features are normalized and bounded within [-1,1].
* Each feature vector is a row on the data frame.

### License

Use of this dataset in publications must be acknowledged by referencing the following publication [1] 

[1] Davide Anguita, Alessandro Ghio, Luca Oneto, Xavier Parra and Jorge L. Reyes-Ortiz. Human Activity Recognition on Smartphones using a Multiclass Hardware-Friendly Support Vector Machine. International Workshop of Ambient Assisted Living (IWAAL 2012). Vitoria-Gasteiz, Spain. Dec 2012

This dataset is distributed AS-IS and no responsibility implied or explicit can be addressed to the authors or their institutions for its use or misuse. Any commercial use is prohibited.

Jorge L. Reyes-Ortiz, Alessandro Ghio, Luca Oneto, Davide Anguita. November 2012.
