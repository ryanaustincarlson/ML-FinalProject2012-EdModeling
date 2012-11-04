require(plyr)

# read the data
setwd("/Users/lizzie/Dropbox/fall2012classes/10-701/ML-FinalProject2012-EdModeling-master/data")
df1 <- read.csv("data-csv1.csv")
df2 <- read.csv("data-csv2.csv")

# discard some unnecessary columns
df3 <- df1[,c(1,3,4,5,6,10,13,14,15,16,17,20,21,22,23,24,25,28,29,30,31,32,39,40)]
df4 <- df2[,c(1,3,4,5,6,10,13,14,15,16,17,20,21,22,23,24,25,28,29,30,31,32,39,40)]

# Reversing the order of those two columns that are switched in one half of the dataset:
df3 <-cbind(df3[,c(1:9,11,10,12:24)])

# so now we have:
# > all.equal(names(df3), names(df4))
# [1] TRUE

# taking out the TPAs and binding everything together:
tpas3 <- which(df3$Student.Response.Subtype=="tutor-performed")
tpas4 <- which(df4$Student.Response.Subtype=="tutor-performed")
df5 <- df3[-tpas3,]
df6 <- df4[-tpas4,]
df<-rbind(df5,df6)

# turn all the factor columns into character strings, as they should be
# turn the Time column into a POSIXct object, so we can interpret it
# turn the Time column into a number of seconds, so we can do math with it. To convert back to POSIXct, run as.POSIXct(d2, origin="1969-12-31 19:00.00")
df$Anon.Student.Id <- as.character(df$Anon.Student.Id)
df$Condition <- as.character(df$Condition)
df$Session.Id <- as.character(df$Session.Id)
# df$Time <- as.character(df$Time)
# df$Time <- as.POSIXct(df$Time)
# df$Time <- unclass(df$Time)
df$Day <- as.character(df$Day)
df$myDuration <- as.character(df$myDuration)
df$Student.Response.Type <- as.character(df$Student.Response.Type)
df$Level.ProblemSet. <- as.character(df$Level.ProblemSet.)
df$Step.Name <- as.character(df$Step.Name)
df$Outcome <- as.character(df$Outcome)
df$Input <- as.character(df$Input)
df$School <- as.character(df$School)
df$Class <- as.character(df$Class)

# taking out myduration_wotpa because it doesn't have a value for hint requests
df <- df[,-8]

# taking out outcome_woTPA as unnecessary
df <- df[,-16]

# taking out studentResponseType_woTPA and Student.Response.Subtype as unnecessary
df <- df[,-c(9,10)]

# Converting myDuration into a number of seconds:
Step.Duration <- 60*as.numeric(substr(df$myDuration, 1,2)) + as.numeric(substr(df$myDuration, 4,7))

df <- cbind(df, Step.Duration)

time.after.hint <- function(indices){
	return(Step.Duration[c(indices+rep(1,length(indices)))])
}

# Aggregating the steps into problems:
data2 <- ddply(df, .(Anon.Student.Id, Level.ProblemSet., Problem.Name), summarise, 
	Problem.Duration=sum(Step.Duration),
	Hints.Requested=sum(Student.Response.Type=="HINT_REQUEST", na.rm=TRUE),
	Correct=sum(Outcome=="Correct", na.rm=TRUE),
	Incorrect=sum(Outcome=="InCorrect", na.rm=TRUE),
	Attempts=sum(Outcome=="Correct", na.rm=TRUE)+sum(Outcome=="InCorrect", na.rm=TRUE),
	Performance=sum(Outcome=="Correct", na.rm=TRUE)/(sum(Outcome=="Correct", na.rm=TRUE)+sum(Outcome=="InCorrect", na.rm=TRUE)),
	Hints.1=sum(Help.Level=="1", na.rm=TRUE),
	Hints.2=sum(Help.Level=="2", na.rm=TRUE),
	Hints.3=sum(Help.Level=="3", na.rm=TRUE),
	Hints.4=sum(Help.Level=="4", na.rm=TRUE)
	)
	
