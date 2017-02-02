#Name: Oscar Brück
#Date: 02.02.2017
#Description: Data wrangling exercise (Exercise 2.1)

setwd("/Users/obruck/Desktop/Open data course/IODS-project/data/")
learning2014 <- read.table("JYTOPKYS3-data.txt", header=TRUE)
#Check the structure of the data
str(learning2014)
#Check the dimension of the data
dim(learning2014)
#There are 183 observations and 60 variables

#Create an analysis dataset with the variables gender, age, attitude,
#deep, stra, surf and points by combining questions in the learning2014
#data, as defined in the datacamp exercises and also on the bottom part
#of the following page
#Load the dply package
library("dplyr")
#Combine variables according to the webpage
#http://www.helsinki.fi/~kvehkala/JYTmooc/JYTOPKYS2-meta.txt
d_sm <- c("D03", "D11", "D19", "D27")
d_ri <- c("D07", "D14", "D22", "D30")
d_ue <- c("D06", "D15", "D23", "D31")
deep_data <- c(d_sm, d_ri, d_ue)
su_lp <- c("SU02", "SU10", "SU18", "SU26")
su_um <- c("SU05", "SU13", "SU21", "SU29")
su_sb <- c("SU08", "SU16", "SU24", "SU32")
surf_data <- c(su_lp, su_um, su_sb)
st_os <- c("ST01", "ST09", "ST17", "ST25")
st_tm <- c("ST04", "ST12", "ST20", "ST28")
stra_data <- c(st_os, st_tm)
#Create the variables to the learning2014 dataset using the
#select and rowSums functions
deep_data_learning2014 <- select(learning2014, one_of(deep_data))
surf_data_learning2014 <- select(learning2014, one_of(surf_data))
stra_data_learning2014 <- select(learning2014, one_of(stra_data))
learning2014$Deep <- rowSums(deep_data_learning2014)
learning2014$Surf <- rowSums(surf_data_learning2014)
learning2014$Stra <- rowSums(stra_data_learning2014)
#Create a separate dataset and exclude observations where the
#exam points variable is zero
dataset <- c("gender", "Age", "Attitude", "Deep", "Stra", "Surf", "Points")
separate_data  <- select(learning2014, one_of(dataset))
separate_data_zeros_excluded <- filter(separate_data, Points != 0)
dim(separate_data_zeros_excluded)
#There are 166 observations and 7 variables

#Save the dataset
setwd("/Users/obruck/Desktop/Open data course/IODS-project/data/")
write.csv(separate_data_zeros_excluded, file = "learning2014.csv")
#Test that the dataset is working by reading it again
duplicate_of_separate_data_zeros_excluded <- read.csv("learning2014.csv", header = TRUE)
#Check the structure and first values of each variables of the dataset
str(duplicate_of_separate_data_zeros_excluded)
head(duplicate_of_separate_data_zeros_excluded)