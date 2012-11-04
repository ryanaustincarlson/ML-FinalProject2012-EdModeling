require(plyr)

#set path here
dataPath <- "data/"

#load, sort data
d <- read.csv(paste(dataPath, "problems.csv", sep=""))

#Create problem numbers that are cumulative across sessions
numberProblems <- function(df) {
	df$problemNum<-row(df)[,1]
	df
}
problems <- ddply(problems, .(Anon.Student.Id), numberProblems)

#Error behaviour over time
errorsOverTime <-function(df) {
	#fit a linear model for each student: 
	#num_errors = beta*problemNum + alpha
	betas<-lm(formula = num_errors ~ problemNum, data=df)
	
	#extract coefficients
	df$deltaErrors <- coef(betas)["problemNum"]
	df$intrcpErrors <- coef(betas)["(Intercept)"]
	df
}

problems <- ddply(problems, .(Anon.Student.Id), errorsOverTime)

#Hint seeking behaviour over time
hintsOverTime <-function(df) {
	#fit a linear model for each student: 
	#hints_req = beta*problemNum + alpha
	betas<-lm(formula = hints_req ~ problemNum, data=df)
	
	#extract coefficients
	df$deltaHints <- coef(betas)["problemNum"]
	df$intrcpHints <- coef(betas)["(Intercept)"]
	df
}

problems <- ddply(problems, .(Anon.Student.Id), hintsOverTime)



#summary(d$Student.Response.Type)
#nrow(d[ which(d$hint==1),])
#nrow(d[ which(d$hint==0),])


#Attempt to identify conceptual questions
#grep("[a-z]",d[1:100,"Input"], value=TRUE)

#nrow(d[which(d$Anon.Student.Id=="Stu_fb73356c923072b0b3a3bae4d71a327a" & d$Problem.Name==28&d$Student.Response.Type=="HINT_REQUEST"),])


