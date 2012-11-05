library(poLCA)

dataPath <- "data/"

#load, sort data
problems <- read.csv(paste(dataPath, "problems.csv", sep=""))

# turn numeric variables into categorical values
#hints_req_cat <- 

require(graphics)

head(problems)

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

x <- cbind(matrix(problems$hints_req), 
           matrix(problems$num_errors),
           matrix(problems$minSpent),
           matrix(problems$Inc..Cor),
           matrix(problems$Inc..Hint),
           matrix(problems$Inc..Inc),
           matrix(problems$NumBOH))
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
