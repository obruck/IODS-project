#Load the data
hd <- read.csv("http://s3.amazonaws.com/assets.datacamp.com/production/course_2218/datasets/human_development.csv", stringsAsFactors = F)
gii <- read.csv("http://s3.amazonaws.com/assets.datacamp.com/production/course_2218/datasets/gender_inequality.csv", stringsAsFactors = F, na.strings = "..")

#Explore the data
str(hd)
str(gii)
dim(hd)
dim(gii)
summary(hd)
summary(gii)

#Rename columns
colnames(hd)[3] <- "HDI"
colnames(hd)[4] <- "Life_Expectancy"
colnames(hd)[5] <- "Expected_education"
colnames(hd)[6] <- "Education_mean"
colnames(hd)[7] <- "GNI"
colnames(hd)[8] <- "GNI-HDI"
colnames(gii)[3] <- "GII"
colnames(gii)[4] <- "Maternal_mortality"
colnames(gii)[5] <- "Adolescent_birthrate"
colnames(gii)[6] <- "Representation_parliament"
colnames(gii)[7] <- "edu2F"
colnames(gii)[8] <- "edu2M"
colnames(gii)[9] <- "labfp_F"
colnames(gii)[10] <- "labfp_M"
str(hd)
str(gii)

#Mutate the “Gender inequality” data
library(dplyr)
gii <- mutate(gii, edu2FM = edu2F / edu2M)
gii <- mutate(gii, labfpFM = labfp_F/labfp_M)
str(gii)

#Join together the two datasets using the variable Country as the identifier
join_by <- c("Country")
human <- inner_join(hd, gii, by = join_by)
glimpse(human)
setwd("/Users/obruck/Desktop/Open data course/IODS-project/data/")
write.csv(human, file = "human.csv")