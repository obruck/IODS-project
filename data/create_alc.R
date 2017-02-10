#Name: Oscar Brück
#Date: 09.02.2017
#Description: Data wrangling exercise (Exercise 3.1) on the UCI Machine Learning Repository, Student Alcohol consumption data https://archive.ics.uci.edu/ml/datasets/STUDENT+ALCOHOL+CONSUMPTION

#Read the data
setwd("/Users/obruck/Desktop/Open data course/IODS-project/data/")
mat <- read.csv("student-mat.csv", header = TRUE, sep = ";")
por <- read.csv("student-por.csv", header = TRUE, sep = ";")

#Explore the structure and dimensions of the data.
str(mat)
str(por)
dim(mat)
dim(por)

#Access the dplyr library
library("dplyr")

#Join the two data sets
##Common columns to use as identifiers
join_by <- c("school","sex","age","address","famsize","Pstatus","Medu","Fedu","Mjob","Fjob","reason","nursery","internet")
##Join the two datasets by the selected identifiers
mat_por <- inner_join(mat, por, by = join_by)
str(mat_por)
dim(mat_por)

#Combine the 'duplicated' answers in the joined data
##create a new data frame with only the joined columns
alc <- select(mat_por, one_of(join_by))
##the columns in the datasets which were not used for joining the data
notjoined_columns <- colnames(mat)[!colnames(mat) %in% join_by]
##print out the columns not used for joining
notjoined_columns
##for every column name not used for joining...
for(column_name in notjoined_columns) {
  ##select two columns from 'math_por' with the same original name
  two_columns <- select(mat_por, starts_with(column_name))
  ##select the first column vector of those two columns
  first_column <- select(two_columns, 1)[[1]]
  ##if that first column vector is numeric...
  if(is.numeric(first_column)) {
    ##take a rounded average of each row of the two columns and
    ##add the resulting vector to the alc data frame
    alc[column_name] <- round(rowMeans(two_columns))
  } else { # else if it's not numeric...
    ##add the first column vector to the alc data frame
    alc[column_name] <- first_column
  }
}

#Take the average of the answers related to weekday and weekend alcohol consumption
alc <- mutate(alc, alc_use = (Dalc + Walc) / 2)
#Create a new logical column which is TRUE for students for which 'alc_use' is greater than 2
alc <- mutate(alc, high_use = alc_use > 2)

#Glimpse at and save the joined and modified data.
glimpse(alc)
write.csv(alc, file = "alc.csv")