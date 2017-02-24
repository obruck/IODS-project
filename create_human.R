#title: "Data wrangling exercise (Exercise 5.1)"
#author: "Oscar Brück"
#date: "24.02.2017"

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
colnames(hd)[4] <- "Life.Exp"
colnames(hd)[5] <- "Edu.Exp"
colnames(hd)[6] <- "Education_mean"
colnames(hd)[7] <- "GNI"
colnames(hd)[8] <- "GNI-HDI"
colnames(gii)[3] <- "GII"
colnames(gii)[4] <- "Mat.Mor"
colnames(gii)[5] <- "Ado.Birth"
colnames(gii)[6] <- "Parli.F"
colnames(gii)[7] <- "Edu2.F"
colnames(gii)[8] <- "Edu2.M"
colnames(gii)[9] <- "Labo.F"
colnames(gii)[10] <- "Labo.M"
str(hd)
str(gii)

#Mutate the “Gender inequality” data
library(dplyr)
gii <- mutate(gii, Edu2.FM = Edu2.F/Edu2.M)
gii <- mutate(gii, Labo.FM = Labo.F/Labo.M)
str(gii)

#Join together the two datasets using the variable Country as the identifier
join_by <- c("Country")
human <- inner_join(hd, gii, by = join_by)
glimpse(human)
setwd("/Users/obruck/Desktop/Open data course/IODS-project/data/")
write.csv(human, file = "human.csv")


#Mutate GNI to numeric using string manipulation
human <- read.csv("human.csv")
library(stringr)
human <- mutate(human, GNI_num=str_replace(human$GNI, pattern=",", replace ="") %>% as.numeric())

#Exclude unneeded variables
keep <- c("Country", "Edu2.FM", "Labo.FM", "Edu.Exp", "Life.Exp", "GNI", "Mat.Mor", "Ado.Birth", "Parli.F")
human <- select(human, one_of(keep))

#Remove all rows with missing values
##Print out the data along with a completeness indicator as the last column
complete.cases(human)
data.frame(human[-1], comp = complete.cases(human))
#Filter out all rows with NA values
human_ <- filter(human, complete.cases(human))

#Remove the observations which relate to regions instead of countries
#Look at the last 10 observations of human
tail(human_,10)
#Define the last indice we want to keep e.g. the countries
last <- nrow(human_) - 7
#Choose everything until the last 7 observations
human_ <- human_[1:last, ]

#Add countries as rownames and remove the column "Country"
rownames(human_) <- human_$Country
human_ <- select(human_, -Country)
dim(human_)
str(human_)
write.csv(human_, file = "human2.csv")