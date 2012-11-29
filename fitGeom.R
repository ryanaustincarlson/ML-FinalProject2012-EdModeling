require(ggplot2)
require(plyr)
require(MASS)

firstThirty<-d[d$stepNumber<31,]
firstThirty<-firstThirty[firstThirty$stepTime>0,]

#Condition by Step
conditions<-ddply(firstThirty[,c("Condition","stepNumber","error","hint","stepTime","firstHint")], .(Condition, stepNumber), summarise, numErrors=sum(error),numHints=sum(hint),steptime=sum(stepTime),firstHint=sum(firstHint))
qplot(x=stepNumber, y=numErrors, data=conditions, color=Condition, geom="path")
qplot(x=stepNumber, y=numHints, data=conditions, color=Condition, geom="path")
qplot(x=stepNumber, y=steptime, data=conditions, color=Condition, geom="path")

#Condition by Quartile
conditionsQuart<-ddply(firstThirty[,c("Condition","stepQuartile","error","hint","stepTime","firstHint")], .(Condition, stepQuartile), summarise, numErrors=sum(error),numHints=sum(hint),steptime=sum(stepTime),firstHint=sum(firstHint))
qplot(x=stepQuartile, y=numErrors, data=conditionsQuart, color=Condition, geom="path")
qplot(x=stepQuartile, y=numHints, data=conditionsQuart, color=Condition, geom="path")
qplot(x=stepQuartile, y=steptime, data=conditionsQuart, color=Condition, geom="path")

$Students by Step
students<-ddply(firstThirty[,c("Anon.Student.Id","stepNumber","error","hint","stepTime","firstHint")], .(Anon.Student.Id, stepNumber), summarise, numErrors=sum(error),numHints=sum(hint),steptime=sum(stepTime),firstHint=sum(firstHint))

qplot(x=stepNumber, y=numErrors, data=students[1:300,], facets=~Anon.Student.Id, geom="path")
qplot(x=stepNumber, y=firstHint, data=students[1:300,], facets=~Anon.Student.Id, geom="path")
qplot(x=stepNumber, y=numHints, data=students[1:450,], facets=~Anon.Student.Id, geom="path")
qplot(x=stepNumber, y=steptime, data=students[1:300,], facets=~Anon.Student.Id, geom="path")

fitGeom <-function(df) {
	fit<-fitdistr(df[,2],"geometric")
	as.data.frame(fit$estimate)
}
firstHintGeom<-ddply(students[,c("Anon.Student.Id","firstHint")],.(Anon.Student.Id), fitGeom)
hintsGeom<-ddply(students[,c("Anon.Student.Id","numHints")],.(Anon.Student.Id), fitGeom)
errorsGeom<-ddply(students[,c("Anon.Student.Id","numErrors")],.(Anon.Student.Id), fitGeom)

$Students by Quartile
studentsQuartile<-ddply(firstThirty[,c("Anon.Student.Id","stepQuartile","error","hint","stepTime","firstHint")], .(Anon.Student.Id, stepQuartile), summarise, numErrors=sum(error),numHints=sum(hint),steptime=sum(stepTime),firstHint=sum(firstHint))

qplot(x=stepQuartile, y=numErrors, data=students[1:300,], facets=~Anon.Student.Id, geom="path")
qplot(x=stepQuartile, y=numHints, data=students[1:450,], facets=~Anon.Student.Id, geom="path")
qplot(x=stepQuartile, y=steptime, data=students[1:300,], facets=~Anon.Student.Id, geom="path")





write.csv(summary, paste(dataPath, "summaryQuartile.csv"))
