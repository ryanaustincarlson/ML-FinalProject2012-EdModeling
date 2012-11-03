require(plyr)

#set path here
dataPath <- "data/"

#load, sort data
d <- read.csv(paste(dataPath, "studentPerformed.csv", sep=""))
d <- d[order(d$Anon.Student.Id, d$Problem.Name, d$Time) , ]

#minutes spent per problem
timeSpent <- function(df) {
  difftime(df[nrow(df),"Time"],df[1,"Time"], units="mins")
}

minSpent<-ddply(d, .(Anon.Student.Id,Problem.Name,Day,Condition), timeSpent) 
names(minSpent)[names(minSpent)=="V1"] <- "minSpent" 

#Flag hint requests
d$hint<-0
d$hint[d$Student.Response.Type == "HINT_REQUEST"] <- 1

#Flag incorrect answers
d$error<-0
d$error[d$Outcome == "InCorrect"] <- 1 

#number of hints per student/problem
#number of errors per student/problem
sumStats<-ddply(d, .(Anon.Student.Id,Problem.Name,Day,Condition), summarise, hints_req=sum(hint), num_errors=sum(error)) 

#merge together into problem-level data
problems <- merge(sumStats,minSpent, by=c("Anon.Student.Id","Problem.Name","Day","Condition"))

#order problem-level data
problems <- problems[order(problems$Anon.Student.Id, problems$Day, problems$Problem.Name) , ]

#write it out it doesn't take forever
write.csv(problems, paste(dataPath, "problems.csv", sep=""))