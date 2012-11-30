library(poLCA)
library(graphics)
library(mclust)

dataPath <- "data/"

#load, sort data
students <- read.csv(paste(dataPath, "students-nominalized.csv", sep=""))

MAXITER <- 5000

#LCAfeatures <- cbind(hints_req, num_errors, minSpent, Inc..Cor, Inc..Hint, Inc..Inc, NumBOH) ~ 1 
LCAfeatures <- cbind(
  hints_req, 
  num_errors, 
  minSpent,
  #deltaErrors, 
  #intrcpErrors, 
  #deltaHints, 
  #intrcpHints, 
  #Inc..Cor, 
  #Inc..Hint, 
  #Inc..Inc, 
  NumBOH,
  firstHintGeom, 
  hintsGeom, 
  errorsGeom, 
  stubbornGeom
  #numErrors1, 
  #numErrors2, 
  #numErrors3, 
  #numErrors4, 
  #numHints1, 
  #numHints2, 
  #numHints3, 
  #numHints4,
  #steptime1, 
  #steptime2, 
  #steptime3, 
  #steptime4, 
  #firstHint1, 
  #firstHint2, 
  #firstHint3, 
  #firstHint4
  ) ~ 1 

head(students)


LCA <- function(students, nclass)
{
  poLCA(LCAfeatures, students, nclass=nclass, maxiter=MAXITER, nrep=20)
}

LCAstats <- function(students, nclasses)
  # nclasses is a range, i.e. 1:4
{
  stats <- data.frame()

  for(nclass in nclasses) {
    lc <- LCA(students, nclass)
    stats <- rbind(stats, data.frame(aic=lc$aic, bic=lc$bic, 
                                     Gsq=lc$Gsq, Chisq=lc$Chisq, 
                                     params=lc$npar, degfree=lc$resid.df,
                                     loglik=lc$llik))
  }
  stats
}

allstats <- LCAstats(students, 1:10)
allstats

plotStats <- function(allstats)
{
  
  x1 <- 1:length(allstats$aic)
  y1 <- allstats$aic
  x2 <- 1:length(allstats$bic)
  y2 <- allstats$bic
  
  plot(x1, y1, col="green", ylab="", xlab="# Latent Classes", xlim=range(x1,x2), ylim=range(y1,y2))
  points(x2,y2, col="red")
}
plotStats(allstats)

chooseBestLatentClass <- function(student, lc, nclasses)
{
  features <- names(lc$probs)
  classprobs <- rep(1, nclasses)
  for (feature in features)
  {
    latent_distribution <- as.data.frame(lc$probs[[feature]])
    student_value <- student[[feature]]
    
    prob <- latent_distribution[[paste("Pr(",student_value,")", sep="")]]
    classprobs <- classprobs * prob
    
    #print(latent_distribution)
    #print(student_value)
    #print(prob)
    #print(classprobs)
    #print("-")
  }
  which.max(classprobs)
}

nBestClass <- 5
lc <- LCA(students, nBestClass)
#lc <- LCA(students, nBestClass)
students$latent <- by(students, 1:nrow(students), chooseBestLatentClass, lc, nBestClass)
chisq.test(table(students$latent,students$Condition))