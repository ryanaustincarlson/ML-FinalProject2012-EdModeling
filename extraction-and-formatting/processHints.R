require(plyr)

#set path here
dataPath <- "/Users/kgenin/ML-FinalProject2012-EdModeling/data/"

#load data
d <- read.csv(paste(dataPath, "studentPerformed.csv", sep=""))

#create HINT flag
d$hint<-0
d$hint[d$Student.Response.Type == "HINT_REQUEST"] <- 1
#summary(d$Student.Response.Type)
#nrow(d[ which(d$hint==1),])
#nrow(d[ which(d$hint==0),])

#flag InCorrect Answers
d$errror<-0
d$error[d$Outcome == "InCorrect"] <- 1 

#number of hints per student/problem
#number of errors per student/problem
x<-ddply(d, .(Anon.Student.Id,Problem.Name), summarise, hints_req=sum(hint), num_errors=sum(error)) 

#grep("[a-z]",d[1:100,"Input"], value=TRUE)

#nrow(d[which(d$Anon.Student.Id=="Stu_fb73356c923072b0b3a3bae4d71a327a" & d$Problem.Name==28&d$Student.Response.Type=="HINT_REQUEST"),])