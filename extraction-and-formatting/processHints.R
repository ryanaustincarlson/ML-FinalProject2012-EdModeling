require(plyr)

#set path here
dataPath <- "/Users/kgenin/ML-FinalProject2012-EdModeling/data/"

#load data
d <- read.csv(paste(dataPath, "studentPerformed.csv", sep=""))

#create HINT flag
d$hint<-0
d$hint[d$Student.Response.Type == "HINT_REQUEST"] <- 1

summary(d$Student.Response.Type)
nrow(d[ which(d$hint==1),])
nrow(d[ which(d$hint==0),])

#hints requested by student for each problem
x<-ddply(d, .(Anon.Student.Id,Problem.Name), summarise, hints_req=sum(hint))

#nrow(d[which(d$Anon.Student.Id=="Stu_fb73356c923072b0b3a3bae4d71a327a" & d$Problem.Name==28&d$Student.Response.Type=="HINT_REQUEST"),])