# Aggregating over problems:
data3 <- ddply(data2, .(Anon.Student.Id), summarise, 
	Mean.Prob.Dur=mean(Problem.Duration), 
	Med.Prob.Dur=median(Problem.Duration), 
	Var.Prob.Dur=var(Problem.Duration), 
	IQR.Prob.Dur=IQR(Problem.Duration),
	Num.Probs.Attempted=length(Problem.Duration),
	Avg.Hints.Per.Prob=mean(Hints.Requested),
	Avg.Hints1.Per.Prob=mean(Hints.1),
	Avg.Hints2.Per.Prob=mean(Hints.2),
	Avg.Hints3.Per.Prob=mean(Hints.3),
	Avg.Hints4.Per.Prob=mean(Hints.4),
	Mean.Correct=mean(Correct), 
	Med.Correct=median(Correct), 
	Var.Correct=var(Correct), 
	IQR.Correct=IQR(Correct, na.rm=TRUE),
	Mean.Incorrect=mean(Incorrect), 
	Med.Incorrect=median(Incorrect), 
	Var.Incorrect=var(Incorrect), 
	IQR.Incorrect=IQR(Incorrect, na.rm=TRUE),
	Mean.Performance=mean(Performance), 
	Med.Performance=median(Performance), 
	Var.Performance=var(Performance), 
	IQR.Performance=IQR(Performance, na.rm=TRUE),
	Mean.Attempts=mean(Attempts), 
	Med.Attempts=median(Attempts), 
	Var.Attempts=var(Attempts), 
	IQR.Attempts=IQR(Attempts, na.rm=TRUE)
	)
	
# Aggregating over the whole dataset, by student:
data4 <- ddply(df, .(Anon.Student.Id), summarise, 
	Mean.Step.Dur=mean(Step.Duration), 
	Med.Step.Dur=median(Step.Duration),
	Var.Step.Dur=var(Step.Duration),
	IQR.Step.Dur=IQR(Step.Duration, na.rm=TRUE),
	Time.In.Tutor=sum(Step.Duration),
	Tot.Hints.Requested=sum(Student.Response.Type=="HINT_REQUEST", na.rm=TRUE),
	Tot.Hints.1=sum(Help.Level=="1", na.rm=TRUE),
	Tot.Hints.2=sum(Help.Level=="2", na.rm=TRUE),
	Tot.Hints.3=sum(Help.Level=="3", na.rm=TRUE),
	Tot.Hints.4=sum(Help.Level=="4", na.rm=TRUE),
	Mean.Time.After.Hint=mean(time.after.hint(which(Student.Response.Type=="HINT_REQUEST"))),
	Median.Time.After.Hint=median(time.after.hint(which(Student.Response.Type=="HINT_REQUEST"))),
	Var.Time.After.Hint=var(time.after.hint(which(Student.Response.Type=="HINT_REQUEST"))),
	IQR.Time.After.Hint=IQR(time.after.hint(which(Student.Response.Type=="HINT_REQUEST")), na.rm=TRUE),
	Hints.GT.0.Sec=sum(time.after.hint(which(Student.Response.Type=="HINT_REQUEST"))>=0),
	Hints.GT.1.Sec=sum(time.after.hint(which(Student.Response.Type=="HINT_REQUEST"))>=1),
	Hints.GT.2.Sec=sum(time.after.hint(which(Student.Response.Type=="HINT_REQUEST"))>=2),
	Hints.GT.3.Sec=sum(time.after.hint(which(Student.Response.Type=="HINT_REQUEST"))>=3),
	Hints.GT.5.Sec=sum(time.after.hint(which(Student.Response.Type=="HINT_REQUEST"))>=5),
	Hints.GT.7.Sec=sum(time.after.hint(which(Student.Response.Type=="HINT_REQUEST"))>=7),
	Mean.InCorrect.Step.Dur=mean(Step.Duration[which(df$Outcome=="InCorrect")], na.rm=TRUE),
	Median.InCorrect.Step.Dur=median(Step.Duration[which(df$Outcome=="InCorrect")], na.rm=TRUE),
	Var.InCorrect.Step.Dur=var(Step.Duration[which(df$Outcome=="InCorrect")], na.rm=TRUE),
	IQR.InCorrect.Step.Dur=IQR(Step.Duration[which(df$Outcome=="InCorrect")], na.rm=TRUE),
	InCorrect.LT.1.Sec=sum(Step.Duration[which(df$Outcome=="InCorrect")]<=1, na.rm=TRUE),
	InCorrect.LT.2.Sec=sum(Step.Duration[which(df$Outcome=="InCorrect")]<=2, na.rm=TRUE),
	InCorrect.LT.3.Sec=sum(Step.Duration[which(df$Outcome=="InCorrect")]<=3, na.rm=TRUE),
	InCorrect.LT.4.Sec=sum(Step.Duration[which(df$Outcome=="InCorrect")]<=4, na.rm=TRUE),
	InCorrect.LT.5.Sec=sum(Step.Duration[which(df$Outcome=="InCorrect")]<=5, na.rm=TRUE),
	InCorrect.LT.6.Sec=sum(Step.Duration[which(df$Outcome=="InCorrect")]<=6, na.rm=TRUE),
	InCorrect.LT.7.Sec=sum(Step.Duration[which(df$Outcome=="InCorrect")]<=7, na.rm=TRUE),
	InCorrect.LT.10.Sec=sum(Step.Duration[which(df$Outcome=="InCorrect")]<=10, na.rm=TRUE),
	InCorrect.LT.15.Sec=sum(Step.Duration[which(df$Outcome=="InCorrect")]<=15, na.rm=TRUE)
	)

