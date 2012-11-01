require(plyr)

#set path here
dataPath <- "/Users/kgenin/ML-FinalProject2012-EdModeling/data/"

#format time
#d$Time<-strptime(paste(d$Day,d$Time, sep=" "), "%m/%d/%y %H:%M:%S")

#load data
d <- read.csv(paste(dataPath, "studentPerformed.csv", sep=""))
d <- d[order(d$Anon.Student.Id, d$Problem.Name, d$Time) , ]

#minutes spent per problem
minSpent<-ddply(d, .(Anon.Student.Id,Problem.Name,Day,Condition), timeSpent) 
names(minSpent)[names(minSpent)=="V1"] <- "minSpent" 

#create HINT flag
d$hint<-0
d$hint[d$Student.Response.Type == "HINT_REQUEST"] <- 1
#summary(d$Student.Response.Type)
#nrow(d[ which(d$hint==1),])
#nrow(d[ which(d$hint==0),])

#flag InCorrect Answers
d$error<-0
d$error[d$Outcome == "InCorrect"] <- 1 

#number of hints per student/problem
#number of errors per student/problem
x<-ddply(d, .(Anon.Student.Id,Problem.Name,Day,Condition), summarise, hints_req=sum(hint), num_errors=sum(error)) 

problems <- merge(x,minSpent, by=c("Anon.Student.Id","Problem.Name","Day","Condition"))

#Attempt to identify conceptual questions
#grep("[a-z]",d[1:100,"Input"], value=TRUE)

#nrow(d[which(d$Anon.Student.Id=="Stu_fb73356c923072b0b3a3bae4d71a327a" & d$Problem.Name==28&d$Student.Response.Type=="HINT_REQUEST"),])

timeSpent <- function(df) {
	difftime(df[nrow(df),"Time"],df[1,"Time"], units="mins")
}


432596 2010-05-19 16:53:32           28 05/19/10
432597 2010-05-19 16:53:37           28 05/19/10
432598 2010-05-19 16:53:39           28 05/19/10
432599 2010-05-19 16:53:57           28 05/19/10
432600 2010-05-19 16:54:00           28 05/19/10
432601 2010-05-19 16:54:01           28 05/19/10
432602 2010-05-19 16:54:01           28 05/19/10
432603 2010-05-19 16:54:07           28 05/19/10
432604 2010-05-19 16:54:16           28 05/19/10
432605 2010-05-19 16:54:17           28 05/19/10
432606 2010-05-19 16:54:31           28 05/19/10
432607 2010-05-19 16:54:37           28 05/19/10
432608 2010-05-19 16:54:38           28 05/19/10
432609 2010-05-19 16:54:42           28 05/19/10
432610 2010-05-19 16:54:50           28 05/19/10
432611 2010-05-19 16:55:06           28 05/19/10
