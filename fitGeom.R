require(ggplot2)
require(plyr)
require(MASS)

d <- read.csv(paste(dataPath, "featuresTS.csv", sep=""))

fitGeom <-function(df) {
	fit<-fitdistr(df[,2],"geometric")
	as.data.frame(fit$estimate)
}

#Errors before first Hint
errorCount <-function(df) {
	errorsBeforeHint<-(-99)
	i<-min(df[df$firstHint==1,]$stepNumber)
	if(i<Inf) {
		df<-df[1:i,]
		errorsBeforeHint<-sum(df$error)
	}
	as.data.frame(errorsBeforeHint)
}
errorsBeforeHint<-ddply(d[,c("Anon.Student.Id","Day","Problem.Name","stepNumber","hint","firstHint","error")], .(Anon.Student.Id,Day,Problem.Name), errorCount)
errorsBeforeHint<-errorsBeforeHint[errorsBeforeHint$errorsBeforeHint!=(-99),]
errorsBeforeHint$count<-1
stubborn<-ddply(errorsBeforeHint,.(Anon.Student.Id,errorsBeforeHint),summarise,count=sum(count))

stubbornGeom<-ddply(stubborn[,c("Anon.Student.Id","count")],.(Anon.Student.Id), fitGeom)
colnames(stubbornGeom)[length(colnames(stubbornGeom))]<-"stubbornGeom"

qplot(x=errorsBeforeHint,y=count,data=stubborn[1:200,],facets=~Anon.Student.Id,geom="path")

firstThirty<-d[d$stepNumber<31,]
firstThirty<-firstThirty[firstThirty$stepTime>0,]

#Condition by Step
conditions<-ddply(firstThirty[,c("Condition","stepNumber","error","hint","stepTime","firstHint")], .(Condition, stepNumber), summarise, numErrors=sum(error),numHints=sum(hint),steptime=sum(stepTime),firstHint=sum(firstHint))
qplot(x=stepNumber, y=firstHint, data=conditions, color=Condition, geom="path")
qplot(x=stepNumber, y=numErrors, data=conditions, color=Condition, geom="path")
qplot(x=stepNumber, y=numHints, data=conditions, color=Condition, geom="path")
qplot(x=stepNumber, y=steptime, data=conditions, facets=~Condition, geom="path")

#Condition by Quartile
conditionsQuart<-ddply(firstThirty[,c("Condition","stepQuartile","error","hint","stepTime","firstHint")], .(Condition, stepQuartile), summarise, numErrors=sum(error),numHints=sum(hint),steptime=sum(stepTime),firstHint=sum(firstHint))
qplot(x=stepQuartile, y=firstHint, data=conditionsQuart, color=Condition, geom="path")
qplot(x=stepQuartile, y=numErrors, data=conditionsQuart, color=Condition, geom="path")
qplot(x=stepQuartile, y=numHints, data=conditionsQuart, color=Condition, geom="path")
qplot(x=stepQuartile, y=steptime, data=conditionsQuart, color=Condition, geom="path")

$Students by Step
students<-ddply(firstThirty[,c("Anon.Student.Id","stepNumber","error","hint","stepTime","firstHint")], .(Anon.Student.Id, stepNumber), summarise, numErrors=sum(error),numHints=sum(hint),steptime=sum(stepTime),firstHint=sum(firstHint))

qplot(x=stepNumber, y=numErrors, data=students[1:300,], facets=~Anon.Student.Id, geom="path")
qplot(x=stepNumber, y=firstHint, data=students[1:300,], facets=~Anon.Student.Id, geom="path")
qplot(x=stepNumber, y=numHints, data=students[1:450,], facets=~Anon.Student.Id, geom="path")
qplot(x=stepNumber, y=steptime, data=students[1:300,], facets=~Anon.Student.Id, geom="path")


firstHintGeom<-ddply(students[,c("Anon.Student.Id","firstHint")],.(Anon.Student.Id), fitGeom)
colnames(firstHintGeom)[length(colnames(firstHintGeom))]<-"firstHintGeom"
hintsGeom<-ddply(students[,c("Anon.Student.Id","numHints")],.(Anon.Student.Id), fitGeom)
colnames(hintsGeom)[length(colnames(hintsGeom))]<-"hintsGeom"
errorsGeom<-ddply(students[,c("Anon.Student.Id","numErrors")],.(Anon.Student.Id), fitGeom)
colnames(errorsGeom)[length(colnames(errorsGeom))]<-"errorsGeom"

$Students by Quartile
studentsQuartile<-ddply(firstThirty[,c("Anon.Student.Id","stepQuartile","error","hint","stepTime","firstHint")], .(Anon.Student.Id, stepQuartile), summarise, numErrors=sum(error),numHints=sum(hint),steptime=sum(stepTime),firstHint=sum(firstHint))

qplot(x=stepQuartile, y=numErrors, data=studentsQuartile[1:300,], facets=~Anon.Student.Id, geom="path")
qplot(x=stepQuartile, y=numHints, data=studentsQuartile[1:450,], facets=~Anon.Student.Id, geom="path")
qplot(x=stepQuartile, y=steptime, data=studentsQuartile[1:300,], facets=~Anon.Student.Id, geom="path")


reshape <- function(df) {
	df$numErrors1=df[df$stepQuartile==1,]$numErrors
	df$numErrors2=df[df$stepQuartile==2,]$numErrors
	df$numErrors3=df[df$stepQuartile==3,]$numErrors
	df$numErrors4=df[df$stepQuartile==4,]$numErrors
	df$numHints1=df[df$stepQuartile==1,]$numHints
	df$numHints2=df[df$stepQuartile==2,]$numHints
	df$numHints3=df[df$stepQuartile==3,]$numHints
	df$numHints4=df[df$stepQuartile==4,]$numHints
	df$steptime1=df[df$stepQuartile==1,]$steptime
	df$steptime2=df[df$stepQuartile==2,]$steptime
	df$steptime3=df[df$stepQuartile==3,]$steptime
	df$steptime4=df[df$stepQuartile==4,]$steptime
	df$firstHint1=df[df$stepQuartile==1,]$firstHint
	df$firstHint2=df[df$stepQuartile==2,]$firstHint
	df$firstHint3=df[df$stepQuartile==3,]$firstHint
	df$firstHint4=df[df$stepQuartile==4,]$firstHint
	
	df[1,c(1,7:length(colnames(df)))]
}

quartFeatures<-ddply(studentsQuartile,.(Anon.Student.Id),reshape)


geomFeatures<-merge(firstHintGeom,hintsGeom)
geomFeatures<-merge(geomFeatures,errorsGeom)
geomFeatures<-merge(geomFeatures,stubbornGeom,all=TRUE)

newFeatures<-merge(geomFeatures,quartFeatures)

write.csv(newFeatures, paste(dataPath, "newFeatures.csv"),sep="")

oldFeatures<-read.csv(paste(dataPath, "students.csv", sep=""))

allFeatures<-merge(oldFeatures,newFeatures)
allFeatures[allFeatures$stubbornGeom==NA,]<-1
write.csv(allFeatures, paste(dataPath,"allFeatures.csv"),sep="")
write.csv(summary, paste(dataPath, "summaryQuartile.csv"))
