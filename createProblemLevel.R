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

# transition matrix
transition.matrix <- function(x) {
  table( x[1:length(x)-1], x[2:length(x)] )
}

# Outcome-specific transition matrix
outcome.transition.matrix <- function(df) {
  tt <- transition.matrix(df$Outcome)
  num_incorrect <- table(df$Outcome)[3]
  
  # if the data is "flawless", then we'll get a bunch of
  # NaN's, which look dumb, so just put zeros here
  #
  # TODO: we could do some basic smoothing, but it should
  #       be something small like +.01 or something
  # OR could also just say that's equivalent to P(Inc->Cor) = 1 .. I kinda like that better -RC
  if (num_incorrect == 0) {
    return(c(0,0,0))
  }
  incorrect_to_correct <- tt[3,1] / num_incorrect
  incorrect_to_hint <- tt[3,2] / num_incorrect
  incorrect_to_incorrect<-tt[3,3] / num_incorrect
  c(incorrect_to_correct, incorrect_to_hint, incorrect_to_incorrect)
}

sample<-d[1:100,]
outcome.transition.matrix(sample)

transitionMatrices<-ddply(sample, .(Anon.Student.Id,Problem.Name,Day,Condition), outcome.transition.matrix)
names(transitionMatrices)[names(transitionMatrices)=="V1"] <- "Inc->Cor"
names(transitionMatrices)[names(transitionMatrices)=="V2"] <- "Inc->Hint"
names(transitionMatrices)[names(transitionMatrices)=="V3"] <- "Inc->Inc"
transitionMatrices

#merge together into problem-level data
problems <- merge(sumStats,minSpent, by=c("Anon.Student.Id","Problem.Name","Day","Condition"))
problems <- merge(problems,transitionMatrices, by=c("Anon.Student.Id","Problem.Name","Day","Condition"))

#order problem-level data
problems <- problems[order(problems$Anon.Student.Id, problems$Day, problems$Problem.Name) , ]

#write it out it doesn't take forever
write.csv(problems, paste(dataPath, "problems.csv", sep=""))