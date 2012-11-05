require(plyr)

#set path here
dataPath <- "data/"

#load, sort data
d <- read.csv(paste(dataPath, "problems.csv", sep=""))

# sumStats<-ddply(d, .(Anon.Student.Id,Problem.Name,Day,Condition), 
#    summarise, hints_req=sum(hint), num_errors=sum(error)) 
collapsed <- ddply(d, .(Anon.Student.Id, Condition), 
                   summarise, 
                   hints_req=mean(hints_req),
                   num_errors=mean(num_errors),
                   minSpent=mean(minSpent),
                   Inc..Cor=sum(Inc..Cor),
                   Inc..Hint=sum(Inc..Hint),
                   Inc..Inc=sum(Inc..Inc),
                   NumBOH=mean(NumBOH)
                   )

inctotal <- collapsed$Inc..Cor + collapsed$Inc..Hint + collapsed$Inc..Inc
collapsed$Inc..Cor <- collapsed$Inc..Cor / inctotal
collapsed$Inc..Hint <- collapsed$Inc..Hint / inctotal
collapsed$Inc..Inc <- collapsed$Inc..Inc / inctotal

write.csv(collapsed, paste(dataPath, "students.csv", sep=""))
