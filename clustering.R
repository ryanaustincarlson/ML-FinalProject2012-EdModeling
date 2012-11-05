library(poLCA)
library(graphics)
library(mclust)

dataPath <- "data/"

#load, sort data
students <- read.csv(paste(dataPath, "students.csv", sep=""))

# turn numeric variables into categorical values
#hints_req_cat <- 


x <- cbind(matrix(students$hints_req), 
           matrix(students$num_errors),
           matrix(students$minSpent),
           matrix(students$Inc..Cor),
           matrix(students$Inc..Hint),
           matrix(students$Inc..Inc),
           matrix(students$NumBOH))


head(students)

# Model Based Clustering
fit <- Mclust(x)
plot(fit, x) # plot results 
print(fit) # display the best model

# # K-Means Clustering with 5 clusters
# fit <- kmeans(mydata, 5)
# 
# # Cluster Plot against 1st 2 principal components
# 
# # vary parameters for most readable graph
# library(cluster) 
# clusplot(mydata, fit$cluster, color=TRUE, shade=TRUE, 
#          labels=2, lines=0)
# 
# # Centroid Plot against 1st 2 discriminant functions
# library(fpc)
# plotcluster(mydata, fit$cluster)

x <- scale(x)
cl <- kmeans(x, 3)
cl$centers
plot(x, col = cl$cluster)
points(cl$centers, col = 1:2, pch = 8, cex=2)

# # a 2-dimensional example
# x <- rbind(matrix(rnorm(100, sd = 0.3), ncol = 2),
#            matrix(rnorm(100, mean = 1, sd = 0.3), ncol = 2))
# colnames(x) <- c("x", "y")
# (cl <- kmeans(x, 2))
# plot(x, col = cl$cluster)
# points(cl$centers, col = 1:2, pch = 8, cex=2)