# sticking everything together:
data5 <- cbind(data3, data4[,2:ncol(data4)])
data6 <- ddply(df, .(Anon.Student.Id), summarise, School=School[1], Class=Class[1], Condition=Condition[1])
data7 <- cbind(data5, data6[,2:3])

# adding data for the outcome variables (pretest, posttest, delayedposttest)
secondset <- read.csv("alltestsOutliers2-3_045-8h_singleMultiple_HLM_learningEffects.csv")

# separating out the sections by which test they're about
secondset1<-secondset[which(secondset$test==1),]
secondset2<-secondset[which(secondset$test==2),]
secondset3<-secondset[which(secondset$test==3),]

# renaming the sections with a test-related prefix so we don't get confused between the different variables
names(secondset1)<-paste("Pre_", names(secondset1), sep="")
names(secondset2)<-paste("Post_", names(secondset2), sep="")
names(secondset3)<-paste("DelPost_", names(secondset3), sep="")

# reordering the data frames so the student IDs all line up
secondset1o<-secondset1[order(secondset1$Pre_student),]
secondset2o<-secondset2[order(secondset2$Post_student),]
secondset3o<-secondset3[order(secondset3$DelPost_student),]

# binding everything together
data8 <- cbind(data7, secondset1o[,2:ncol(secondset1o)], secondset2o[,2:ncol(secondset2o)], secondset3o[,2:ncol(secondset3o)] )

# whoops, I forgot the Condition vector:
data9 <-cbind(data8[,1], data6[,4], data8[,2:ncol(data8)])

# List of variables to include:
# Still need to add:
# number of incorrect attempts before hint request
# repeat hint cutoff construction for each level of hint
# repeat for all combinations of levels of hints

# Done:
#DONE# average time/problem
#DONE# median time/problem
#DONE# variance time/problem
#DONE# iqr time/problem

#DONE# average time/step
#DONE# median time/step
#DONE# variance time/step
#DONE# iqr time/step

#DONE# number of hints requested/problem
#DONE# number of hints of each level requested/problem

#DONE# number of correct answers/problem
#DONE# number of incorrect answers/problem

#DONE# number of problems answered
#DONE# time on tutor

#DONE# average time after hint
#DONE# median time after hint
#DONE# variance time after hint
#DONE# iqr time after hint
#DONE# number of hints with time after greater than cut-off:
#DONE# cutoff defined over all deciles of range of time after hint for all students

#DONE# number of incorrect attempts with step.duration smaller than cutoff 
#DONE# mean step.duration of incorrect attempts
#DONE# median step.duration of incorrect attempts
#DONE# variance of step.duration of incorrect attempts
#DONE# IQR of step.duration of incorrect attempts


# Here's how I set the levels of cutoffs - I found the deciles for the variable and just used all the unique deciles:
# levels(as.factor(quantile(timeafter, probs=c(.1, .2, .3, .4, .5, .6, .7, .8, .9))))

# this isn't working right yet - it's supposed to get the number of incorrect answers before a hint in a given problem
# incorrect.before.hint <- function(indices){
	# incorrect.indices <- which(Outcome=="InCorrect")
	# for (i in 1:length(indices)){
		# incorrectbefore <- sum(incorrect.indices<indices[i]&&incorrect.indices>indices[i-1])
	# }	
	# return(sum(incorrectbefore))
# }

# incorrect.before.hint <- function(indices){
	# incorrect.indices <- which(df$Outcome[1:50]=="InCorrect")
	# for (i in 1:length(indices)){
		# incorrectbefore <- sum(incorrect.indices<indices[i]&&incorrect.indices>indices[i-1])
	# }	
	# return(sum(incorrectbefore))
# }
