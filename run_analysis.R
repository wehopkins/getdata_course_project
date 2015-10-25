# Getting and Cleaning Data - course project
#
# run_analysis.R
#

library(compiler)
library(readr)
library(dplyr)
library(tidyr)
library(stringr)

enableJIT(3)

# define path components
data.dir <- "UCI HAR Dataset"
test.dir <- "test"
train.dir <- "train"

# define specific file paths

features.txt <- paste(data.dir,"features.txt",sep="/")
activity_labels.txt <- paste(data.dir,"activity_labels.txt",sep="/")

X_test.txt <- paste(data.dir,test.dir,"X_test.txt",sep="/")
y_test.txt <- paste(data.dir,test.dir,"y_test.txt",sep="/")
subject_test.txt <- paste(data.dir,test.dir,"subject_test.txt",sep="/")

X_train.txt <- paste(data.dir,train.dir,"X_train.txt",sep="/")
y_train.txt <- paste(data.dir,train.dir,"y_train.txt",sep="/")
subject_train.txt <- paste(data.dir,train.dir,"subject_train.txt",sep="/")


# read in column names (features) and designate which are of interest

col.names.df <- read_delim(features.txt,delim=" ",col_names=c("colnum","featurename"))
col.names.df <- col.names.df%>%
  # add column indicating which features to keep, and use that to drive the types string
  # used to read in the data ("d"-double, "_"-skip; see ?read_table from readr package)
  mutate(used_features=grepl("-mean\\(\\)|-std\\(\\)",featurename),
         col_types=ifelse(used_features,"d","_"),
         # modify names to make them acceptable R symbols
         fixed_featurename=str_replace_all(featurename,"-","_"),
         fixed_featurename=str_replace_all(fixed_featurename,"\\(\\)","")
  )

# reduce col_types from vector of single characters to a sequence of characters in a single
# string (for col_types parameter of read_table())
col_types_string <- paste(col.names.df$col_types,collapse="")

# obtain activity labels
activity_labels.df <- read_delim(activity_labels.txt,delim=" ",
                                 col_names=c("actnum","activity"))

# Function takes paths to feature file, activity file, and subject file (data), and
# the column names, column types string, and activity label data frame (metadata),
# reads in the files, combine them, and assign activity label
readAndAdjust <- function(x.file,y.file,subject.file,col.names,col.types.string,activity.labels) {
  # read selected columns and assign column names
  x.df <- read_table(x.file,
                     col_names=col.names,
                     col_types=col_types_string)
  
  y.df <- read_table(y.file,col_names="actnum")
  
  subject.df <- read_table(subject.file,col_names="subject")
  
  # add the subject data to the feature data
  both.df <- bind_cols(y.df,subject.df,x.df)
  
  # match the activity name to the activity number
  both.act.df <- left_join(both.df,activity.labels,by="actnum")
  
  # order the columns sensibly
  both.act.df%>%select(activity,subject,tBodyAcc_mean_X:fBodyBodyGyroJerkMag_std)
}

# read in the test data, filter, and combine altogether
test.df <- readAndAdjust(X_test.txt,y_test.txt,subject_test.txt,
                      col.names.df$fixed_featurename,
                      col_types_string,
                      activity_labels.df)

# read in the training data, filter, and combine altogether
train.df <- readAndAdjust(X_train.txt,y_train.txt,subject_train.txt,
                          col.names.df$fixed_featurename,
                          col_types_string,
                          activity_labels.df)

# combine the two data sets into one
all.df <- bind_rows(test.df,train.df)

# take a quick look at all the data - no missing values
summary(all.df)

# generate expressions to perform the mean on all of the selected features
# (see vignette in the dplyr package for Non-standard evaluation)
dots <- sapply(names(all.df)[-(1:2)],function(f) {
  as.formula(paste0("~mean(",f,")"))
})

# compute the means for all the selected feature values by activity
act.ave.df <- all.df%>%select(-subject)%>%group_by(activity)%>%
  summarise_(.dots=setNames(dots,names(all.df)[-(1:2)]))

##
## End of assigned activities
##

# save the computed mean values to disk so as to upload
write.table(act.ave.df,file="tidy.data.step5.txt",row.names=FALSE)


# ensure that the data read back in is tolerably close to what was written
back.in.df <- read.table("tidy.data.step5.txt",header=TRUE,stringsAsFactors=FALSE)
all.equal(as.data.frame(act.ave.df),back.in.df)
# [1] TRUE

