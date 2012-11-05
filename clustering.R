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
