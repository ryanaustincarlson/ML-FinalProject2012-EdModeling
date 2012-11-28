library(poLCA)
library(graphics)
library(mclust)

dataPath <- "data/"

#load, sort data
students <- read.csv(paste(dataPath, "students-nominalized.csv", sep=""))


head(students)

LCAstats <- function(students, nclasses)
  # nclasses is a range, i.e. 1:4
{
  stats <- data.frame()
  f <- cbind(hints_req, num_errors, minSpent, Inc..Cor, Inc..Hint, Inc..Inc, NumBOH) ~ 1 
  for(nclass in nclasses) {
    lc <- poLCA(f,students, nclass=nclass)
    stats <- rbind(stats, data.frame(aic=lc$aic, bic=lc$bic, Gsq=lc$Gsq, Chisq=lc$Chisq))
  }
  stats
}

LCA <- function(students, nclass)
{
  f <- cbind(hints_req, num_errors, minSpent, Inc..Cor, Inc..Hint, Inc..Inc, NumBOH) ~ 1 
  poLCA(f, students, nclass=nclass)
}

allstats <- LCAstats(students, 1:10)
allstats


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

lc <- LCA(students, 4)
students$latent <- by(students, 1:nrow(students), chooseBestLatentClass, lc, 4)


" # my multiline comment..
x <- cbind(matrix(students$hints_req), 
           matrix(students$num_errors),
           matrix(students$minSpent),
           matrix(students$Inc..Cor),
           matrix(students$Inc..Hint),
           matrix(students$Inc..Inc),
           matrix(students$NumBOH))

# Model Based Clustering
#fit <- Mclust(x)
#plot(fit, x) # plot results 
#print(fit) # display the best model

# Ward Hierarchical Clustering
d <- dist(x, method = "euclidean") # distance matrix
fit <- hclust(x)#, method="ward") 
plot(fit) # display dendogram
groups <- cutree(fit, k=5) # cut tree into 5 clusters
# draw dendogram with red borders around the 5 clusters 
rect.hclust(fit, k=5, border="red")

# # a 2-dimensional example
# x <- rbind(matrix(rnorm(100, sd = 0.3), ncol = 2),
#            matrix(rnorm(100, mean = 1, sd = 0.3), ncol = 2))
# colnames(x) <- c("x", "y")
# (cl <- kmeans(x, 2))
# plot(x, col = cl$cluster)
# points(cl$centers, col = 1:2, pch = 8, cex=2)
"