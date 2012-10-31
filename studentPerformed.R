#set path here
dataPath <- "/Users/kgenin/ML-FinalProject2012-EdModeling/data/"

#load data
data1 <- read.csv(paste(dataPath, "original-data/data_students1-5.csv", sep=""))
data2 <- read.csv(paste(dataPath, "original-data/data_students6-9.csv", sep=""))

#make names consistent, append
#data2 <- data2[c(1:15, 17, 16, 18:42)]
names(data2)[names(data2)=="day"] <- "Day" 
alldata <- rbind(data1, data2)

#drop tutor-performed rows
studentPerformed <- alldata[alldata$Student.Response.Subtype != "tutor-performed", ]

#clean up
remove(data1, data2, alldata)

#drop uninteresting columns 
studentPerformed <- subset(studentPerformed, select = -c(1,2,8:12, 14, 16, 17, 19, 25, 29:31, 33:38, 41:42))

#write student-performed data
write.table(studentPerformed, paste(dataPath, "studentPerformed.csv", sep=""))








