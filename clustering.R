library(poLCA)
library(graphics)
library(mclust)
library(vcd)

dataPath <- "data/"

#load, sort data
students <- read.csv(paste(dataPath, "students-nominalized.csv", sep=""))

MAXITER <- 5000

LCA <- function(students, nclass, graphs=FALSE)
{
  if (graphs)
  {
    png(file = paste(dataPath, "lca-class-viz.png", sep=""), width = 1000, height = 700)  
  }
  x <- poLCA(LCAfeatures, students, nclass=nclass, maxiter=MAXITER, nrep=1, graphs=graphs)
  if (graphs)
  {
    dev.off()
  }
  x
}

LCAstats <- function(students, nclasses)
  # nclasses is a range, i.e. 1:4
{
  stats <- data.frame()

  for(nclass in nclasses) {
    lc <- LCA(students, nclass)
    print("<---------------------->")
    stats <- rbind(stats, data.frame(aic=lc$aic, bic=lc$bic, 
                                     Gsq=lc$Gsq, Chisq=lc$Chisq, 
                                     params=lc$npar, degfree=lc$resid.df,
                                     loglik=lc$llik))
  }
  stats
}

plotStats <- function(allstats)
{
  
  x1 <- 1:length(allstats$bic)
  y1 <- allstats$bic
  x2 <- 1:length(allstats$aic)
  y2 <- allstats$aic
  
  color1 <- "blue"; pch1 <- 1;
  color2 <- "red"; pch2 <- 2;
  
  plot.it <- function()
  {
    plot(x1, y1, col=color1, pch=pch1, lwd=3,
         ylab="", xlab="# Latent Classes", xlim=range(x1,x2), ylim=range(y1,y2))
    points(x2,y2, col=color2, pch=pch2, lwd=3)
    legend("topright", title = "legend", 
           legend = c("BIC","AIC"), pch = c(pch1, pch2), 
           col = c(color1, color2) ,inset = .02)      
  }
  
  plot.it()
  png(file = paste(dataPath, "lca-stats-plot.png", sep=""), width = 1000, height = 600)
  plot.it()
  dev.off()
}

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

#LCAfeatures <- cbind(hints_req, num_errors, minSpent, Inc..Cor, Inc..Hint, Inc..Inc, NumBOH) ~ 1 
LCAfeatures <- cbind(
  #pre_test,
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
  #hintsGeom, 
  #errorsGeom, 
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


allstats <- LCAstats(students, 1:10)
allstats
plotStats(allstats)

nBestClass <- 4
lc <- LCA(students, nBestClass, graphs=TRUE)
students$latent <- as.vector(by(students, 1:nrow(students), chooseBestLatentClass, lc, nBestClass))

write.csv(students, paste(dataPath, "students-latent.csv", sep=""))