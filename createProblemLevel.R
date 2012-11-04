require(plyr)

#set path here
dataPath <- "data/"

#load, sort data
d <- read.csv(paste(dataPath, "studentPerformed.csv", sep=""))
d <- d[order(d$Anon.Student.Id, d$Problem.Name, d$Time) , ]
sample<-d[1:100,]


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

# either hint_button, get_next_hint_button_mc, or get_previous_hint_button_mc
hint.levels <- function(df) {
  selections <- df$Selection
  hintlevels <- NULL
  current_hintlevel <- 0
  for (i in 1:length(selections))
  {
    selection = selections[i]
    if (selection == "get_next_hint_button_mc") { current_hintlevel <- current_hintlevel + 1 }
    else if (selection == "get_previous_hint_button_mc") { current_hintlevel <- current_hintlevel - 1 }
    else { current_hintlevel <- 0 }
    hintlevels <- c(hintlevels, current_hintlevel)
  }
  hintlevels
}

num.BOH <- function(df) {
  hintlevels <- hint.levels(df)
  numBOHs <- 0
  numBOHs[1:length(hintlevels)] <- 0
  numBOHs[hintlevels == 3] <- 1
  sum(numBOHs)
}

numBOH<-ddply(d, .(Anon.Student.Id,Problem.Name,Day,Condition), num.BOH)
names(numBOH)[names(numBOH)=="V1"] <- "NumBOH"

#number of hints per student/problem
#number of errors per student/problem
sumStats<-ddply(d, .(Anon.Student.Id,Problem.Name,Day,Condition), summarise, hints_req=sum(hint), num_errors=sum(error)) 

# transition matrix
transition.matrix <- function(x) {
  table( x[1:length(x)-1], x[2:length(x)] )
}

# Outcome-specific transition matrix
outcome.transition.matrix <- function(df) {
  num_incorrect <- as.integer(as.matrix(table(df$Outcome))["InCorrect",])
  # if the data is "flawless", then we'll get a bunch of
  # NaN's, which look dumb, so just put zeros here
  #
  # TODO: we could do some basic smoothing, but it should
  #       be something small like +.01 or something
  # OR could also just say that's equivalent to P(Inc->Cor) = 1 .. I kinda like that better -RC
  if (num_incorrect == 0) {
    return(c(0,0,0))
  }
  if (length(df$Outcome) == 1) {
    return(c(0,0,0))
  }
    
  tt <- as.data.frame.matrix(transition.matrix(df$Outcome))
  incorrect_to_correct <- tt["InCorrect","Correct"] / num_incorrect
  incorrect_to_hint <- (tt["InCorrect","HINT"] + tt["InCorrect","HintRequest"]) / num_incorrect
  incorrect_to_incorrect<-tt["InCorrect","InCorrect"] / num_incorrect
  c(incorrect_to_correct, incorrect_to_hint, incorrect_to_incorrect)
}

#outcome.transition.matrix(sample)

transitionMatrices<-ddply(d, .(Anon.Student.Id,Problem.Name,Day,Condition), outcome.transition.matrix)
names(transitionMatrices)[names(transitionMatrices)=="V1"] <- "Inc->Cor"
names(transitionMatrices)[names(transitionMatrices)=="V2"] <- "Inc->Hint"
names(transitionMatrices)[names(transitionMatrices)=="V3"] <- "Inc->Inc"
#transitionMatrices

#merge together into problem-level data
problems <- merge(sumStats,minSpent, by=c("Anon.Student.Id","Problem.Name","Day","Condition"))
problems <- merge(problems,transitionMatrices, by=c("Anon.Student.Id","Problem.Name","Day","Condition"))
problems <- merge(problems,numBOH, by=c("Anon.Student.Id","Problem.Name","Day","Condition"))

#order problem-level data
problems <- problems[order(problems$Anon.Student.Id, problems$Day, problems$Problem.Name) , ]

#write it out it doesn't take forever
write.csv(problems, paste(dataPath, "problems.csv", sep=""))